#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"

#include "mex.h"

// this function performs matrix vector multiplication 
void mv_mult_prescaled(float y_out[n_all_theta+n_all_nu],float block[N*nnz_block_tril + nnz_term_block_tril],float out_block[(N+1)*n_states],float x_in[n_all_theta+n_all_nu])
{
	int i,j,k;
	// block pattern in COO format
	int row_block[159] = {0,2,4,21,22,27,28,32,33,34,38,2,23,32,38,24,29,30,32,35,36,38,4,25,32,38,26,31,32,37,38,6,28,32,34,38,39,7,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,0,0,0,1,1,1,1,1,1,1,2,2,2,3,3,3,3,3,3,3,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,};
	int col_block[159] = {0,0,0,0,1,1,1,1,1,1,1,2,2,2,2,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5,5,6,6,6,6,6,6,7,7,7,8,9,9,10,10,10,10,10,11,11,11,12,12,12,12,12,13,13,13,14,14,14,14,15,15,16,16,16,16,17,17,17,18,18,18,18,19,19,19,20,20,20,2,4,21,22,27,28,32,33,34,38,23,32,38,24,29,30,32,35,36,38,25,32,38,26,31,32,37,38,28,32,34,38,39,30,36,39,21,27,22,28,33,34,38,23,29,38,24,30,35,36,38,25,31,38,26,32,37,38,21,33,22,33,34,38,23,35,38,24,35,36,38,25,37,38,26,37,38,};
	int num_block[159] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,21,23,24,25,26,27,28,29,30,32,33,34,35,36,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,};

	// term_block pattern in COO format
	int row_term_block[11] = {0,2,4,7,2,4,7,0,0,0,6,};
	int col_term_block[11] = {0,0,0,0,2,4,6,2,4,7,7,};
	int num_term_block[11] = {0,1,2,3,4,5,6,1,2,3,6,};

	// reset output
	for(i = 0; i < n_all_theta+n_all_nu; i++)
		y_out[i] = 0;

	// handle negative identities
	for(i = 0; i < n_states; i++)
	{
		y_out[i] = x_in[n_states+i]*out_block[i];
	}
	for(i = 0; i < n_states; i++)
		y_out[n_states+i] = x_in[i]*out_block[i];
	for(i = n_states+n_node_theta, k = n_states; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq), k+=n_states)
		for(j = 0; j < n_states; j++)
			y_out[i+j+n_node_eq] = x_in[i+j]*out_block[k+j];
	for(i = n_states+n_node_theta, k = n_states; i < n_states+n_node_theta + N*(n_node_theta+n_node_eq); i+=(n_node_theta+n_node_eq), k+=n_states)
		for(j = 0; j < n_states; j++)
			y_out[i+j] = x_in[i+j+n_node_eq]*out_block[k+j];

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
