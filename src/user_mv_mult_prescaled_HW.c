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
	int row_block_sched[158] = {0,21,1,22,27,28,32,33,34,38,2,23,32,38,3,24,29,30,32,35,36,38,4,25,32,38,5,26,31,32,37,38,6,28,32,34,38,39,7,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,0,1,1,1,1,1,1,1,2,2,2,3,3,3,3,3,3,3,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,};
	int col_block_sched[158] = {0,0,1,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,21,22,27,28,32,33,34,38,23,32,38,24,29,30,32,35,36,38,25,32,38,26,31,32,37,38,28,32,34,38,39,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,};
	int num_block_sched[158] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,1,3,4,5,6,7,8,9,11,12,13,15,16,17,18,19,20,21,23,24,25,27,28,29,30,31,33,34,35,36,37,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,};

	// term_block pattern in COO format
	int row_term_block_sched[10] = {0,7,1,2,3,4,5,7,0,6,};
	int col_term_block_sched[10] = {0,0,1,2,3,4,5,6,7,7,};
	int num_term_block_sched[10] = {0,1,2,3,4,5,6,7,1,7,};

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
