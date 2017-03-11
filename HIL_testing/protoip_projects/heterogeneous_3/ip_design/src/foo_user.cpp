/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/

#include "foo_data.h"
#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"
#include "user_prototypes_header.h"


void foo_user(  part_matrix *block_in_int,
				d_type_lanczos out_block_in_int[OUT_BLOCK_IN_LENGTH],
				data_t_x_in_in x_in_in_int[X_IN_IN_LENGTH],
				data_t_y_out_out y_out_out_int[Y_OUT_OUT_LENGTH])
{
/*
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
*/
	minres_HW(block_in_int, out_block_in_int, x_in_in_int, y_out_out_int);
}
