
%% Generate code for solution  recovery file 
cd ../../src 
fileID = fopen('user_prescaler.c','w');
fprintf(fileID,'#include "user_protoip_definer.h"\n');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n');
fprintf(fileID,'#include "user_prototypes_header.h"\n\n');

fprintf(fileID,'extern float minres_data[5];\n\n');

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
fprintf(fileID,strcat('\t',d_type, ' out_blocks[(N+1)*n_states];','\n\n'));

fprintf(fileID,strcat('\t','// block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_block),'\n\n'));

fprintf(fileID,strcat('\t','// term_block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_block),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_block),'\n\n'));

fprintf(fileID,strcat('\t','// block_tril pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_block_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_block_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_block_tril),'\n\n'));

fprintf(fileID,strcat('\t','// term_block_tril pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_block_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_block_tril),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_block_tril),'\n\n'));

fprintf(fileID,strcat('\t','// intitialize prescaler\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++) M[i] = 1;\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &M[n_states + i*(n_node_theta+n_node_eq)];\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++) local_ptr1[j] = 1;\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 += n_states;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_node_theta-n_states; j++) local_ptr1[j] = 0;\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 += (n_node_theta-n_states);\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++) local_ptr1[j] = 1;\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 += n_states;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < (n_node_eq-n_states); j++) local_ptr1[j] = 0;\n'));
fprintf(fileID,strcat('\t','}\n'));
fprintf(fileID,strcat('\t','local_ptr1 = &M[n_states + N*(n_node_theta+n_node_eq)];\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < (n_states); j++) local_ptr1[j] = 1;\n'));
fprintf(fileID,strcat('\t','local_ptr1 += n_states;\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < (n_term_theta + n_term_eq - n_states); j++) local_ptr1[j] = 0;\n\n'));

fprintf(fileID,strcat('\t','// handle blocks\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','i_offset1 = n_states + i*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t\t','i_offset2 = i*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < nnz_block; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','M[i_offset1 + row_block[j]] += fabsf(blocks[i_offset2 + num_block[j]]);\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n'));
fprintf(fileID,strcat('\t','i_offset1 = n_states + N*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t','i_offset2 = N*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < nnz_term_block; i++)\n'));
fprintf(fileID,strcat('\t\t\t','M[i_offset1 + row_term_block[i]] += fabsf(blocks[i_offset2 + num_term_block[i]]);\n\n'));

fprintf(fileID,strcat('\t','// calculate prescaler\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_all_theta+n_all_nu; i++) M[i] = 1/sqrtf(M[i]);\n\n'));

fprintf(fileID,strcat('\t','// apply prescaler to out_blocks[] \n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++) out_blocks[i] = -M[i]*M[i+n_states];\n'));
fprintf(fileID,strcat('\t','for(i = 1; i < N+1; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','i_offset1 = n_states + (n_node_theta + n_node_eq)*i;\n'));
fprintf(fileID,strcat('\t\t','i_offset2 = n_states + n_node_theta +  (n_node_theta + n_node_eq)*(i-1);\n'));
fprintf(fileID,strcat('\t\t','i_offset3 = i*n_states;\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','out_blocks[i_offset3 + j] = -M[i_offset1 + j]*M[i_offset2 + j]; \n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n'));

fprintf(fileID,strcat('\t','// apply prescaler to blocks[] \n'));
fprintf(fileID,strcat('\t','for(i = 0; i < N; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','local_ptr1 = &blocks[i*nnz_block_tril];\n'));
fprintf(fileID,strcat('\t\t','local_ptr2 = &M[n_states + i*(n_node_theta+n_node_eq)];\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < nnz_block_tril; j++)\n'));
fprintf(fileID,strcat('\t\t\t','local_ptr1[num_block_tril[j]] *= local_ptr2[row_block_tril[j]]*local_ptr2[col_block_tril[j]];\n'));
fprintf(fileID,strcat('\t','}\n'));
fprintf(fileID,strcat('\t','local_ptr1 = &blocks[N*nnz_block_tril];\n'));
fprintf(fileID,strcat('\t','local_ptr2 = &M[n_states + N*(n_node_theta+n_node_eq)];\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < nnz_term_block_tril; i++)\n'));
fprintf(fileID,strcat('\t\t','local_ptr1[num_term_block_tril[i]] *= local_ptr2[row_term_block_tril[i]]*local_ptr2[col_term_block_tril[i]];\n\n'));

fprintf(fileID,strcat('\t','// apply prescaler to b[] \n'));
fprintf(fileID,'\tfor(i = 0; i < n_all_theta+n_all_nu; i++)\n');
fprintf(fileID,'\t\tb[i] = b[i]*M[i];\n\n');

fprintf(fileID,strcat('\t','// solve scaled problem \n'));
fprintf(fileID,strcat('\t','// ifdef is to ensure propper compilation in unprescaled mode \n'));
fprintf(fileID,strcat('\t','#ifdef MINRES_prescaled\n'));
fprintf(fileID,strcat('\t\t','#if heterogeneity > 2\n'));
fprintf(fileID,strcat('\t\t\t','#ifdef PROTOIP\n'));
fprintf(fileID,strcat('\t\t\t','send_minres_data_in(minres_data);\n'));
fprintf(fileID,strcat('\t\t\t','send_block_in(blocks);\n'));
fprintf(fileID,strcat('\t\t\t','send_out_block_in(out_blocks);\n'));
fprintf(fileID,strcat('\t\t\t','send_x_in_in(b);\n'));
fprintf(fileID,strcat('\t\t\t','start_foo(1,1,1,1,1);\n'));
fprintf(fileID,strcat('\t\t\t','while(!(finished_foo())){;} // wait for IP to finish\n'));
fprintf(fileID,strcat('\t\t\t','receive_y_out_out(x_current);\n'));
fprintf(fileID,strcat('\t\t\t','#else\n'));
fprintf(fileID,strcat('\t\t\t','wrap_minres_HW(blocks, out_blocks, b, x_current, minres_data); // HW realization\n'));
fprintf(fileID,strcat('\t\t\t','#endif\n'));
fprintf(fileID,strcat('\t\t','#else\n'));
fprintf(fileID,strcat('\t\t','minres(blocks, out_blocks, b, x_current, minres_data); // SW realization\n'));
fprintf(fileID,strcat('\t\t','#endif\n'));
fprintf(fileID,strcat('\t','#endif\n'));

%fprintf(fileID,strcat('\t','minres(blocks, out_blocks, b, x_current);\n\n'));

fprintf(fileID,strcat('\t','// recover solution \n'));
fprintf(fileID,'\tfor(i = 0; i < n_all_theta+n_all_nu; i++)\n');
fprintf(fileID,'\t\tx_current[i] *= M[i];\n\n');

fprintf(fileID,'\t//mv_mult_prescaled(x_current,blocks, out_blocks,b);\n');

fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/prescaler_code

