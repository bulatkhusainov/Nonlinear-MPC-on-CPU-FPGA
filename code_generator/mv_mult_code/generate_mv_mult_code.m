cd ../../src 
%% Generate code for matrix vector calculation (no prescaler)
fileID = fopen('user_mv_mult.c','w');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n\n');

% this function performs matrix vector multiplication
fprintf(fileID,'// this function performs matrix vector multiplication \n');
fprintf(fileID,strcat('void mv_mult('));
fprintf(fileID,strcat(d_type,' y_out[n_all_theta+n_all_nu],'));
fprintf(fileID,strcat(d_type,' block[N*nnz_block_tril + nnz_term_block_tril],'));
fprintf(fileID,strcat(d_type,' x_in[n_all_theta+n_all_nu])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int', ' i,j,k;','\n'));

fprintf(fileID,strcat('\t','// block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_block),'\n\n'));

fprintf(fileID,strcat('\t','// term_block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_block),'\n\n'));

fprintf(fileID,strcat('\t','// reset output\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_all_theta+n_all_nu; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[i] = 0;\n\n'));

fprintf(fileID,strcat('\t','// handle negative identities\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[i] = -x_in[n_states+i];\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[n_states+i] = -x_in[i];\n'));
fprintf(fileID,strcat('\t','for(i = n_states+n_node_theta; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq))\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i+j+n_node_eq] = -x_in[i+j];\n'));
fprintf(fileID,strcat('\t','for(i = n_states+n_node_theta; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq))\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i+j] = -x_in[i+j+n_node_eq];\n\n'));

fprintf(fileID,strcat('\t','int i_offset1, i_offset2;\n'));
fprintf(fileID,strcat('\t','// handle nonzero elements in node blocks\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','i_offset1 = n_states + i*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t\t','i_offset2 = i*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < nnz_block; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i_offset1+row_block[j]] += block[i_offset2 + num_block[j]]*x_in[i_offset1+col_block[j]];\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// handle the terminal block\n'));
fprintf(fileID,strcat('\t','i_offset1 = n_states + N*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t','i_offset2 = N*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < nnz_term_block; j++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','y_out[i_offset1+row_term_block[j]] += block[i_offset2 + num_term_block[j]]*x_in[i_offset1+col_term_block[j]];\n'));
fprintf(fileID,strcat('\t','}\n'));

fprintf(fileID,'}\n');
fclose(fileID);


%% Generate code for matrix vector calculation (with prescaler)
fileID = fopen('user_mv_mult_prescaled.c','w');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n\n');

% this function performs matrix vector multiplication
fprintf(fileID,'// this function performs matrix vector multiplication \n');
fprintf(fileID,strcat('void mv_mult_prescaled('));
fprintf(fileID,strcat(d_type,' y_out[n_all_theta+n_all_nu],'));
fprintf(fileID,strcat(d_type,' block[N*nnz_block_tril + nnz_term_block_tril],'));
fprintf(fileID,strcat(d_type,' out_block[(N+1)*n_states],'));
fprintf(fileID,strcat(d_type,' x_in[n_all_theta+n_all_nu])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int', ' i,j,k;','\n'));

fprintf(fileID,strcat('\t','// block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_block),'\n\n'));

fprintf(fileID,strcat('\t','// term_block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_block),'\n\n'));

fprintf(fileID,strcat('\t','// reset output\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_all_theta+n_all_nu; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[i] = 0;\n\n'));

fprintf(fileID,strcat('\t','// handle negative identities\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[i] = x_in[n_states+i]*M[i];\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[n_states+i] = x_in[i]*M[i];\n'));
fprintf(fileID,strcat('\t','for(i = n_states+n_node_theta, k = n_states; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq), k+=n_states)\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i+j+n_node_eq] = x_in[i+j]*M[k+j];\n'));
fprintf(fileID,strcat('\t','for(i = n_states+n_node_theta; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq))\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i+j] = x_in[i+j+n_node_eq]*M[k+j];\n\n'));

fprintf(fileID,strcat('\t','int i_offset1, i_offset2;\n'));
fprintf(fileID,strcat('\t','// handle nonzero elements in node blocks\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','i_offset1 = n_states + i*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t\t','i_offset2 = i*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < nnz_block; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i_offset1+row_block[j]] += block[i_offset2 + num_block[j]]*x_in[i_offset1+col_block[j]];\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// handle the terminal block\n'));
fprintf(fileID,strcat('\t','i_offset1 = n_states + N*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t','i_offset2 = N*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < nnz_term_block; j++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','y_out[i_offset1+row_term_block[j]] += block[i_offset2 + num_term_block[j]]*x_in[i_offset1+col_term_block[j]];\n'));
fprintf(fileID,strcat('\t','}\n'));

fprintf(fileID,'}\n');
fclose(fileID);
cd ../code_generator/mv_mult_code

