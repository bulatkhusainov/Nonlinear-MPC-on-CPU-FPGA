#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"

// this function performs matrix vector multiplication 
void mv_mult(float y_out[n_all_theta+n_all_nu],float block[N*nnz_block_tril + nnz_term_block_tril],float x_in[n_all_theta+n_all_nu])
{
	int i,j,k;
	// block pattern in COO format
	int row_block[95] = {0,14,1,15,18,19,21,22,23,25,2,16,21,25,3,17,20,24,4,19,21,23,25,26,26,14,18,15,19,22,23,25,16,20,25,17,21,24,14,22,15,22,23,25,16,24,25,17,24,25,0,1,1,1,1,1,1,1,2,2,2,3,3,3,4,4,4,4,4,5,6,6,7,7,7,7,7,8,8,8,9,9,9,10,10,11,11,11,11,12,12,12,13,13,13,};
	int col_block[95] = {0,0,1,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,4,4,5,6,6,7,7,7,7,7,8,8,8,9,9,9,10,10,11,11,11,11,12,12,12,13,13,13,14,15,18,19,21,22,23,25,16,21,25,17,20,24,19,21,23,25,26,26,14,18,15,19,22,23,25,16,20,25,17,21,24,14,22,15,22,23,25,16,24,25,17,24,25,};
	int num_block[95] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,1,3,4,5,6,7,8,9,11,12,13,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,};

	// term_block pattern in COO format
	int row_term_block[8] = {0,5,1,2,3,5,0,4,};
	int col_term_block[8] = {0,0,1,2,3,4,5,5,};
	int num_term_block[8] = {0,1,2,3,4,5,1,5,};

	// reset output
	for(i = 0; i < n_all_theta+n_all_nu; i++)
		y_out[i] = 0;

	// handle negative identities
	for(i = 0; i < n_states; i++)
		y_out[i] = -x_in[n_states+i];
	for(i = 0; i < n_states; i++)
		y_out[n_states+i] = -x_in[i];
	for(i = n_states+n_node_theta; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq))
		for(j = 0; j < n_states; j++)
			y_out[i+j+n_node_eq] = -x_in[i+j];
	for(i = n_states+n_node_theta; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq))
		for(j = 0; j < n_states; j++)
			y_out[i+j] = -x_in[i+j+n_node_eq];

	int i_offset1, i_offset2;
	// handle nonzero elements in node blocks
	for(i = 0; i < N; i++)
	{
		i_offset1 = n_states + i*(n_node_theta+n_node_eq);
		i_offset2 = i*nnz_block_tril;
		for(j = 0; j < nnz_block; j++)
		{
			y_out[i_offset1+row_block[j]] += block[i_offset2 + num_block[j]]*x_in[i_offset1+col_block[j]];
		}
	}

	// handle the terminal block
	i_offset1 = n_states + N*(n_node_theta+n_node_eq);
	i_offset2 = N*nnz_block_tril;
	for(j = 0; j < nnz_term_block; j++)
	{
		y_out[i_offset1+row_term_block[j]] += block[i_offset2 + num_term_block[j]]*x_in[i_offset1+col_term_block[j]];
	}
}
