#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"

// this function performs matrix vector multiplication 
void mv_mult_prescaled_HW(part_vector *y_out,part_matrix *block,float out_block[(N+1)*n_states],part_vector *x_in)
{
#pragma HLS INLINE
	int i,j,k,l;
	// block pattern in COO format
	int row_block_sched[95] = {0,14,1,15,18,19,21,22,23,25,2,16,21,25,3,17,20,24,4,19,21,23,25,26,26,14,18,15,19,22,23,25,16,20,25,17,21,24,14,22,15,22,23,25,16,24,25,17,24,25,0,1,1,1,1,1,1,1,2,2,2,3,3,3,4,4,4,4,4,5,6,6,7,7,7,7,7,8,8,8,9,9,9,10,10,11,11,11,11,12,12,12,13,13,13,};
	int col_block_sched[95] = {0,0,1,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,4,5,6,6,7,7,7,7,7,8,8,8,9,9,9,10,10,11,11,11,11,12,12,12,13,13,13,14,15,18,19,21,22,23,25,16,21,25,17,20,24,19,21,23,25,26,26,14,18,15,19,22,23,25,16,20,25,17,21,24,14,22,15,22,23,25,16,24,25,17,24,25,};
	int num_block_sched[95] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,1,3,4,5,6,7,8,9,11,12,13,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,};

	// term_block pattern in COO format
	int row_term_block_sched[8] = {0,5,1,2,3,5,0,4,};
	int col_term_block_sched[8] = {0,0,1,2,3,4,5,5,};
	int num_term_block_sched[8] = {0,1,2,3,4,5,1,5,};

	// reset output
	for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		y_out->vec0[i] = 0;
	}
	for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
	{
		#pragma HLS PIPELINE
		for(i = 0; i < PAR; i++)
		{
			#pragma HLS UNROLL skip_exit_check
			y_out->vec[i][j] = 0;
		}
	}
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++) 
	{
		#pragma HLS PIPELINE
		y_out->vec_rem[i] = 0;
	}
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++)
	{
		#pragma HLS PIPELINE
		y_out->vec_term[i] = 0;
	}

	// handle negative identities
	// glue the main part to initial condition part
	for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		y_out->vec0[i] = x_in->vec[0][i]*out_block[i];
		y_out->vec[0][i] = x_in->vec0[i]*out_block[i];
	}

	// glue different partitions
	for(j = 0; j < n_states; j++)
		for(i = 1, k = n_states*part_size; i < PAR; i++, k+= n_states*part_size)
		{
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			y_out->vec[i-1][(part_size-1)*(n_node_theta+n_node_eq)+n_node_theta+j] = x_in->vec[i][j]*out_block[k+j];
			y_out->vec[i][j] = x_in->vec[i-1][(part_size-1)*(n_node_theta+n_node_eq)+n_node_theta+j]*out_block[k+j];
		}

	// handle interior of each partition 
	for(i = n_node_theta+n_node_eq, l=1; i < (n_node_theta+n_node_eq)*part_size; i+=(n_node_theta+n_node_eq), l++)
		for(j = 0; j < n_states; j++)
			for(k = 0; k < PAR; k++)
			{
				#pragma HLS LOOP_FLATTEN
				#pragma HLS PIPELINE
				y_out->vec[k][i+j-n_node_eq] = x_in->vec[k][i+j]*out_block[(k*part_size+l)*n_states+j];
				y_out->vec[k][i+j] = x_in->vec[k][i+j-n_node_eq]*out_block[(k*part_size+l)*n_states+j];
			}

	#ifdef rem_partition
	// glue remainder partition
	for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		y_out->vec[PAR-1][part_size*(n_node_theta+n_node_eq) - n_node_eq+i] = x_in->vec_rem[i]*out_block[PAR*part_size*n_states + i];
		y_out->vec_rem[i] = x_in->vec[PAR-1][part_size*(n_node_theta+n_node_eq)-n_node_eq+i]*out_block[PAR*part_size*n_states + i];
	}

	// handle interior of remainder partition
	for(i=(n_node_theta+n_node_eq),l=(PAR*part_size+1)*n_states; i < (n_node_theta+n_node_eq)*rem_partition; i+=(n_node_theta+n_node_eq), l+=n_states)
		for(j = 0; j < n_states; j++)
		{
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			y_out->vec_rem[i-n_node_eq+j] = x_in->vec_rem[i+j]*out_block[l+j];
			y_out->vec_rem[i+j] = x_in->vec_rem[i-n_node_eq+j]*out_block[l+j];
		}

	// glue terminal partition
	for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		y_out->vec_rem[rem_partition*(n_node_theta+n_node_eq)-n_node_eq + i] = x_in->vec_term[i]*out_block[(PAR*part_size+rem_partition)*n_states + i];
		y_out->vec_term[i] = x_in->vec_rem[rem_partition*(n_node_theta+n_node_eq)-n_node_eq + i]*out_block[(PAR*part_size+rem_partition)*n_states + i];
	}
	#else
	// glue terminal partition
	for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		y_out->vec[PAR-1][part_size*(n_node_theta+n_node_eq)-n_node_eq + i] = x_in->vec_term[i]*out_block[(PAR*part_size)*n_states + i];
		y_out->vec_term[i] = x_in->vec[PAR-1][part_size*(n_node_theta+n_node_eq)-n_node_eq + i]*out_block[(PAR*part_size)*n_states + i];
	}
	#endif

	int i_offset1, i_offset2;
	// handle nonzero elements in node blocks
	for(i = 0,  i_offset1 = 0, i_offset2 = 0; i < part_size; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)
	{
		//i_offset1 = i*(n_node_theta+n_node_eq);
		//i_offset2 = i*nnz_block_tril;
		for(j = 0; j < nnz_block; j++)
		{
			//#pragma HLS DEPENDENCE variable=y_out->vec array inter distance=8 true
			//#pragma HLS LOOP_FLATTEN
			//#pragma HLS PIPELINE
			for(k = 0; k < PAR; k++)
			{
				#pragma HLS UNROLL skip_exit_check
				y_out->vec[k][i_offset1+row_block_sched[j]] += block->mat[k][i_offset2 + num_block_sched[j]]*x_in->vec[k][i_offset1+col_block_sched[j]];
			}
		}
	}

	#ifdef rem_partition
	for(i = 0, i_offset1 = 0, i_offset2 = 0; i < rem_partition; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)
	{
		//i_offset1 = i*(n_node_theta+n_node_eq);
		//i_offset2 = i*nnz_block_tril;
		for(j = 0; j < nnz_block; j++)
		{
			//#pragma HLS DEPENDENCE variable=y_out->vec_rem array inter distance=8 true
			//#pragma HLS PIPELINE
			y_out->vec_rem[i_offset1+row_block_sched[j]] += block->mat_rem[i_offset2 + num_block_sched[j]]*x_in->vec_rem[i_offset1+col_block_sched[j]];
		}
	}
	#endif
	// handle the terminal block
	for(j = 0; j < nnz_term_block; j++)
	{
		//#pragma HLS PIPELINE
		//#pragma HLS DEPENDENCE variable=y_out->vec_term array inter distance=8 true
		//#pragma HLS PIPELINE
		y_out->vec_term[row_term_block_sched[j]] += block->mat_term[num_term_block_sched[j]]*x_in->vec_term[col_term_block_sched[j]];
	}
}
