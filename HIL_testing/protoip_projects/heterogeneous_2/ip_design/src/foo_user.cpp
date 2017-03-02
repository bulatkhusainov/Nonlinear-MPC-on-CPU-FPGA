/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"
#include "user_prototypes_header.h"


void lanczos_HW(int init, part_matrix *blocks, float out_blocks[], float v_current_in[n_linear], float v_current_out[n_linear], float sc_in[5], float sc_out[5]);

void foo_user(  data_t_init_in init_in_int[INIT_IN_LENGTH],
				data_t_sc_in_in sc_in_in_int[SC_IN_IN_LENGTH],
				data_t_block_in block_in_int[BLOCK_IN_LENGTH],
				data_t_out_block_in out_block_in_int[OUT_BLOCK_IN_LENGTH],
				data_t_v_in_in v_in_in_int[V_IN_IN_LENGTH],
				data_t_v_out_out v_out_out_int[V_OUT_OUT_LENGTH],
				data_t_sc_out_out sc_out_out_int[SC_OUT_OUT_LENGTH])
{

	int i,j,k;

	// interface structure
	part_matrix block_struct;

	// pack matrix into structure
	k = 0;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*nnz_block_tril; j++, k++) block_struct.mat[i][j] = block_in_int[k];
	#ifdef rem_partition
		for(i = 0; i < rem_partition*nnz_block_tril; i++, k++) block_struct.mat_rem[i] = block_in_int[k];
	#endif
	for(i = 0; i < nnz_term_block_tril; i++, k++) block_struct.mat_term[i] = block_in_int[k];


	lanczos_HW((int) init_in_int[0], &block_struct, out_block_in_int, v_in_in_int, v_out_out_int, init_in_int, sc_out_out_int);


}
