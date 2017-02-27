/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"


void foo_user(  part_matrix *block_in_int,
				data_t_out_block_in out_block_in_int[OUT_BLOCK_IN_LENGTH],
				part_vector *x_in_struct,
				data_t_y_out_out y_out_out_int[Y_OUT_OUT_LENGTH]);


void foo	(
				uint32_t byte_block_in_offset,
				uint32_t byte_out_block_in_offset,
				uint32_t byte_x_in_in_offset,
				uint32_t byte_y_out_out_offset,
				volatile data_t_memory *memory_inout)
{

	//static data_t_block_in  block_in_int[BLOCK_IN_LENGTH];
	static data_t_out_block_in  out_block_in_int[OUT_BLOCK_IN_LENGTH];
	//static data_t_x_in_in  x_in_in_int[X_IN_IN_LENGTH];
	data_t_y_out_out  y_out_out_int[Y_OUT_OUT_LENGTH];


	part_matrix  block_in_int;

	part_vector x_in_in_int;
#pragma HLS ARRAY_PARTITION variable=x_in_in_int.vec complete dim=1

	if(!(byte_block_in_offset & (1<<31)))
	{
		my_loop1:for(int i = 0; i < PAR; i++)
		{
			memcpy(&block_in_int.mat[i][0],(const data_t_memory*)(memory_inout+byte_block_in_offset/4+(i*part_size)*nnz_block_tril),
					(part_size*nnz_block_tril)*sizeof(data_t_memory));
		}


		memcpy(block_in_int.mat_term,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+((PAR*part_size)*nnz_block_tril)),
														nnz_term_block_tril*sizeof(data_t_memory));
		//memcpy(block_in_int,(const data_t_memory*)(memory_inout+byte_block_in_offset/4),BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}


	if(!(byte_out_block_in_offset & (1<<31)))
	{
		memcpy(out_block_in_int,(const data_t_memory*)(memory_inout+byte_out_block_in_offset/4),OUT_BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}


	if(!(byte_x_in_in_offset & (1<<31)))
	{
		memcpy(x_in_in_int.vec0,(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4),n_states*sizeof(data_t_memory));
		my_loop:for(int i = 0; i < PAR; i++)
		{
#pragma HLS PIPELINE
			memcpy(&x_in_in_int.vec[i][0],(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4+n_states+(i*part_size*(n_node_theta+n_node_eq))),
								(part_size*(n_node_theta+n_node_eq))*sizeof(data_t_memory));
		}
		#ifdef rem_partition
		memcpy(x_in_in_int.vec_rem,(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4+n_states+(PAR*part_size*(n_node_theta+n_node_eq))),
								(rem_partition*(n_node_theta+n_node_eq))*sizeof(data_t_memory));
		memcpy(x_in_in_int.vec_term,(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4+n_states+((PAR*part_size+rem_partition)*(n_node_theta+n_node_eq))),
									(n_term_theta+n_term_eq)*sizeof(data_t_memory));
		#else
		memcpy(x_in_in_int.vec_term,(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4+n_states+((PAR*part_size)*(n_node_theta+n_node_eq))),
										(n_term_theta+n_term_eq)*sizeof(data_t_memory));
		#endif
		//memcpy(x_in_in_int,(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4),X_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	foo_user_top: foo_user(	&block_in_int,
							out_block_in_int,
							&x_in_in_int,
							y_out_out_int);

	//y_out_out_int[0] += x_in_in_int.vec[0][0] +  x_in_in_int.vec[1][0];
	if(!(byte_y_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_y_out_out_offset/4),y_out_out_int,Y_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

}
