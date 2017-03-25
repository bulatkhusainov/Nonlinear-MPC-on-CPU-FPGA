%schedule for pipelining
indeces.row_block = row_block; indeces.col_block = col_block; indeces.num_block = num_block;
[ indeces_sched, distance_achieved_node ] = schedule_pipeline( indeces, n_node_theta + n_node_eq);
row_block_sched = indeces_sched.row_block_sched;
col_block_sched = indeces_sched.col_block_sched;
num_block_sched = indeces_sched.num_block_sched;

indeces.row_block = row_term_block; indeces.col_block = col_term_block; indeces.num_block = num_term_block;
[ indeces_sched, distance_achieved_node_term ] = schedule_pipeline( indeces, n_term_theta + n_term_eq);
row_term_block_sched = indeces_sched.row_block_sched; 
col_term_block_sched = indeces_sched.col_block_sched; 
num_term_block_sched = indeces_sched.num_block_sched; 

% row_block_sched = row_block;
% col_block_sched = col_block;
% num_block_sched = num_block;
% distance_achieved_node = 1;

% row_term_block_sched = row_term_block; 
% col_term_block_sched = col_term_block; 
% num_term_block_sched = num_term_block; 
% distance_achieved_node_term = 1;

cd ../../src 
%% Generate code for matrix vector calculation (no prescaler)
fileID = fopen('user_mv_mult.c','w');
fprintf(fileID,'#include "user_protoip_definer.h"\n');
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


%% Generate code for matrix vector calculation (with prescaler)
fileID = fopen('user_mv_mult_prescaled.c','w');
fprintf(fileID,'#include "user_protoip_definer.h"\n');
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
fprintf(fileID,strcat('\t\t','y_out[i] = x_in[n_states+i]*out_block[i];\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t\t','y_out[n_states+i] = x_in[i]*out_block[i];\n'));
fprintf(fileID,strcat('\t','for(i = n_states+n_node_theta, k = n_states; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq), k+=n_states)\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i+j+n_node_eq] = x_in[i+j]*out_block[k+j];\n'));
fprintf(fileID,strcat('\t','for(i = n_states+n_node_theta, k = n_states; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq), k+=n_states)\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','y_out[i+j] = x_in[i+j+n_node_eq]*out_block[k+j];\n\n'));

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



%% Generate code for HW matrix vector calculation (with prescaler)
fileID = fopen('user_mv_mult_prescaled_HW.c','w');
fprintf(fileID,'#include "user_protoip_definer.h"\n');
fprintf(fileID,'#include "user_main_header.h"\n');
fprintf(fileID,'#include "user_nnz_header.h"\n');
fprintf(fileID,'#include "user_structure_header.h"\n\n');

% this function performs matrix vector multiplication
fprintf(fileID,'// this function performs matrix vector multiplication \n');
fprintf(fileID,strcat('void mv_mult_prescaled_HW('));
fprintf(fileID,strcat('part_vector',' *y_out,'));
fprintf(fileID,strcat('part_matrix',' *block,'));
fprintf(fileID,strcat('d_type_lanczos',' out_block[(N+1)*n_states],'));
fprintf(fileID,strcat('part_vector',' *x_in)\n'));
fprintf(fileID,'{\n');
fprintf(fileID,'#pragma HLS INLINE\n');
fprintf(fileID,strcat('\t','int', ' i,j,k,l;','\n'));

fprintf(fileID,strcat('\t','// block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_block_sched),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_block_sched),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_block_sched),'\n\n'));

fprintf(fileID,strcat('\t','// term_block pattern in COO format\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',row_term_block_sched),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',col_term_block_sched),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',num_term_block_sched),'\n\n'));

fprintf(fileID,strcat('\t','// reset output\n'));
fprintf(fileID,strcat('\t','merge_reset:{\n'));
fprintf(fileID,strcat('\t\t','#pragma HLS LOOP_MERGE\n'));
fprintf(fileID,strcat('\t\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec0[i] = 0;\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','for(i = 0; i < PAR; i++)\n'));
fprintf(fileID,strcat('\t\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS UNROLL skip_exit_check\n'));
fprintf(fileID,strcat('\t\t\t\t','y_out->vec[i][j] = 0;\n'));
fprintf(fileID,strcat('\t\t\t','}\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t\t','#ifdef rem_partition\n'));
fprintf(fileID,strcat('\t\t','for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++) \n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec_rem[i] = 0;\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t\t','#endif\n'));
fprintf(fileID,strcat('\t\t','for(i = 0; i < n_term_theta+n_term_eq; i++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec_term[i] = 0;\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n'));

fprintf(fileID,strcat('\t','// handle negative identities\n'));
fprintf(fileID,strcat('\t','// glue the main part to initial condition part\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t','y_out->vec0[i] = x_in->vec[0][i]*out_block[i];\n'));
fprintf(fileID,strcat('\t\t','y_out->vec[0][i] = x_in->vec0[i]*out_block[i];\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// glue different partitions\n'));
fprintf(fileID,strcat('\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t','for(i = 1, k = n_states*part_size; i < PAR; i++, k+= n_states*part_size)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS LOOP_FLATTEN\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec[i-1][(part_size-1)*(n_node_theta+n_node_eq)+n_node_theta+j] = x_in->vec[i][j]*out_block[k+j];\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec[i][j] = x_in->vec[i-1][(part_size-1)*(n_node_theta+n_node_eq)+n_node_theta+j]*out_block[k+j];\n'));
fprintf(fileID,strcat('\t\t','}\n\n'));

fprintf(fileID,strcat('\t','// handle interior of each partition \n'));
fprintf(fileID,strcat('\t','for(i = n_node_theta+n_node_eq, l=1; i < (n_node_theta+n_node_eq)*part_size; i+=(n_node_theta+n_node_eq), l++)\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t\t','for(k = 0; k < PAR; k++)\n'));
fprintf(fileID,strcat('\t\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS LOOP_FLATTEN\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t\t','y_out->vec[k][i+j-n_node_eq] = x_in->vec[k][i+j]*out_block[(k*part_size+l)*n_states+j];\n'));
fprintf(fileID,strcat('\t\t\t\t','y_out->vec[k][i+j] = x_in->vec[k][i+j-n_node_eq]*out_block[(k*part_size+l)*n_states+j];\n'));
fprintf(fileID,strcat('\t\t\t','}\n\n'));

fprintf(fileID,strcat('\t','#ifdef rem_partition\n'));
fprintf(fileID,strcat('\t','// glue remainder partition\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t','y_out->vec[PAR-1][part_size*(n_node_theta+n_node_eq) - n_node_eq+i] = x_in->vec_rem[i]*out_block[PAR*part_size*n_states + i];\n'));
fprintf(fileID,strcat('\t\t','y_out->vec_rem[i] = x_in->vec[PAR-1][part_size*(n_node_theta+n_node_eq)-n_node_eq+i]*out_block[PAR*part_size*n_states + i];\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// handle interior of remainder partition\n'));
fprintf(fileID,strcat('\t','for(i=(n_node_theta+n_node_eq),l=(PAR*part_size+1)*n_states; i < (n_node_theta+n_node_eq)*rem_partition; i+=(n_node_theta+n_node_eq), l+=n_states)\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS LOOP_FLATTEN\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec_rem[i-n_node_eq+j] = x_in->vec_rem[i+j]*out_block[l+j];\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec_rem[i+j] = x_in->vec_rem[i-n_node_eq+j]*out_block[l+j];\n'));
fprintf(fileID,strcat('\t\t','}\n\n'));

fprintf(fileID,strcat('\t','// glue terminal partition\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t','y_out->vec_rem[rem_partition*(n_node_theta+n_node_eq)-n_node_eq + i] = x_in->vec_term[i]*out_block[(PAR*part_size+rem_partition)*n_states + i];\n'));
fprintf(fileID,strcat('\t\t','y_out->vec_term[i] = x_in->vec_rem[rem_partition*(n_node_theta+n_node_eq)-n_node_eq + i]*out_block[(PAR*part_size+rem_partition)*n_states + i];\n'));
fprintf(fileID,strcat('\t','}\n'));

fprintf(fileID,strcat('\t','#else\n'));
fprintf(fileID,strcat('\t','// glue terminal partition\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_states; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t','y_out->vec[PAR-1][part_size*(n_node_theta+n_node_eq)-n_node_eq + i] = x_in->vec_term[i]*out_block[(PAR*part_size)*n_states + i];\n'));
fprintf(fileID,strcat('\t\t','y_out->vec_term[i] = x_in->vec[PAR-1][part_size*(n_node_theta+n_node_eq)-n_node_eq + i]*out_block[(PAR*part_size)*n_states + i];\n'));
fprintf(fileID,strcat('\t','}\n'));
fprintf(fileID,strcat('\t','#endif\n\n'));

fprintf(fileID,strcat('\t','int i_offset1, i_offset2;\n'));
fprintf(fileID,strcat('\t','merge_mv_mult:{\n'));
fprintf(fileID,strcat('\t\t','//#pragma HLS LOOP_MERGE\n'));
fprintf(fileID,strcat('\t\t','// handle nonzero elements in node blocks\n'));
fprintf(fileID,strcat('\t\t','for(i = 0,  i_offset1 = 0, i_offset2 = 0; i < part_size; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','//i_offset1 = i*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t\t\t','//i_offset2 = i*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t\t\t','for(j = 0; j < nnz_block; j++)\n'));
fprintf(fileID,strcat('\t\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS DEPENDENCE variable=y_out->vec array inter distance=',num2str(distance_achieved_node),' true\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS LOOP_FLATTEN\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t\t','for(k = 0; k < PAR; k++)\n'));
fprintf(fileID,strcat('\t\t\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t\t\t','#pragma HLS UNROLL skip_exit_check\n'));
fprintf(fileID,strcat('\t\t\t\t\t','y_out->vec[k][i_offset1+row_block_sched[j]] += block->mat[k][i_offset2 + num_block_sched[j]]*x_in->vec[k][i_offset1+col_block_sched[j]];\n'));
fprintf(fileID,strcat('\t\t\t\t','}\n'));
fprintf(fileID,strcat('\t\t\t','}\n'));
fprintf(fileID,strcat('\t\t','}\n\n'));

fprintf(fileID,strcat('\t\t','#ifdef rem_partition\n'));
fprintf(fileID,strcat('\t\t','for(i = 0, i_offset1 = 0, i_offset2 = 0; i < rem_partition; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','//i_offset1 = i*(n_node_theta+n_node_eq);\n'));
fprintf(fileID,strcat('\t\t\t','//i_offset2 = i*nnz_block_tril;\n'));
fprintf(fileID,strcat('\t\t\t','for(j = 0; j < nnz_block; j++)\n'));
fprintf(fileID,strcat('\t\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS DEPENDENCE variable=y_out->vec_rem array inter distance=',num2str(distance_achieved_node),' true\n'));
fprintf(fileID,strcat('\t\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t\t','y_out->vec_rem[i_offset1+row_block_sched[j]] += block->mat_rem[i_offset2 + num_block_sched[j]]*x_in->vec_rem[i_offset1+col_block_sched[j]];\n'));
fprintf(fileID,strcat('\t\t\t','}\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t\t','#endif\n'));

fprintf(fileID,strcat('\t','} // exclude the terminal block, because it might have different II\n\n'));

fprintf(fileID,strcat('\t\t','// handle the terminal block\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < nnz_term_block; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));

fprintf(fileID,strcat('\t\t\t','#pragma HLS DEPENDENCE variable=y_out->vec_term array inter distance=',num2str(distance_achieved_node_term),' true\n'));
fprintf(fileID,strcat('\t\t\t','#pragma HLS PIPELINE\n'));
fprintf(fileID,strcat('\t\t\t','y_out->vec_term[row_term_block_sched[j]] += block->mat_term[num_term_block_sched[j]]*x_in->vec_term[col_term_block_sched[j]];\n'));
fprintf(fileID,strcat('\t\t','}\n'));

fprintf(fileID,'}\n');
fclose(fileID);


cd ../code_generator/mv_mult_code

