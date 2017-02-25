%% handle node blocks

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
coo_block_tril = coo_block_tril - 1;  % use zero indexing for C
row_block_tril = coo_block_tril(:,1);
col_block_tril = coo_block_tril(:,2);
num_block_tril = coo_block_tril(:,3);



%node hessian lower triangular pattern
[row_node_hessian_tril, col_node_hessian_tril] =  find(sparse(tril(node_hessian_pattern)));
coo_node_hessian_tril = [row_node_hessian_tril, col_node_hessian_tril] - 1; % use zero indexing for C
nnz_node_hessian_tril = size(col_node_hessian_tril,1);
tmp_vector = ismember(coo_block_tril(:,1:2), coo_node_hessian_tril,'rows');
coo_node_hessian_tril = coo_block_tril(tmp_vector,:);
row_node_hessian_tril = coo_node_hessian_tril(:,1);
col_node_hessian_tril = coo_node_hessian_tril(:,2);
num_node_hessian_tril = coo_node_hessian_tril(:,3);

% node f_jac pattern
[row_f_jac, col_f_jac] =  find(sparse((f_jac_pattern)));
coo_f_jac = [row_f_jac, col_f_jac] - 1; % use zero indexing for C
nnz_f_jac = size(col_f_jac,1);
tmp_vector = ismember(coo_block_tril(:,1:2), coo_f_jac+[n_node_theta*ones(nnz_f_jac,1) zeros(nnz_f_jac,1)],'rows');
coo_node_f_jac = coo_block_tril(tmp_vector,:);
coo_node_f_jac(:,1) = coo_node_f_jac(:,1) - n_node_theta;
row_node_f_jac = coo_node_f_jac(:,1);
col_node_f_jac = coo_node_f_jac(:,2);
num_node_f_jac = coo_node_f_jac(:,3);

% gwg pattern
[row_gwg, col_gwg] =  find(sparse((gwg_pattern)));
coo_gwg = [row_gwg, col_gwg] - 1;  % for zero indexing in C
nnz_gwg = size(col_gwg,1);
tmp_vector = ismember(coo_block_tril(:,1:2), coo_gwg,'rows');
coo_gwg = coo_block_tril(tmp_vector,:);
col_gwg = coo_gwg(:,2);
num_gwg = coo_gwg(:,3);

% block pattern (recover from block_tril)
tmp_vector = ~ismember(coo_block_tril(:,1),coo_block_tril(:,2));
tmp_vector = coo_block_tril(tmp_vector,:);
coo_block = [coo_block_tril; tmp_vector(:,2) tmp_vector(:,1) tmp_vector(:,3)];
row_block = coo_block(:,1);
col_block = coo_block(:,2);
num_block = coo_block(:,3);
nnz_block = size(col_block,1);

%% handle terminal block
% for the moment there are no inequalities in the terminal node

% terminal block lower triangular pattern
term_block_pattern = [term_hessian_pattern term_f_jac_pattern'; term_f_jac_pattern zeros(n_term_eq, n_term_eq)];
[row_term_block_tril, col_term_block_tril] =  find(sparse(tril(term_block_pattern)));
nnz_term_block_tril = size(col_term_block_tril,1);
coo_term_block_tril = [row_term_block_tril, col_term_block_tril, (1:nnz_term_block_tril)'];
coo_term_block_tril = coo_term_block_tril - 1;  % use zero indexing for C
row_term_block_tril = coo_term_block_tril(:,1);
col_term_block_tril = coo_term_block_tril(:,2);
num_term_block_tril = coo_term_block_tril(:,3);

%term hessian lower triangular pattern
[row_term_hessian_tril, col_term_hessian_tril] =  find(sparse(tril(term_hessian_pattern)));
coo_term_hessian_tril = [row_term_hessian_tril, col_term_hessian_tril] - 1; % use zero indexing for C
nnz_term_hessian_tril = size(col_term_hessian_tril,1);
tmp_vector = ismember(coo_term_block_tril(:,1:2), coo_term_hessian_tril,'rows');
coo_term_hessian_tril = coo_term_block_tril(tmp_vector,:);
row_term_hessian_tril = coo_term_hessian_tril(:,1);
col_term_hessian_tril = coo_term_hessian_tril(:,2);
num_term_hessian_tril = coo_term_hessian_tril(:,3);

% term f_jac pattern
[row_term_f_jac, col_term_f_jac] =  find(sparse((term_f_jac_pattern)));
row_term_f_jac = row_term_f_jac(:); col_term_f_jac = col_term_f_jac(:);
coo_term_f_jac = [row_term_f_jac, col_term_f_jac] - 1; % use zero indexing for C
nnz_term_f_jac = size(col_term_f_jac,1);
tmp_vector = ismember(coo_term_block_tril(:,1:2), coo_term_f_jac+[n_term_theta*ones(nnz_term_f_jac,1) zeros(nnz_term_f_jac,1)],'rows');
coo_term_f_jac = coo_term_block_tril(tmp_vector,:);
coo_term_f_jac(:,1) = coo_term_f_jac(:,1) - n_term_theta;
row_term_f_jac = coo_term_f_jac(:,1);
col_term_f_jac = coo_term_f_jac(:,2);
num_term_f_jac = coo_term_f_jac(:,3);

% terminal block pattern (recover from term_block_tril)
tmp_vector = ~ismember(coo_term_block_tril(:,1),coo_term_block_tril(:,2));
tmp_vector = coo_term_block_tril(tmp_vector,:);
coo_term_block = [coo_term_block_tril; tmp_vector(:,2) tmp_vector(:,1) tmp_vector(:,3)];
row_term_block = coo_term_block(:,1);
col_term_block = coo_term_block(:,2);
num_term_block = coo_term_block(:,3);
nnz_term_block = size(col_term_block,1);

%% Generate nnz header
cd ..
generate_nnz_header;
cd block_code

%% Generate code for block evaluation file
cd ../../src 
fileID = fopen('user_block.c','w');
fprintf(fileID,'#include "user_protoip_definer.h"\n');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n\n');

fprintf(fileID,'// functions prototypes \n');
fprintf(fileID,'void node_hessian_eval(float node_hessian[n_node_theta][n_node_theta],float node_theta[n_node_theta]); \n');
fprintf(fileID,'void f_jac_eval(float f_jac[n_node_eq][n_node_theta],float node_theta[n_node_theta]); \n\n');
fprintf(fileID,'void term_hessian_eval(float term_hessian[n_term_theta][n_term_theta],float term_theta[n_term_theta]);; \n');
fprintf(fileID,'void term_f_jac_eval(float term_f_jac[n_term_eq][n_term_theta],float term_theta[n_term_theta]); \n\n');

fprintf(fileID,'// this function evaluates node blocks \n');
fprintf(fileID,strcat('void node_block_eval('));
fprintf(fileID,strcat(d_type,' block[nnz_block_tril],'));
fprintf(fileID,strcat(d_type,' node_jac_2d[n_node_eq][n_node_theta],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta],'));
fprintf(fileID,strcat(d_type,' node_lambda_over_g[n_bounds])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int',' i, j, k;','\n'));
fprintf(fileID,strcat('\t',d_type,' node_hessian[n_node_theta][n_node_theta];','\n\n'));

fprintf(fileID,'\t// node Hessian reading info \n');
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_node_hessian_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_node_hessian_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_node_hessian_tril),'\n\n'));

fprintf(fileID,'\t// node Jacobian reading info \n');
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_node_f_jac),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_node_f_jac),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_node_f_jac),'\n\n'));

fprintf(fileID,'\t// node gwg reading info \n');
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_gwg),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_gwg),'\n\n'));

fprintf(fileID,strcat('\t',variables_declaration_int('1d',upper_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',lower_bounds_indeces),'\n\n'));

fprintf(fileID,strcat('\t','node_hessian_eval(node_hessian, node_theta);','\n'));
fprintf(fileID,strcat('\t','f_jac_eval(node_jac_2d, node_theta);','\n\n'));

fprintf(fileID,'\t// read hessian\n');
fprintf(fileID,'\tfor(i = 0; i < nnz_node_hessian_tril; i++)\n');
fprintf(fileID,'\t\tblock[num_node_hessian_tril[i]] = node_hessian[row_node_hessian_tril[i]][col_node_hessian_tril[i]];\n\n');

fprintf(fileID,'\t// read jacobian\n');
fprintf(fileID,'\tfor(i = 0; i < nnz_f_jac; i++)\n');
fprintf(fileID,'\t\tblock[num_node_f_jac[i]] = node_jac_2d[row_node_f_jac[i]][col_node_f_jac[i]];\n\n');

fprintf(fileID,'\t// calculate and read gwg\n');
fprintf(fileID,strcat('\t',d_type,' node_gwg[n_node_theta];','\n'));
fprintf(fileID,'\tfor(i = 0; i < n_states+m_inputs+n_node_slack; i++) // reset node_gwg[]\n');
fprintf(fileID,'\t\tnode_gwg[i] = 0; \n');
fprintf(fileID,'\tfor(i = 0; i < n_upper_bounds; i++) //handle upper bounds\n');
fprintf(fileID,'\t\tnode_gwg[upper_bounds_indeces[i]] -= node_lambda_over_g[i];\n');
fprintf(fileID,'\tfor(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++) //handle lower bounds\n');
fprintf(fileID,'\t\tnode_gwg[lower_bounds_indeces[j]] -= node_lambda_over_g[i];\n');
fprintf(fileID,'\tfor(i = 0; i < nnz_gwg; i++)\n');
fprintf(fileID,'\t\tblock[num_gwg[i]] += node_gwg[col_gwg[i]]; // read gwg\n');

fprintf(fileID,'}\n\n');


fprintf(fileID,'// this function evaluates the terminal block \n');
fprintf(fileID,strcat('void term_block_eval('));
fprintf(fileID,strcat(d_type,' term_block[nnz_term_block_tril],'));
fprintf(fileID,strcat(d_type,' term_jac_2d[n_term_eq][n_term_theta],'));
fprintf(fileID,strcat(d_type,' term_theta[n_term_theta])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int',' i, j, k;','\n'));
fprintf(fileID,strcat('\t',d_type,' term_hessian[n_term_theta][n_term_theta];','\n\n'));

fprintf(fileID,'\t// term Hessian reading info \n');
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_hessian_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_hessian_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_hessian_tril),'\n\n'));

fprintf(fileID,'\t// term Jacobian reading info \n');
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_f_jac),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_f_jac),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_f_jac),'\n\n'));

fprintf(fileID,strcat('\t','term_hessian_eval(term_hessian, term_theta);','\n'));
fprintf(fileID,strcat('\t','term_f_jac_eval(term_jac_2d, term_theta);','\n\n'));

fprintf(fileID,'\t// read term hessian\n');
fprintf(fileID,'\tfor(i = 0; i < nnz_term_hessian_tril; i++)\n');
fprintf(fileID,'\t\tterm_block[num_term_hessian_tril[i]] = term_hessian[row_term_hessian_tril[i]][col_term_hessian_tril[i]];\n\n');

fprintf(fileID,'\t// read term jacobian\n');
fprintf(fileID,'\tfor(i = 0; i < nnz_term_f_jac; i++)\n');
fprintf(fileID,'\t\tterm_block[num_term_f_jac[i]] = term_jac_2d[row_term_f_jac[i]][col_term_f_jac[i]];\n\n');

fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/block_code


if test_enable == 1
    % test "node_block_eval" C function
    random_input1 = 10*rand(1,n_node_theta);
    random_input2 = 10*rand(1,n_bounds);
    cd unit_test_files
        mex node_block_eval.c ../../../src/user_hessians.c ../../../src/user_jacobians.c
        [mex_data1, mex_data2] = node_block_eval(random_input1,random_input2);
        test_block = zeros(n_node_theta+n_node_eq);
        for i = 1:size(coo_block_tril,1)
            test_block(coo_block_tril(i,1)+1,coo_block_tril(i,2)+1) = mex_data1(coo_block_tril(i,3)+1);
        end
    cd ..
    % construct block manually to build golden output
    node_Hessian = node_hessian_eval(random_input1);
    node_Hessian = vec2mat(node_Hessian,n_node_theta);
    if (n_bounds > 0)        
        tmp_upper = zeros(n_states+m_inputs+n_node_slack,1);
        tmp_upper(upper_bounds_indeces+1) = -random_input2(1:n_upper_bounds);
        tmp_lower = zeros(n_states+m_inputs+n_node_slack,1);
        tmp_lower(lower_bounds_indeces+1) = -random_input2(n_upper_bounds+1:n_bounds);
        tmp_vector = tmp_upper + tmp_lower;
        hessian_index = 1:n_states+m_inputs+n_node_slack;
        node_Hessian(hessian_index,hessian_index) = node_Hessian(hessian_index,hessian_index) + diag(tmp_vector);
    end        
    node_jacobian = f_jac_eval(random_input1);
    node_jacobian = vec2mat(node_jacobian, n_node_theta);
    block = [node_Hessian node_jacobian'; node_jacobian zeros(size(node_jacobian,1))];
    mismatch1 = test_block - block;
    
    tmp_array = node_jacobian';
    mismatch2 = mex_data2 - tmp_array(:);
    
    if max(abs(mismatch1(:))) > test_tol && max(abs(mismatch2(:))) > test_tol
        error('"node_block_eval" C function failed the test');
    else
        disp('"node_block_eval" C function passed the test')
    end
    
    % test "term_block_eval" C function
    random_input1 = 10*rand(1,n_term_theta);
    cd unit_test_files
        mex term_block_eval.c ../../../src/user_hessians.c ../../../src/user_jacobians.c
        [mex_data1, mex_data2] = term_block_eval(random_input1);
        test_block = zeros(n_term_theta+n_term_eq);
        for i = 1:size(coo_term_block_tril,1)
            test_block(coo_term_block_tril(i,1)+1,coo_term_block_tril(i,2)+1) = mex_data1(coo_term_block_tril(i,3)+1);
        end
    cd ..
    % construct block manually to build golden output
    term_Hessian = term_hessian_eval(random_input1);
    term_Hessian = vec2mat(term_Hessian,n_term_theta);
    term_jacobian = term_f_jac_eval(random_input1);
    term_jacobian = vec2mat(term_jacobian, n_term_theta);
    block = [term_Hessian term_jacobian'; term_jacobian zeros(size(term_jacobian,1))];
    mismatch1 = test_block - block;
    
    tmp_array = term_jacobian';
    mismatch2 = mex_data2 - tmp_array(:);
    
    if max(abs(mismatch1(:))) > test_tol && max(abs(mismatch2(:))) > test_tol
        error('"term_block_eval" C function failed the test');
    else
        disp('"term_block_eval" C function passed the test')
    end
end