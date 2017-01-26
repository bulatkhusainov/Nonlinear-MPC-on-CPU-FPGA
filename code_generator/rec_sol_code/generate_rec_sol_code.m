
%% Generate code for solution  recovery file 
cd ../../src 
fileID = fopen('user_rec_sol.c','w');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n\n');

fprintf(fileID,'// this function extracts d_all_theta[], d_all_lambda[],\n');
fprintf(fileID,'// recovers d_lambda[] and extract data d_all_theta_search[] for line search\n');
fprintf(fileID,strcat('void rec_sol('));
fprintf(fileID,strcat(d_type,' d_all_theta[n_all_theta],'));
fprintf(fileID,strcat(d_type,' d_all_nu[n_all_nu],'));
fprintf(fileID,strcat(d_type,' d_all_lambda[n_all_lambda],'));
fprintf(fileID,strcat(d_type,' d_all_theta_search[n_all_lambda],'));
fprintf(fileID,strcat(d_type,' d_x[n_linear],'));
fprintf(fileID,strcat(d_type,' all_lambda[n_all_lambda],'));
fprintf(fileID,strcat(d_type,' all_mu_over_g[n_all_lambda],'));
fprintf(fileID,strcat(d_type,' all_lambda_over_g[n_all_lambda])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int', ' i,j,k;','\n'));
fprintf(fileID,strcat('\t','float *local_ptr1, *local_ptr2, *local_ptr3, *local_ptr4, *local_ptr5; // local pointers for efficient handling of nested loops','\n\n'));

fprintf(fileID,strcat('\t',variables_declaration_int('1d',upper_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',lower_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',upper_bounds),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',lower_bounds),'\n\n'));


fprintf(fileID,strcat('\t','// extract d_all_theta[] from d_x[]','\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)','\n'));
fprintf(fileID,strcat('\t','{','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &d_all_theta[i*n_node_theta];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr2 = &d_x[n_states + i*(n_node_theta+n_node_eq)];','\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_node_theta; j++)','\n'));
fprintf(fileID,strcat('\t\t\t','local_ptr1[j] = local_ptr2[j];','\n'));
fprintf(fileID,strcat('\t','}','\n'));
fprintf(fileID,strcat('\t','local_ptr1 = &d_all_theta[N*n_node_theta];','\n'));
fprintf(fileID,strcat('\t','local_ptr2 = &d_x[n_states + N*(n_node_theta+n_node_eq)];','\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < n_term_theta; j++)','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1[j] = local_ptr2[j];','\n\n'));

fprintf(fileID,strcat('\t','// extract d_all_nu[] from d_x[]','\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)','\n'));
fprintf(fileID,strcat('\t\t','d_all_nu[i] = d_x[i];','\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)','\n'));
fprintf(fileID,strcat('\t','{','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &d_all_nu[n_states + i*n_node_eq];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr2 = &d_x[n_states + n_node_theta + i*(n_node_theta+n_node_eq)];','\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_node_eq; j++)','\n'));
fprintf(fileID,strcat('\t\t\t','local_ptr1[j] = local_ptr2[j];','\n'));
fprintf(fileID,strcat('\t','}','\n'));
fprintf(fileID,strcat('\t','local_ptr1 = &d_all_nu[n_states + N*n_node_eq];','\n'));
fprintf(fileID,strcat('\t','local_ptr2 = &d_x[n_states + N*(n_node_theta+n_node_eq) + n_term_theta];','\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < n_term_eq; j++)','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1[j] = local_ptr2[j];','\n\n'));

fprintf(fileID,strcat('\t','// recover  d_lambda[] and extract data d_all_theta_search[] for line search','\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)','\n'));
fprintf(fileID,strcat('\t','{','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &d_all_theta_search[i*n_bounds];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr2 = &d_all_theta[i*n_node_theta];','\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_upper_bounds; j++)','\n'));
fprintf(fileID,strcat('\t\t\t','local_ptr1[j] = local_ptr2[upper_bounds_indeces[j]];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &d_all_theta_search[i*n_bounds+n_upper_bounds];','\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_lower_bounds; j++)','\n'));
fprintf(fileID,strcat('\t\t\t','local_ptr1[j] = -local_ptr2[lower_bounds_indeces[j]];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &d_all_lambda[i*n_bounds];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr2 = &all_lambda[i*n_bounds];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr3 = &all_mu_over_g[i*n_bounds];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr4 = &all_lambda_over_g[i*n_bounds];','\n'));
fprintf(fileID,strcat('\t\t','local_ptr5 = &d_all_theta_search[i*n_bounds];','\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_bounds; j++)','\n'));
fprintf(fileID,strcat('\t\t\t','local_ptr1[j] = -local_ptr5[j]*local_ptr4[j] - local_ptr3[j] - local_ptr2[j];','\n'));
fprintf(fileID,strcat('\t','}','\n'));

fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/rec_sol_code

