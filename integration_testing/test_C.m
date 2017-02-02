tmp_str = 'mex mex_nlp_solver.c';
tmp_str = strcat(tmp_str, ' ../src/block.c');
tmp_str = strcat(tmp_str, ' ../src/bounds.c');
tmp_str = strcat(tmp_str, ' ../src/gradient.c');
tmp_str = strcat(tmp_str, ' ../src/hessians.c');
tmp_str = strcat(tmp_str, ' ../src/jacobians.c');
tmp_str = strcat(tmp_str, ' ../src/residual.c');
tmp_str = strcat(tmp_str, ' ../src/user_mv_mult.c');
tmp_str = strcat(tmp_str, ' ../src/user_lanczos.c');
tmp_str = strcat(tmp_str, ' ../src/user_minres.c');
tmp_str = strcat(tmp_str, ' ../src/user_rec_sol.c');
tmp_str = strcat(tmp_str, ' ../src/user_prescaler.c');
tmp_str = strcat(tmp_str, ' ../src/user_mv_mult_prescaled.c');
eval(tmp_str);

[all_theta_C, all_nu_C, all_lambda_C, debug_output] = mex_nlp_solver(x_init);


%tmp_var = max(size(all_lambda));

%debug_output = debug_output(1:tmp_var);

max(abs(all_theta_C - all_theta))

%max(abs(all_lambda - debug_output))
