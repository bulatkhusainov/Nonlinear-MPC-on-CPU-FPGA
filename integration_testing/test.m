% solve OCP problem using gradient, hessian, jacobian info from C 
% files using mex interfaces

% generate C code, compile mex and perform unit testing
cd ../code_generator
generate_c_code;
cd ../integration_testing

% add mex files to path
addpath(strcat(pwd,'/../code_generator/gradient_code/unit_test_files'));
addpath(strcat(pwd,'/../code_generator/hessian_code/unit_test_files'));
addpath(strcat(pwd,'/../code_generator/jacobian_code/unit_test_files'));

%clear the workspace and load only problem data
clear;
cd ../code_generator
problem_data;
cd ../integration_testing


% formulate and solve optimization problem

% initial condiiton
x_init = [0;1];

% intial guess
theta_all = zeros(n_node_theta*N+n_term_theta,1);
lambda_all = zeros(n_states + n_states*(n_stages+1)*N,1);


n_z = size(theta_all,1) + size(lambda_all,1); 
A = zeros(n_z,n_z);
b = zeros(n_z, 1);

%evaluate A matrix
A(n_states + 1:2*n_states, 1:n_states) = -eye(n_states); % initial condition
for i = 1:N
    node_Hessian = node_hessian_eval(theta_all((1:n_node_theta)+(i-1)*(n_node_theta) ));
    node_Hessian = vec2mat(node_Hessian,n_node_theta);
    node_jacobian = f_jac_eval(theta_all((1:n_node_theta)+(i-1)*(n_node_theta) ));
    node_jacobian = vec2mat(node_jacobian, n_node_theta);
    block = [node_Hessian node_jacobian'; node_jacobian zeros(size(node_jacobian,1))];
    A_index = ((1:size(block,1)) + n_states+(i-1)*size(block,1));
    A(A_index,A_index) = block;
    
    A_index_row = (1:n_states) + n_states + size(node_Hessian,1) + (i-1)*size(block,1);
    A_index_col = (1:n_states) + n_states + size(block,1) + (i-1)*size(block,1);
    A(A_index_row,A_index_col) = -eye(n_states);
    
end
% terminal hessian
term_hessian = term_hessian_eval(theta_all((1:n_term_theta)+(N)*(n_node_theta) ));
term_hessian = vec2mat(term_hessian, n_term_theta);
A(end-size(term_hessian,1)+1:end, end-size(term_hessian,1)+1:end) = term_hessian;
% symmetrize the matrix
A = tril(A);
A = A + tril(A,-1)';

%evaluate b
% handle jacobians transpose
for i = 1:N
    % process optimality error
    block_x = -node_gradient_eval(theta_all((1:n_node_theta)+(i-1)*(n_node_theta) ));
    node_jacobian_transpose = f_jac_eval(theta_all((1:n_node_theta)+(i-1)*(n_node_theta) ));
    node_jacobian_transpose = vec2mat(node_jacobian_transpose, n_node_theta);
    node_jacobian_transpose = node_jacobian_transpose';
    block_x = block_x - node_jacobian_transpose*lambda_all((1:n_states*(n_stages+1)) + n_states + (i-1)*n_states*(n_stages+1));
    % negative identity
    if i == 1
        block_x(1:n_states) = block_x(1:n_states) - lambda_all(1:n_states);
    else
        block_x((1:n_states) + (i-1)*(n_states*(n_stages+1)) ) = 
        block_x((1:n_states) + (i-1)*(n_states*(n_stages+1)) ) -lambda_all((1:n_states)+n_states+(i-1)*())
    end
    
    % process feasibility error
end


