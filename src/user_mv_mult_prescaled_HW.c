#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"

//#include "mex.h"

#define n_NOPs_node      81  // # number of NOPs for pipilening (in each node) 
#define n_NOPs_node_term 37  // # number of NOPs for pipilening (in terminal node) 

// this function performs matrix vector multiplication 
void mv_mult_prescaled_HW(part_vector *y_out,part_matrix *block,d_type_lanczos out_block[(N+1)*n_states],part_vector *x_in)
{
#pragma HLS INLINE
	int i,j,k,l;
	// block pattern in COO format
	int row_block_sched[241] = {38,1,32,6,10,14,34,7,20,25,27,21,21,21,21,21,38,1,32,6,10,16,34,7,20,25,27,21,21,21,21,21,38,1,32,6,10,16,35,11,21,26,29,21,21,21,21,21,38,1,32,2,12,16,35,11,21,26,29,21,21,21,21,21,38,1,32,2,12,16,35,11,21,26,31,21,21,21,21,21,38,1,32,2,12,18,35,13,22,28,31,21,21,21,21,21,38,1,5,2,12,18,36,13,22,28,39,21,21,21,21,21,38,3,5,2,12,18,36,13,22,28,39,21,21,21,21,21,38,3,5,4,0,18,36,17,23,30,8,21,21,21,21,21,38,3,5,4,0,33,36,17,23,30,21,21,21,21,21,21,38,3,5,4,0,33,37,17,23,30,21,21,21,21,21,21,38,3,5,4,0,33,37,19,24,9,21,21,21,21,21,21,38,3,6,4,14,33,37,19,24,9,21,21,21,21,21,21,38,3,6,10,14,34,37,19,24,15,21,21,21,21,21,21,38,32,6,10,14,34,7,20,25,15,21,21,21,21,21,21,38,};
	int col_block_sched[241] = {1,22,2,34,33,38,10,30,37,13,1,21,21,21,21,21,2,27,3,38,34,22,16,36,38,19,9,21,21,21,21,21,3,28,4,39,38,33,3,23,0,5,3,21,21,21,21,21,4,32,5,0,24,34,12,29,9,14,11,21,21,21,21,21,5,33,6,2,30,38,17,38,15,20,5,21,21,21,21,21,6,34,14,23,35,24,18,25,1,1,13,21,21,21,21,21,10,38,5,32,36,35,3,31,10,6,6,21,21,21,21,21,11,24,26,38,38,36,7,38,16,10,8,21,21,21,21,21,12,29,31,0,0,38,12,23,2,3,39,21,21,21,21,21,13,30,32,4,2,1,18,35,11,7,21,21,21,21,21,21,14,32,37,25,4,10,5,38,17,12,21,21,21,21,21,21,16,35,38,32,21,15,14,25,3,21,21,21,21,21,21,21,17,36,6,38,26,16,19,37,12,27,21,21,21,21,21,21,18,38,28,22,32,1,20,38,18,21,21,21,21,21,21,21,19,1,32,28,37,6,7,26,4,33,21,21,21,21,21,21,20,};
	int num_block_sched[241] = {10,4,13,35,46,63,47,39,81,57,5,83,83,83,83,83,14,5,18,36,47,66,68,40,82,77,43,83,83,83,83,83,21,6,24,37,48,67,19,49,3,27,16,83,83,83,83,83,25,7,29,1,52,68,54,50,42,60,50,83,83,83,83,83,31,8,34,11,53,69,71,51,64,80,28,83,83,83,83,83,36,9,61,12,54,73,74,57,4,6,58,83,83,83,83,83,48,10,26,13,55,74,20,58,44,33,37,83,83,83,83,83,51,15,27,14,56,75,40,59,66,45,41,83,83,83,83,83,56,16,28,2,0,76,55,70,12,17,41,83,83,83,83,83,59,17,29,22,1,8,75,71,49,39,83,83,83,83,83,83,63,18,30,23,2,46,30,72,70,53,83,83,83,83,83,83,69,19,31,24,3,65,62,77,15,42,83,83,83,83,83,83,72,20,32,25,60,67,78,78,52,43,83,83,83,83,83,83,76,21,33,44,61,9,81,79,73,64,83,83,83,83,83,83,79,7,34,45,62,35,38,80,23,65,83,83,83,83,83,83,82,};

	// term_block pattern in COO format
	int row_term_block_sched[49] = {0,2,4,5,7,7,7,7,7,7,7,7,7,7,7,7,0,2,7,6,7,7,7,7,7,7,7,7,7,7,7,7,0,4,7,7,7,7,7,7,7,7,7,7,7,7,7,7,0,};
	int col_term_block_sched[49] = {0,0,4,5,7,7,7,7,7,7,7,7,7,7,7,7,2,2,0,7,7,7,7,7,7,7,7,7,7,7,7,7,4,0,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,};
	int num_term_block_sched[49] = {0,1,5,6,8,8,8,8,8,8,8,8,8,8,8,8,1,4,3,7,8,8,8,8,8,8,8,8,8,8,8,8,2,2,7,8,8,8,8,8,8,8,8,8,8,8,8,8,3,};

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
		#pragma HLS LOOP_MERGE
		// handle nonzero elements in node blocks
		for(i = 0,  i_offset1 = 0, i_offset2 = 0; i < part_size; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)
		{
			//i_offset1 = i*(n_node_theta+n_node_eq);
			//i_offset2 = i*nnz_block_tril;
			for(j = 0; j < (nnz_block-1+n_NOPs_node); j++)
			{
				#pragma HLS DEPENDENCE variable=y_out->vec inter distance=15 true
				#pragma HLS LOOP_FLATTEN
				#pragma HLS PIPELINE
			if(!( (row_block_sched[j] == n_node_theta) && (col_block_sched[j] == n_node_theta)))
			{
				for(k = 0; k < PAR; k++)
				{
					#pragma HLS UNROLL skip_exit_check
					y_out->vec[k][i_offset1+row_block_sched[j]] += block->mat[k][i_offset2 + num_block_sched[j]]*x_in->vec[k][i_offset1+col_block_sched[j]];
				}
			}
			}
		}

		#ifdef rem_partition
		for(i = 0, i_offset1 = 0, i_offset2 = 0; i < rem_partition; i++, i_offset1+=(n_node_theta+n_node_eq), i_offset2+=nnz_block_tril)
		{
			//i_offset1 = i*(n_node_theta+n_node_eq);
			//i_offset2 = i*nnz_block_tril;
			for(j = 0; j < (nnz_block-1+n_NOPs_node); j++)
			{
				#pragma HLS DEPENDENCE variable=y_out->vec_rem inter distance=16 true
				#pragma HLS PIPELINE
				y_out->vec_rem[i_offset1+row_block_sched[j]] += block->mat_rem[i_offset2 + num_block_sched[j]]*x_in->vec_rem[i_offset1+col_block_sched[j]];
			}
		}
		#endif
		// handle the terminal block
		debug_loop:for(j = 0; j < (nnz_term_block-1+n_NOPs_node_term); j++)
		{
			#pragma HLS DEPENDENCE variable=y_out->vec_term inter distance=15 true
			#pragma HLS PIPELINE
			if(( num_term_block_sched[j] != 8))
			{
			//printf("ab  ");
			y_out->vec_term[row_term_block_sched[j]] += block->mat_term[num_term_block_sched[j]]*x_in->vec_term[col_term_block_sched[j]];
			}
		}
	} // exclude from merging 

}
