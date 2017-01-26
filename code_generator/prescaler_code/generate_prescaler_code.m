
%% Generate code for solution  recovery file 
cd ../../src 
fileID = fopen('user_prescaler.c','w');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n\n');

fprintf(fileID,'// this function prescales orginal linear system and calls MINRES solver,\n');
fprintf(fileID,strcat('void prescaler('));
fprintf(fileID,strcat(d_type,' blocks[N*nnz_block_tril + nnz_term_block_tril],'));
fprintf(fileID,strcat(d_type,' b[n_all_theta+n_all_nu],'));
fprintf(fileID,strcat(d_type,' x_current[n_all_theta+n_all_nu])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int', ' i,j,k;','\n'));
fprintf(fileID,strcat('\t','int', ' i_offset1, i_offset2, i_offset3;','\n'));
fprintf(fileID,strcat('\t','float *local_ptr1, *local_ptr2, *local_ptr3, *local_ptr4, *local_ptr5; // local pointers for efficient handling of nested loops','\n'));
fprintf(fileID,strcat('\t',d_type, ' M[n_all_theta+n_all_nu];','\n'));
fprintf(fileID,strcat('\t',d_type, ' out_block[(N+1)*n_states];','\n\n'));

fprintf(fileID,strcat('\t','// block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_block),'\n\n'));

fprintf(fileID,strcat('\t','// term_block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_block),'\n\n'));

% nnz_block_tril = size(col_block_tril,1);
% coo_block_tril = [row_block_tril, col_block_tril, (1:nnz_block_tril)'];
% coo_block_tril = coo_block_tril - 1;  % use zero indexing for C

% nnz_term_block_tril = size(col_term_block_tril,1);
% coo_term_block_tril = [row_term_block_tril, col_term_block_tril, (1:nnz_term_block_tril)'];
% coo_term_block_tril = coo_term_block_tril - 1;  % use zero indexing for C

fprintf(fileID,strcat('\t','// intitialize prescaler\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++) M[i] = 1;\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &M[n_states + i*(n_node_theta+n_node_eq)];\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++) M[j] = 1;\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 += n_states;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_node_theta-n_states; j++) M[j] = 0;\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 += (n_node_theta-n_states);\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++) M[j] = 1;\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 += n_states;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < (n_node_eq-n_states); j++) M[j] = 0;\n'));
fprintf(fileID,strcat('\t','}\n'));
fprintf(fileID,strcat('\t','local_ptr1 = &M[n_states + N*(n_node_theta+n_node_eq)];\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < (n_states); j++) M[j] = 1;\n'));
fprintf(fileID,strcat('\t','local_ptr1 += n_states;\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < (n_term_theta + n_term_eq - n_states); j++) M[j] = 0;\n\n'));

fprintf(fileID,strcat('\t','// handle blocks\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','i_offset1 = n_states + i*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t\t','i_offset2 = i*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < N; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','M[i_offset1 + row_block[j]] += fabs(blocks[i_offset2 + num_block[j]])\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// calculate prescaler\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++) M[i] = 1/fsqrt(M[i]);\n\n'));

fprintf(fileID,strcat('\t','// apply prescaler to out_blocks[] \n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++) out_blocks[i] = M[i]*M[i+1];\n'));
fprintf(fileID,strcat('\t','for(i = 1; i < N+1; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','i_offset1 = n_states + n_node_theta + n_node_eq;\n'));
fprintf(fileID,strcat('\t\t','i_offset2 = n_states + n_node_theta;\n'));
fprintf(fileID,strcat('\t\t','i_offset3 = i*n_states;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','out_blocks[i_offset3 + j] = M[i_offset1 + j]*M[i_offset2 + j] \n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n'));

fprintf(fileID,strcat('\t','// apply prescaler to out_blocks[] \n'));


fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/prescaler_code

