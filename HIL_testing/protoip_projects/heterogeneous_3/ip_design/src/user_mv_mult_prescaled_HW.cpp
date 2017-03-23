#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"

// this function performs matrix vector multiplication 
void mv_mult_prescaled_HW(part_vector *y_out,part_matrix *block,d_type_lanczos out_block[(N+1)*n_states],part_vector *x_in)
{
#pragma HLS INLINE
	int i,j,k,l;
	// block pattern in COO format
	int row_block_sched[157] = {38,1,32,2,10,18,35,13,22,28,29,38,1,32,2,10,18,36,13,22,28,31,38,1,32,4,12,18,36,13,22,28,31,38,1,32,4,12,18,36,17,23,30,39,38,1,32,4,12,33,36,17,23,30,39,38,1,32,4,12,33,37,17,23,30,8,38,1,6,4,12,33,37,19,24,0,38,3,6,5,14,33,37,19,24,0,38,3,6,5,14,34,37,19,24,9,38,3,6,5,14,34,7,20,25,9,38,3,6,5,14,34,7,20,25,15,38,3,6,5,16,34,7,20,25,15,38,3,2,10,16,35,11,21,26,27,38,3,2,10,16,35,11,21,26,27,38,32,2,10,16,35,11,21,26,29,38,};
	int col_block_sched[157] = {1,22,2,32,34,24,18,25,1,1,11,2,27,3,38,38,35,3,31,10,6,5,3,28,4,0,24,36,7,38,16,10,13,4,32,5,4,30,38,12,23,2,3,6,5,33,6,25,35,1,18,35,11,7,8,6,34,14,32,36,10,5,38,17,12,39,10,38,6,38,38,15,14,25,3,0,11,24,28,26,26,16,19,37,12,21,12,29,32,31,32,1,20,38,18,21,13,30,34,32,37,6,7,26,4,27,14,32,38,37,38,10,30,37,13,21,16,35,39,38,22,16,36,38,19,33,17,36,0,22,33,3,23,0,5,1,18,38,2,28,34,12,29,9,14,9,19,1,23,33,38,17,38,15,20,3,20,};
	int num_block_sched[157] = {10,4,13,13,46,72,73,56,4,6,49,14,5,18,14,47,73,20,57,43,32,27,21,6,24,2,51,74,39,58,65,44,57,25,7,28,22,52,75,54,69,12,17,36,30,8,33,23,53,8,74,70,48,38,40,35,9,60,24,54,45,29,71,69,52,40,47,10,31,25,55,64,61,76,15,0,50,15,32,26,59,66,77,77,51,3,55,16,33,27,60,9,80,78,72,41,58,17,34,28,61,34,37,79,23,42,62,18,35,29,62,46,38,80,56,63,68,19,36,30,65,67,39,81,76,64,71,20,1,43,66,19,48,3,26,5,75,21,11,44,67,53,49,41,59,42,78,7,12,45,68,70,50,63,79,16,81,};

	// term_block pattern in COO format
	int row_term_block_sched[9] = {0,2,4,7,6,0,2,4,7,};
	int col_term_block_sched[9] = {0,0,0,0,7,7,2,4,6,};
	int num_term_block_sched[9] = {0,1,2,3,6,3,4,5,6,};

	// reset output
	merge_reset:{
		#pragma HLS LOOP_MERGE
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
	merge_mv_mult:{
		//#pragma HLS LOOP_MERGE
		// handle nonzero elements in node blocks
		for(i = 0,  i_offset1 = 0, i_offset2 = 0; i < part_size; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)
		{
			//i_offset1 = i*(n_node_theta+n_node_eq);
			//i_offset2 = i*nnz_block_tril;
			for(j = 0; j < nnz_block; j++)
			{
				#pragma HLS DEPENDENCE variable=y_out->vec array inter distance=10 true
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
				#pragma HLS DEPENDENCE variable=y_out->vec_rem array inter distance=10 true
				#pragma HLS PIPELINE
				y_out->vec_rem[i_offset1+row_block_sched[j]] += block->mat_rem[i_offset2 + num_block_sched[j]]*x_in->vec_rem[i_offset1+col_block_sched[j]];
			}
		}
		#endif
	} // exclude the terminal block, because it might have different II

		// handle the terminal block
		for(j = 0; j < nnz_term_block; j++)
		{
			#pragma HLS DEPENDENCE variable=y_out->vec_term array inter distance=5 true
			#pragma HLS PIPELINE
			y_out->vec_term[row_term_block_sched[j]] += block->mat_term[num_term_block_sched[j]]*x_in->vec_term[col_term_block_sched[j]];
		}
}
