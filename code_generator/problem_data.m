%% this part is problem dependent
% define integrator Butcher table
%butcher_table_A = [0]; % Euler integrator
%butcher_table_beta =  [1];
%butcher_table_A = [ 0 0; 0.5 0.5]; % Trapezoidal integrator
%butcher_table_beta =  [0.5; 0.5];
butcher_table_A = [0 0 0; 5/24 1/3 -1/24; 1/6 2/3 1/6]; % Simpson integrator
butcher_table_beta =  [1/6; 2/3; 1/6];



d_type = 'float';
N = 30;
Ts = 0.5;
n_stages = size(butcher_table_A,1); % number of integrator stages per node
n_states = 2;
m_inputs = 1;
n_node_slack = 1;
n_node_slack_eq = 1;
n_term_slack = 1;
n_term_eq = 1;
n_node_theta = n_states + m_inputs + n_node_slack + n_stages*n_states;
n_term_theta = n_states + n_term_slack;
n_node_eq = n_states*(n_stages+1) + n_node_slack_eq;


node_theta = sym('node_theta',[n_node_theta 1]);
x = node_theta(1:n_states);
u = node_theta(n_states+1:n_states+m_inputs);
s = node_theta(n_states+m_inputs+1:n_states+m_inputs+n_node_slack);
r = node_theta(n_states+m_inputs+n_node_slack+1: n_states+m_inputs+n_node_slack+n_stages*n_states); % integrator intermediate steps
term_theta = sym('term_theta',[n_term_theta 1]);
term_x = term_theta(1:n_states);
term_s = term_theta(n_states+1:n_states+n_term_slack);

% define objective (function of x,u,s)
node_objective_residual = [ sqrt(1)*(x(1)); 
                            sqrt(1)*(x(2)-2); 
                            sqrt(1)*(u(1)-2)]; % least squares format
term_objective_residual = [sqrt(1)*(term_x(1)); 
                           sqrt(1)*(term_x(2)-2)]; % least squares format

% define ode (function of x,u)
ode(1) = (1-x(2)^2)*x(1) - x(2) + u(1);
ode(2) = x(1);
%ode(1) = x(2);
%ode(2) = u(1);

% define equality constraints with slack variables (function of x,u,s)
%f_slack = [];
f_slack = sym(zeros(n_node_slack_eq,1));
f_slack(1) = x(1) - s(1);

%term_f = [];
term_f = sym(zeros(n_term_eq,1));
term_f(1) = term_x(1) - term_s(1);


% define bounds on x,u,s
% bound indeces [x' u' s']'
upper_bounds_indeces = [1 3]-1; % in C format
lower_bounds_indeces = [3]-1; % in C format
upper_bounds = [0.5 5];
lower_bounds = [-0.5];

n_upper_bounds = max(size(upper_bounds_indeces));
n_lower_bounds = max(size(lower_bounds_indeces));
n_bounds = n_upper_bounds + n_lower_bounds;


