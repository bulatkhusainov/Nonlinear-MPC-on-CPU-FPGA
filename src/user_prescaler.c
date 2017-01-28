#include "user_main_header.h"
#include "user_nnz_header.h"

// this function prescales orginal linear system and calls MINRES solver,
void prescaler(float blocks[N*nnz_block_tril + nnz_term_block_tril],float b[n_all_theta+n_all_nu],float x_current[n_all_theta+n_all_nu])
{
	int i,j,k;
	int i_offset1, i_offset2, i_offset3;
	float *local_ptr1, *local_ptr2, *local_ptr3, *local_ptr4, *local_ptr5; // local pointers for efficient handling of nested loops
	float M[n_all_theta+n_all_nu];
	float out_blocks[(N+1)*n_states];

	// block pattern in COO format
	int row_block[28] = {0,6,8,9,1,7,8,2,8,10,3,10,6,8,7,9,0,0,0,1,1,2,2,3,4,4,5,5,};
	int col_block[28] = {0,0,0,0,1,1,1,2,2,2,3,3,4,4,5,5,6,8,9,7,8,8,10,10,6,8,7,9,};
	int num_block[28] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,1,2,3,5,6,8,9,11,12,13,14,15,};

	// term_block pattern in COO format
	int row_term_block[6] = {0,3,1,3,0,2,};
	int col_term_block[6] = {0,0,1,2,3,3,};
	int num_term_block[6] = {0,1,2,3,1,3,};

	// block_tril pattern in COO format
	int row_block_tril[16] = {0,6,8,9,1,7,8,2,8,10,3,10,6,8,7,9,};
	int col_block_tril[16] = {0,0,0,0,1,1,1,2,2,2,3,3,4,4,5,5,};
	int num_block_tril[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,};

	// term_block_tril pattern in COO format
	int row_term_block_tril[4] = {0,3,1,3,};
	int col_term_block_tril[4] = {0,0,1,2,};
	int num_term_block_tril[4] = {0,1,2,3,};

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
	for(i = 0; i < n_all_theta+n_all_nu; i++) x_current[i] = 1/sqrtf(M[i]);

	// apply prescaler to out_blocks[] 
	for(i = 0; i < n_states; i++) out_blocks[i] = M[i]*M[i+1];
	for(i = 1; i < N+1; i++)
	{
		i_offset1 = n_states + n_node_theta + n_node_eq;
		i_offset2 = n_states + n_node_theta;
		i_offset3 = i*n_states;
		for(j = 0; j < n_states; j++)
		{
			out_blocks[i_offset3 + j] = M[i_offset1 + j]*M[i_offset2 + j]; 
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
}
