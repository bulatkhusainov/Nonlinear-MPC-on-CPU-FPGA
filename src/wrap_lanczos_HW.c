#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"
#include "user_prototypes_header.h"



void wrap_lanczos_HW(int init, float blocks[], float out_blocks[], float v_current_in[n_linear], float v_current_out[n_linear], float sc_in[5], float sc_out[5])
{
	#if heterogeneity == 2

	int i,j,k;

	// interface structure
	part_matrix block_struct;
	d_type_lanczos out_blocks_casted[(N+1)*n_states];

	// pack matrix into structure
	k = 0;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*nnz_block_tril; j++, k++) block_struct.mat[i][j] = (d_type_lanczos) blocks[k];
	#ifdef rem_partition		
		for(i = 0; i < rem_partition*nnz_block_tril; i++, k++) block_struct.mat_rem[i] = (d_type_lanczos) blocks[k];
	#endif
	for(i = 0; i < nnz_term_block_tril; i++, k++) block_struct.mat_term[i] = (d_type_lanczos) blocks[k];

	// cast out blocks to required precision
	for(i = 0; i < (N+1)*n_states; i++)
		out_blocks_casted[i] = (d_type_lanczos) out_blocks[i];
	

	// call the function
	lanczos_HW(init, &block_struct,  out_blocks_casted, v_current_in, v_current_out, sc_in, sc_out);
	
	#endif
}

