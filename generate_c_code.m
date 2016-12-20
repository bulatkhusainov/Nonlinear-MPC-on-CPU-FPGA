clear;
%% this part is problem dependent
% define integrator Butcher table
butcher_table_A = [0 0 0; 5/24 1/3 -1/24; 1/6 2/3 1/6];
butcher_table_beta =  [1/6; 2/3; 1/6];

d_type = 'float';
N = 5;
Ts = 0.1;
l = size(butcher_table_A,1); % number of integration staged per node
n_states = 2;
m_inputs = 1;
n_node_slack = 0;
n_term_slack = 0;
n_node_theta = n_states + m_inputs + n_node_slack + l*n_states;
n_term_theta = n_states + n_term_slack;

node_theta = sym('node_theta',[n_node_theta 1]);
x = node_theta(1:n_states);
u = node_theta(n_states+1:n_states+m_inputs);
s = node_theta(n_states+m_inputs+1:n_states+m_inputs+n_node_slack);
r = node_theta(n_states+m_inputs+n_node_slack+1: n_states+m_inputs+n_node_slack+l*n_states); % integrator intermediate steps
term_theta = sym('term_theta',[n_term_theta 1]);
term_x = term_theta(1:n_states);
term_s = term_theta(n_states+1:n_states+n_term_slack);

% define objective (function of x,u,s)
node_objective = [sqrt(3)*sin(x(1))+x(2); sqrt(4)*x(2); sqrt(5)*u(1)]; % least squares format
term_objective = [sqrt(8)*sin(term_x(1)); sqrt(4)*term_x(2)]; % least squares format

% define ode (function of x,u)
ode(1) = x(1)+x(2);
ode(2) = 2*x(1)^2 + x(2)^2 + u(1);

% define equality constraints with slack variables (function of x,u,s)
% to be added

% define bounds on x,u,s
% to be added


%% Hessian approximation for one node
% approximate Hessian with Gauss newton algorithm
node_jac_objective = jacobian(node_objective,node_theta);
node_hessian = node_jac_objective.'*node_jac_objective;
% determine hessian sparsity pattern
node_hessian_pattern = ones(n_node_theta);
for i = 1:n_node_theta
    for j = 1:n_node_theta
        if isequaln(node_hessian(i,j),0)
            node_hessian_pattern(i,j) = 0;
        end
    end
end

%% Objective term for terminal node
% approximate Jacobian with Gauss newton algorithm
term_jac_objective = jacobian(term_objective,term_theta);
term_hessian = term_jac_objective.'*term_jac_objective;
% determine hessian sparsity pattern
term_hessian_pattern = ones(n_term_theta);
for i = 1:n_term_theta
    for j = 1:n_term_theta
        if isequaln(term_hessian(i,j),0)
            term_hessian_pattern(i,j) = 0;
        end
    end
end


%% Integrator constraints
ode = matlabFunction(ode,'Vars', node_theta);
f = x + Ts*(butcher_table_beta(1)*r(1:n_states)+butcher_table_beta(2)*r(n_states+1:2*n_states)+butcher_table_beta(1)*r(2*n_states+1:3*n_states));
%c = f()


%% Generate code for hessian evaluation file
cd src 
fileID = fopen('hessians.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,'// this function evaluates node Hessian \n');
fprintf(fileID,strcat('void node_hessian_eval('));
fprintf(fileID,strcat('node_hessian[', 'n_node_theta',']'));
fprintf(fileID,strcat('[n_node_theta],node_theta[n_node_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_node_theta
    for j = 1:i
        if node_hessian_pattern(i,j) == 1
            tmp_var = ccode(node_hessian(i,j));
            tmp_var = regexprep(tmp_var, match_expr, strcat('node_theta[',replace_expr,']'));
            tmp_var = regexprep(tmp_var, 't0 = ', '');
            fprintf(fileID,'\tnode_hessian[%d][%d] = ',i-1,j-1);   
            fprintf(fileID,tmp_var); 
            fprintf(fileID,strcat('\n'));
        end        
    end
end
fprintf(fileID,'\n');  
fprintf(fileID,'// this function evaluates terminal Hessian \n');
fprintf(fileID,strcat('void term_hessian_eval('));
fprintf(fileID,strcat('term_hessian[', 'n_term_theta',']'));
fprintf(fileID,strcat('[n_term_theta],term_theta[n_term_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'term_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_term_theta
    for j = 1:i
        if term_hessian_pattern(i,j) == 1
            tmp_var = ccode(term_hessian(i,j));
            tmp_var = regexprep(tmp_var, match_expr, strcat('term_theta[',replace_expr,']'));
            tmp_var = regexprep(tmp_var, 't0 = ', '');
            fprintf(fileID,'\tterm_hessian[%d][%d] = ',i-1,j-1);   
            fprintf(fileID,tmp_var); 
            fprintf(fileID,strcat('\n'));
        end        
    end
end

fprintf(fileID,strcat('}\n'));
fclose(fileID);
cd ..



%% Generate main header file
cd src 
file_name = strcat('user_main_header','.h');
fileID = fopen(file_name,'w');
fprintf(fileID, strcat('#ifndef ',' MAIN_HEADER\n'));
fprintf(fileID, strcat('#define ',' MAIN_HEADER\n\n'));

fprintf(fileID, '#include <math.h>  \n');
fprintf(fileID, '#include <stdlib.h>  \n');
fprintf(fileID, '#include <stdio.h>  \n\n');

fprintf(fileID, '#define N %d \n',N);
fprintf(fileID, '#define Ts %d // sampling frequency \n\n',Ts);

fprintf(fileID, '//data for shooting node \n');
fprintf(fileID, '#define n_states %d // # of states \n',n_states);
fprintf(fileID, '#define m_inputs %d // # of inputs \n',m_inputs);
fprintf(fileID, '#define n_node_slack %d // # of slack variables \n', n_node_slack);
fprintf(fileID, '#define n_term_slack %d // # of slack variables for terminal term \n', n_term_slack);
fprintf(fileID, '#define n_node_theta %d  // # of optimization variables \n',n_node_theta);
fprintf(fileID, '#define n_term_theta %d  // # of optimization variables for terminal term \n\n',n_term_theta);

fprintf(fileID, '#endif');
fclose(fileID);
cd ..