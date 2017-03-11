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
	int row_block_sched[158] = {38,1,32,6,2,18,36,17,24,0,38,1,32,6,4,33,37,19,24,0,38,1,32,6,4,33,37,19,24,9,38,1,32,10,4,33,37,19,25,9,38,1,32,10,4,33,37,20,25,15,38,1,32,10,14,34,7,20,25,15,38,1,32,10,14,34,7,20,26,27,38,1,5,10,14,34,7,21,26,27,38,3,5,12,14,34,11,21,26,29,38,3,5,12,16,35,11,21,28,29,38,3,5,12,16,35,11,22,28,31,38,3,5,12,16,35,13,22,28,31,38,3,5,12,16,35,13,22,30,39,38,3,6,2,18,36,13,23,30,39,38,3,6,2,18,36,17,23,30,8,38,3,6,2,18,36,17,23,};
	int col_block_sched[158] = {1,38,14,32,2,24,3,23,18,21,2,34,6,28,38,16,20,38,12,0,3,33,5,6,32,15,19,37,3,27,4,32,4,38,25,10,14,25,19,21,5,28,3,34,4,1,5,38,13,33,6,27,2,33,38,16,36,37,4,21,10,22,1,28,37,10,30,26,20,9,11,1,38,22,32,6,7,15,14,1,12,38,37,38,26,1,38,9,5,11,13,36,32,36,38,18,29,0,10,3,14,35,31,35,34,17,23,16,6,13,16,32,26,30,33,12,38,10,1,5,17,30,5,24,22,3,31,1,12,8,18,29,39,38,38,18,25,17,7,6,19,24,38,32,36,12,38,11,3,39,20,3,34,23,35,7,35,2,};
	int num_block_sched[158] = {9,9,61,34,10,73,20,70,73,1,13,8,34,33,25,67,81,79,52,0,21,7,29,32,24,65,78,78,15,43,25,6,24,48,23,46,62,77,77,42,31,5,18,47,22,7,30,82,57,65,36,4,12,46,63,68,40,81,23,64,48,3,6,45,62,47,39,80,80,43,51,2,31,44,61,35,38,64,60,4,56,21,30,56,60,8,51,42,27,50,59,20,29,55,69,74,50,1,45,16,63,19,28,54,68,71,49,66,33,58,69,18,27,53,67,54,59,44,5,28,72,17,26,52,66,19,58,3,53,41,76,16,37,13,76,75,57,70,39,37,79,15,36,12,75,55,72,49,17,41,82,14,35,11,74,40,71,11,};

	// term_block pattern in COO format
	int row_term_block_sched[10] = {0,7,1,3,5,0,7,2,4,6,};
	int col_term_block_sched[10] = {0,6,1,3,5,7,0,2,4,7,};
	int num_term_block_sched[10] = {0,7,2,4,6,1,1,3,5,7,};

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
			#pragma HLS DEPENDENCE variable=y_out->vec array inter distance=9 true
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
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
			#pragma HLS DEPENDENCE variable=y_out->vec_rem array inter distance=9 true
			#pragma HLS PIPELINE
			y_out->vec_rem[i_offset1+row_block_sched[j]] += block->mat_rem[i_offset2 + num_block_sched[j]]*x_in->vec_rem[i_offset1+col_block_sched[j]];
		}
	}
	#endif
	// handle the terminal block
	for(j = 0; j < nnz_term_block; j++)
	{
		#pragma HLS DEPENDENCE variable=y_out->vec_term array inter distance=4 true
		#pragma HLS PIPELINE
		y_out->vec_term[row_term_block_sched[j]] += block->mat_term[num_term_block_sched[j]]*x_in->vec_term[col_term_block_sched[j]];
	}
}
