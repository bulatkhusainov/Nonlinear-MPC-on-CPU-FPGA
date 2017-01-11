clear;

addpath(strcat(pwd,'/auxilary_functions')); % add current folder to path to use variables_declaration.m

debug_mode = 1;
test_enable = 1; % enable unit testing
test_tol = 1e-4;

% add problem data to the workspace
problem_data;

cd gradient_code;
generate_gradient_code;
cd ..;

% generate C file for hessian evaluation
cd hessian_code;
generate_hessian_code;
cd ..;

% generate C file for constraints and jacobians evaluation
cd jacobian_code;
generate_jacobian_code;
cd ..;

% generate C file for bound constraints evaluation
cd bounds_code;
generate_bounds_code;
cd ..;

% generate C file for block evaluation
cd block_code;
generate_block_code;
cd ..;

% generate header file for all C files
generate_header;


