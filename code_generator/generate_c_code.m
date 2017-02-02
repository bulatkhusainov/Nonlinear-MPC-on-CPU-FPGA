
addpath(strcat(pwd,'/auxilary_functions')); % add current folder to path to use variables_declaration.m

% add mex files to path
addpath(strcat(pwd,'/gradient_code/unit_test_files'));
addpath(strcat(pwd,'/hessian_code/unit_test_files'));
addpath(strcat(pwd,'/jacobian_code/unit_test_files'));
addpath(strcat(pwd,'/bounds_code/unit_test_files'));
addpath(strcat(pwd,'/block_code/unit_test_files'));

debug_mode = 1;
test_enable = 1; % enable unit testing
test_tol = 1e-4;

% add problem data to the workspace
problem_data;

% generate header file for all C files
generate_header;

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

% generate C file for residual evaluation
cd residual_code;
generate_residual_code;
cd ..;

% generate C file for mat-vec multiplication
cd mv_mult_code;
generate_mv_mult_code;
cd ..;

% generate C file for recovering solution
cd rec_sol_code;
generate_rec_sol_code;
cd ..;

% generate C file for prescaler
cd prescaler_code;
generate_prescaler_code;
cd ..;
