#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_prototypes_header.h"

extern float minres_data[5];

// this function prescales orginal linear system and calls MINRES solver,
void prescaler(float blocks[N*nnz_block_tril + nnz_term_block_tril],float b[n_all_theta+n_all_nu],float x_current[n_all_theta+n_all_nu])
{
	int i,j,k;
	int i_offset1, i_offset2, i_offset3;
	float *local_ptr1, *local_ptr2, *local_ptr3, *local_ptr4, *local_ptr5; // local pointers for efficient handling of nested loops
	float M[n_all_theta+n_all_nu];
	float out_blocks[(N+1)*n_states];

	// block pattern in COO format
	int row_block[157] = {0,2,4,21,22,27,28,32,33,34,38,2,23,32,38,24,29,30,32,35,36,38,4,25,32,38,26,31,32,37,38,6,28,32,34,38,39,7,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,0,1,1,1,1,1,1,1,2,2,2,3,3,3,3,3,3,3,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,};
	int col_block[157] = {0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,21,22,27,28,32,33,34,38,23,32,38,24,29,30,32,35,36,38,25,32,38,26,31,32,37,38,28,32,34,38,39,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,};
	int num_block[157] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,21,23,24,25,26,27,28,29,30,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,};

	// term_block pattern in COO format
	int row_term_block[9] = {0,2,4,7,2,4,7,0,6,};
	int col_term_block[9] = {0,0,0,0,2,4,6,7,7,};
	int num_term_block[9] = {0,1,2,3,4,5,6,3,6,};

	// block_tril pattern in COO format
	int row_block_tril[82] = {0,2,4,21,22,27,28,32,33,34,38,2,23,32,38,24,29,30,32,35,36,38,4,25,32,38,26,31,32,37,38,6,28,32,34,38,39,7,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,};
	int col_block_tril[82] = {0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,};
	int num_block_tril[82] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,};

	// term_block_tril pattern in COO format
	int row_term_block_tril[7] = {0,2,4,7,2,4,7,};
	int col_term_block_tril[7] = {0,0,0,0,2,4,6,};
	int num_term_block_tril[7] = {0,1,2,3,4,5,6,};

	// intitialize prescaler
	for(i = 0; i < n_states; i++) M[i] = 1;
	for(i = 0; i < N; i++)
	{
		local_ptr1 = &M[n_states + i*(n_node_theta+n_node_eq)];
		for(j = 0; j < n_states; j++) local_ptr1[j] = 1;
		local_ptr1 += n_states;
		for(j = 0; j < n_node_theta-n_states; j++) local_ptr1[j] = 0;
		local_ptr1 += (n_node_theta-n_states);
		for(j = 0; j < n_states; j++) local_ptr1[j] = 1;
		local_ptr1 += n_states;
		for(j = 0; j < (n_node_eq-n_states); j++) local_ptr1[j] = 0;
	}
	local_ptr1 = &M[n_states + N*(n_node_theta+n_node_eq)];
	for(j = 0; j < (n_states); j++) local_ptr1[j] = 1;
	local_ptr1 += n_states;
	for(j = 0; j < (n_term_theta + n_term_eq - n_states); j++) local_ptr1[j] = 0;

	// handle blocks
	for(i = 0; i < N; i++)
	{
		i_offset1 = n_states + i*(n_node_theta+n_node_eq);
		i_offset2 = i*nnz_block_tril;
		for(j = 0; j < nnz_block; j++)
		{
			M[i_offset1 + row_block[j]] += fabsf(blocks[i_offset2 + num_block[j]]);
		}
	}
	i_offset1 = n_states + N*(n_node_theta+n_node_eq);
	i_offset2 = N*nnz_block_tril;
	for(i = 0; i < nnz_term_block; i++)
			M[i_offset1 + row_term_block[i]] += fabsf(blocks[i_offset2 + num_term_block[i]]);

	// calculate prescaler
	for(i = 0; i < n_all_theta+n_all_nu; i++) M[i] = 1/sqrtf(M[i]);

	// apply prescaler to out_blocks[] 
	for(i = 0; i < n_states; i++) out_blocks[i] = -M[i]*M[i+n_states];
	for(i = 1; i < N+1; i++)
	{
		i_offset1 = n_states + (n_node_theta + n_node_eq)*i;
		i_offset2 = n_states + n_node_theta +  (n_node_theta + n_node_eq)*(i-1);
		i_offset3 = i*n_states;
		for(j = 0; j < n_states; j++)
		{
			out_blocks[i_offset3 + j] = -M[i_offset1 + j]*M[i_offset2 + j]; 
		}
	}
	// apply prescaler to blocks[] 
	for(i = 0; i < N; i++)
	{
		local_ptr1 = &blocks[i*nnz_block_tril];
		local_ptr2 = &M[n_states + i*(n_node_theta+n_node_eq)];
		for(j = 0; j < nnz_block_tril; j++)
			local_ptr1[num_block_tril[j]] *= local_ptr2[row_block_tril[j]]*local_ptr2[col_block_tril[j]];
	}
	local_ptr1 = &blocks[N*nnz_block_tril];
	local_ptr2 = &M[n_states + N*(n_node_theta+n_node_eq)];
	for(i = 0; i < nnz_term_block_tril; i++)
		local_ptr1[num_term_block_tril[i]] *= local_ptr2[row_term_block_tril[i]]*local_ptr2[col_term_block_tril[i]];

	// apply prescaler to b[] 
	for(i = 0; i < n_all_theta+n_all_nu; i++)
		b[i] = b[i]*M[i];

	// solve scaled problem 
	// ifdef is to ensure propper compilation in unprescaled mode 
	#ifdef MINRES_prescaled
		#if heterogeneity > 2
			#ifdef PROTOIP
			send_minres_data_in(minres_data);
			send_block_in(blocks);
			send_out_block_in(out_blocks);
			send_x_in_in(b);
			start_foo(1,1,1,1,1);
			while(!(finished_foo())){;} // wait for IP to finish
			receive_y_out_out(x_current);
			#else
			wrap_minres_HW(blocks, out_blocks, b, x_current, minres_data); // HW realization
			#endif
		#else
		minres(blocks, out_blocks, b, x_current, minres_data); // SW realization
		#endif
	#endif
	// recover solution 
	for(i = 0; i < n_all_theta+n_all_nu; i++)
		x_current[i] *= M[i];

	//mv_mult_prescaled(x_current,blocks, out_blocks,b);
}
