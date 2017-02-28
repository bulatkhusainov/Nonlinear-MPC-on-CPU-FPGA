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
				data_t_out_block_in out_block_in_int[OUT_BLOCK_IN_LENGTH],
				part_vector *x_in_struct,
				part_vector *y_out_out_int)
{
	mv_mult_prescaled_HW( y_out_out_int, block_in_int, out_block_in_int, x_in_struct);
}



/*
	//int i,j,k;

	//float *block = block_in_int;
	//float *x_in = x_in_in_int;
	//float *out_block = out_block_in_int;
	//float *y_out = y_out_out_int;

	// interface structure
	//part_vector x_in_struct;
	//part_vector y_out_struct;


	// pack vector into structure
	for(i = 0, k = 0; i < n_states; i++, k++) x_in_struct.vec0[i] = x_in[k];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++, k++) x_in_struct.vec[i][j] = x_in[k];
	#ifdef rem_partition
		for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++, k++)  x_in_struct.vec_rem[i] = x_in[k];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++, k++) x_in_struct.vec_term[i] = x_in[k];


	// pack matrix into structure
	for(i = 0, k = 0; i < PAR; i++)
		for(j = 0; j < part_size*nnz_block_tril; j++, k++) block_struct.mat[i][j] = block[k];
	#ifdef rem_partition
		for(i = 0; i < rem_partition*nnz_block_tril; i++, k++) block_struct.mat_rem[i] = block[k];
	#endif
	for(i = 0; i < nnz_term_block_tril; i++, k++) block_struct.mat_term[i] = block[k];

	//mv_mult_prescaled_HW( y_out_out_int, block_in_int, out_block_in_int, x_in_struct);


	// unpack structure into a vector
	for(i = 0, k = 0; i < n_states; i++, k++) y_out[k] = y_out_struct.vec0[i];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++, k++) y_out[k] = y_out_struct.vec[i][j];
	#ifdef rem_partition
		for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++, k++)  y_out[k] = y_out_struct.vec_rem[i];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++, k++) y_out[k] = y_out_struct.vec_term[i];*/
