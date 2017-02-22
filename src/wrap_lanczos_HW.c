#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"
#include "user_prototypes_header.h"


void wrap_lanczos_HW(int init, float blocks[], float out_blocks[], float v_current_in[n_linear], float v_current_out[n_linear], float sc_in[5], float sc_out[5])
{
	int i,j,k;

	// interface structure
	part_matrix block_struct;

	// pack matrix into structure
	k = 0;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*nnz_block_tril; j++, k++) block_struct.mat[i][j] = blocks[k];
	#ifdef rem_partition		
		for(i = 0; i < rem_partition*nnz_block_tril; i++, k++) block_struct.mat_rem[i] = blocks[k];
	#endif
	for(i = 0; i < nnz_term_block_tril; i++, k++) block_struct.mat_term[i] = blocks[k];

	// call the function
	lanczos_HW(init, &block_struct,  out_blocks, v_current_in, v_current_out, sc_in, sc_out);

}