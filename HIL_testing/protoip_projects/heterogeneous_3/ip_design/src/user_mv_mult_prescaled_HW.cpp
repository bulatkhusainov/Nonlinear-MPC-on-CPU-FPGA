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
	int row_block_sched[158] = {38,1,3,6,2,16,35,11,21,26,29,38,1,32,6,2,18,35,13,22,28,29,38,1,32,6,2,18,36,13,22,28,31,38,1,32,6,2,18,36,13,22,28,31,38,1,32,6,4,18,36,17,23,30,39,38,1,32,10,4,33,36,17,23,30,39,38,1,32,10,4,33,37,17,23,30,8,38,1,32,10,4,33,37,19,24,0,38,3,5,10,14,33,37,19,24,0,38,3,5,10,14,34,37,19,24,9,38,3,5,12,14,34,7,20,25,9,38,3,5,12,14,34,7,20,25,15,38,3,5,12,16,34,7,20,25,15,38,3,5,12,16,35,11,21,26,27,38,3,6,12,16,35,11,21,26,27,38,};
	int col_block_sched[158] = {1,1,38,28,2,38,17,38,15,20,3,2,22,1,32,23,24,18,25,1,1,11,3,27,2,34,32,35,3,31,10,6,5,4,28,3,38,38,36,7,38,16,10,13,5,32,4,39,4,38,12,23,2,3,6,6,33,5,22,25,1,18,35,11,7,8,10,34,6,28,32,10,5,38,17,12,39,11,38,14,33,38,15,14,25,3,0,12,3,5,34,26,16,19,37,12,21,13,24,26,38,32,1,20,38,18,21,14,29,31,24,37,6,7,26,4,27,16,30,32,30,38,10,30,37,13,21,17,32,37,35,22,16,36,38,19,33,18,35,38,36,33,3,23,0,5,1,19,36,6,38,34,12,29,9,14,9,20,};
	int num_block_sched[158] = {9,2,21,33,10,69,71,51,64,80,16,13,3,6,34,11,73,74,57,3,5,50,21,4,12,35,12,74,20,58,44,33,28,25,5,18,36,13,75,40,59,66,45,58,31,6,24,37,22,76,55,70,11,17,37,36,7,29,44,23,7,75,71,49,39,41,48,8,34,45,24,46,30,72,70,53,41,51,9,61,46,25,65,62,77,15,0,56,14,26,47,60,67,78,78,52,1,59,15,27,48,61,8,81,79,73,42,63,16,28,52,62,35,38,80,23,43,69,17,29,53,63,47,39,81,57,64,72,18,30,54,66,68,40,82,77,65,76,19,31,55,67,19,49,1,27,4,79,20,32,56,68,54,50,42,60,43,82,};

	// term_block pattern in COO format
	int row_term_block_sched[10] = {0,7,1,2,3,4,5,6,0,7,};
	int col_term_block_sched[10] = {0,0,1,2,3,4,5,7,7,6,};
	int num_term_block_sched[10] = {0,1,2,3,4,5,6,7,1,7,};

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
			#pragma HLS DEPENDENCE variable=y_out->vec_term array inter distance=8 true
			#pragma HLS PIPELINE
			y_out->vec_term[row_term_block_sched[j]] += block->mat_term[num_term_block_sched[j]]*x_in->vec_term[col_term_block_sched[j]];
		}
}
