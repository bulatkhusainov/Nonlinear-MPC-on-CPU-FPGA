tmp_str = 'mex mex_nlp_solver.c';
tmp_str = strcat(tmp_str, ' ../src/user_block.c');
tmp_str = strcat(tmp_str, ' ../src/user_bounds.c');
tmp_str = strcat(tmp_str, ' ../src/user_gradient.c');
tmp_str = strcat(tmp_str, ' ../src/user_hessians.c');
tmp_str = strcat(tmp_str, ' ../src/user_jacobians.c');
tmp_str = strcat(tmp_str, ' ../src/user_residual.c');
tmp_str = strcat(tmp_str, ' ../src/user_mv_mult.c');
tmp_str = strcat(tmp_str, ' ../src/user_lanczos.c');
tmp_str = strcat(tmp_str, ' ../src/user_lanczos_HW.c');
tmp_str = strcat(tmp_str, ' ../src/wrap_lanczos_HW.c');
tmp_str = strcat(tmp_str, ' ../src/user_minres.c');
tmp_str = strcat(tmp_str, ' ../src/user_rec_sol.c');
tmp_str = strcat(tmp_str, ' ../src/user_prescaler.c');
tmp_str = strcat(tmp_str, ' ../src/user_mv_mult_prescaled.c');
tmp_str = strcat(tmp_str, ' ../src/user_mv_mult_prescaled_HW.c');
tmp_str = strcat(tmp_str, ' ../src/wrap_mv_mult_prescaled_HW.c');
eval(tmp_str);

[all_theta_C, all_nu_C, all_lambda_C, debug_output] = mex_nlp_solver(x_init);

max(abs(all_theta - all_theta_C))
