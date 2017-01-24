tmp_str = 'mex mex_nlp_solver.c';
tmp_str = strcat(tmp_str, ' ../src/block.c');
tmp_str = strcat(tmp_str, ' ../src/bounds.c');
tmp_str = strcat(tmp_str, ' ../src/gradient.c');
tmp_str = strcat(tmp_str, ' ../src/hessians.c');
tmp_str = strcat(tmp_str, ' ../src/jacobians.c');
tmp_str = strcat(tmp_str, ' ../src/residual.c');
tmp_str = strcat(tmp_str, ' ../src/user_mv_mult.c');
eval(tmp_str);

[all_theta_C, all_nu_C, all_lambda_C, debug_output] = mex_nlp_solver(x_init);

max(abs(A*b - debug_output))