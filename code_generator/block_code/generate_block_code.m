
%sparsity pattern after adding GWG
tmp_vec = zeros(n_node_theta,1);
tmp_vec(upper_bounds_indeces+1) = 1;
tmp_vec(lower_bounds_indeces+1) = 1;
gwg_pattern = diag(tmp_vec);
node_hessian_pattern_augmented = node_hessian_pattern + gwg_pattern;

% block lower triangular pattern
block_pattern = [node_hessian_pattern_augmented f_jac_pattern'; f_jac_pattern zeros(n_node_eq, n_node_eq)];
[row_block_tril, col_block_tril] =  find(sparse(tril(block_pattern)));
nnz_block_tril = size(col_block_tril,1);
coo_block_tril = [row_block_tril, col_block_tril, (1:nnz_block_tril)'];

%node hessian lower triangular pattern
[row_node_hessian_tril, col_node_hessian_tril] =  find(sparse(tril(node_hessian_pattern)));
coo_node_hessian_tril = [row_node_hessian_tril, col_node_hessian_tril];
nnz_node_hessian_tril = size(col_node_hessian_tril,1);
tmp_vector = ismember(coo_block_tril(:,1:2), coo_node_hessian_tril,'rows');
coo_node_hessian_tril = coo_block_tril(tmp_vector,:);
coo_node_hessian_tril = coo_node_hessian_tril -1; % for zero indexing in C
row_node_hessian_tril = coo_node_hessian_tril(:,1);
col_node_hessian_tril = coo_node_hessian_tril(:,2);
num_node_hessian_tril = coo_node_hessian_tril(:,3);

% node f_jac pattern
[row_f_jac, col_f_jac] =  find(sparse((f_jac_pattern)));
coo_f_jac = [row_f_jac, col_f_jac];
nnz_f_jac = size(col_f_jac,1);
tmp_vector = ismember(coo_block_tril(:,1:2), coo_f_jac+[n_node_theta*ones(nnz_f_jac,1) zeros(nnz_f_jac,1)],'rows');
coo_node_f_jac = coo_block_tril(tmp_vector,:); % consider shifting row index by n_node_theta
coo_node_f_jac(:,1) = coo_node_f_jac(:,1) - n_node_theta;
coo_node_f_jac = coo_node_f_jac - 1; % zero indexing in C
row_node_f_jac = coo_node_f_jac(:,1);
col_node_f_jac = coo_node_f_jac(:,2);
num_node_f_jac = coo_node_f_jac(:,3);

% gwg pattern
[row_gwg, col_gwg] =  find(sparse((gwg_pattern)));
coo_gwg = [row_gwg, col_gwg];
nnz_gwg = size(col_gwg,1);
tmp_vector = ismember(coo_block_tril(:,1:2), coo_gwg,'rows');
coo_gwg = coo_block_tril(tmp_vector,:);
coo_gwg = coo_gwg -1; % for zero indexing in C
col_gwg = coo_gwg(:,2);
num_gwg = coo_gwg(:,3);

% 


%% Generate code for block evaluation file
cd ../../src 
fileID = fopen('block.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,'// this function evaluates blocks \n');
fprintf(fileID,strcat('void node_blocks_eval('));
fprintf(fileID,strcat(d_type,' all_blocks[nnz_block_tril*N],'));
fprintf(fileID,strcat(d_type,' all_theta[n_all_theta],'));
fprintf(fileID,strcat(d_type,' all_lambda_over_g[n_all_lambda])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int',' i, j, k;','\n'));
fprintf(fileID,strcat('\t',d_type,' node_hessian[n_node_theta][n_node_theta];','\n'));
fprintf(fileID,strcat('\t',d_type,' f[n_node_eq][n_node_theta];','\n\n'));

fprintf(fileID,'\t// node Hessian reading info \n');
fprintf(fileID,strcat('\t',variables_declaration('1d',row_node_hessian_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',col_node_hessian_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',num_node_hessian_tril),'\n\n'));

fprintf(fileID,'\t// node Jacobian reading info \n');
fprintf(fileID,strcat('\t',variables_declaration('1d',row_node_f_jac),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',col_node_f_jac),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',num_node_f_jac),'\n\n'));

fprintf(fileID,'\t// node gwg reading info \n');
fprintf(fileID,strcat('\t',variables_declaration('1d',col_gwg),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',num_gwg),'\n\n'));

fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)','\n'));
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tblock = &all_blocks[i*nnz_block_tril];\n');
fprintf(fileID,'\t\tnode_lambda_over_g = &all_lambda_over_g[i*n_bounds];\n\n');
fprintf(fileID,strcat('\t\t','node_hessian_eval(node_hessian, &all_theta[i*n_node_theta]);','\n'));
fprintf(fileID,strcat('\t\t','f_jac_eval(f_jac, &all_theta[i*n_node_theta]);','\n\n'));

fprintf(fileID,'\t\t// read hessian\n');
fprintf(fileID,'\t\tfor(i = 0; i < nnz_node_hessian_tril; i++)\n');
fprintf(fileID,'\t\t\tblock[num_node_hessian_tril[i]] = node_hessian_eval[row_node_hessian_tril[i]][col_node_hessian_tril[i]];\n\n');

fprintf(fileID,'\t\t// read jacobian\n');
fprintf(fileID,'\t\tfor(i = 0; i < nnz_f_jac; i++)\n');
fprintf(fileID,'\t\t\tblock[num_node_f_jac[i]] = f_jac[row_node_f_jac[i]][col_node_f_jac[i]];\n\n');

fprintf(fileID,'\t\t// calculate and read gwg\n');
fprintf(fileID,'\t\tfor(i = 0; i < n_states+m_inputs+n_node_slack; i++) // reset node_gwg[]\n');
fprintf(fileID,'\t\t\tnode_gwg[i] = 0; \n');
fprintf(fileID,'\t\tfor(i = 0; i < n_upper_bounds; i++) //handle upper bounds\n');
fprintf(fileID,'\t\t\tnode_gwg[upper_bounds_indeces[i]] += node_lambda_over_g[i];\n');
fprintf(fileID,'\t\tfor(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++) //handle lower bounds\n');
fprintf(fileID,'\t\t\tnode_gwg[lower_bounds_indeces[j]] += node_lambda_over_g[i];\n');
fprintf(fileID,'\t\tfor(i = 0; i < nnz_gwg; i++)\n');
fprintf(fileID,'\t\t\tblock[num_gwg[i]] = node_gwg[col_gwg[i]]; // read gwg\n');





fprintf(fileID,'\t}\n');


fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/block_code

% if test_enable == 1 && n_bounds > 0
%     % test "node_bounds_eval" C function
%     random_input = 10*rand(1,n_node_theta);
%     cd unit_test_files
%         mex node_bounds_eval.c
%         mex_data = node_bounds_eval(random_input);
%        
%     cd .. 
%     golden_data_upper = random_input(upper_bounds_indeces+1) - upper_bounds;
%     golden_data_lower = -random_input(lower_bounds_indeces+1) + lower_bounds;
%     golden_data = [golden_data_upper golden_data_lower]';
%    
%     mismatch = abs(golden_data - mex_data);
%     if max(mismatch(:)) > test_tol
%         error('"node_bounds_eval" C function failed the test');
%     else
%         disp('"node_bounds_eval" C function passed the test')
%     end
%     
%     % test "node_gwg_eval" C function
%     random_bounds = 10*rand(1,n_bounds);
%     random_lambda = 10*rand(1,n_bounds);
%     cd unit_test_files
%         mex node_gwg_eval.c
%         mex_data = node_gwg_eval(random_bounds,random_lambda);  
%     cd .. 
%     tmp_array = -random_lambda./random_bounds;
%     golden_data_upper = zeros(n_states+m_inputs+n_node_slack,1);
%     golden_data_upper(upper_bounds_indeces+1) = tmp_array(1:n_upper_bounds);
%     golden_data_lower = zeros(n_states+m_inputs+n_node_slack,1);
%     golden_data_lower(lower_bounds_indeces+1) = tmp_array(n_upper_bounds+1:n_bounds);
%     golden_data = golden_data_upper + golden_data_lower;
%     mismatch = abs(golden_data - mex_data);
%     if max(mismatch(:)) > test_tol
%         error('"node_gwg_eval" C function failed the test');
%     else
%         disp('"node_gwg_eval" C function passed the test')
%     end
%     
% end