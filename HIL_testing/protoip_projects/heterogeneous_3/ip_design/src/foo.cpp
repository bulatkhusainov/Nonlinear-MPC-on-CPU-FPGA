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


void foo_user(  part_matrix *block_in_int,
				d_type_lanczos out_block_in_int[OUT_BLOCK_IN_LENGTH],
				data_t_x_in_in x_in_in_int[X_IN_IN_LENGTH],
				data_t_y_out_out y_out_out_int[Y_OUT_OUT_LENGTH]);


void foo	(
				uint32_t byte_block_in_offset,
				uint32_t byte_out_block_in_offset,
				uint32_t byte_x_in_in_offset,
				uint32_t byte_y_out_out_offset,
				volatile data_t_memory *memory_inout)
{

	
	static part_matrix  block_in_int;
#pragma HLS ARRAY_PARTITION variable=block_in_int.mat complete dim=1
	static d_type_lanczos  out_block_in_int[OUT_BLOCK_IN_LENGTH];
	static data_t_x_in_in  x_in_in_int[X_IN_IN_LENGTH];
	data_t_y_out_out  y_out_out_int[Y_OUT_OUT_LENGTH];

	///////////////////////////////////////
	//load input vectors from memory (DDR)
	if(!(byte_block_in_offset & (1<<31)))
	{
		interface_loop_block:for(int i = 0; i < PAR; i++)
		{
			float tmp_cached[PAR*part_size*nnz_block_tril];
			#ifdef FLOATING_lacnzos
			// this is for floating point
				//#pragma HLS PIPELINE
				memcpy(&block_in_int.mat[i][0],(const data_t_memory*)(memory_inout+byte_block_in_offset/4+(i*part_size)*nnz_block_tril),
					(part_size*nnz_block_tril)*sizeof(data_t_memory));
			#else
				// this first fixed point implementation
				memcpy(tmp_cached,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+(i*part_size)*nnz_block_tril),
								(part_size*nnz_block_tril)*sizeof(data_t_memory));

				for(int j = 0; j < part_size*nnz_block_tril; j++)
					block_in_int.mat[i][j] = (d_type_lanczos)tmp_cached[j];
			#endif


		}

		#ifdef rem_partition
		memcpy(block_in_int.mat_rem,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+(PAR*part_size*nnz_block_tril)),
									(rem_partition*nnz_block_tril)*sizeof(data_t_memory));
		memcpy(block_in_int.mat_term,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+((PAR*part_size+rem_partition)*nnz_block_tril)),
														nnz_term_block_tril*sizeof(data_t_memory));
		#else
			#ifdef FLOATING_lacnzos
				memcpy(block_in_int.mat_term,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+((PAR*part_size)*nnz_block_tril)),
						nnz_term_block_tril*sizeof(data_t_memory));
			#else
					memcpy(tmp_cached,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+((PAR*part_size)*nnz_block_tril)),
											nnz_term_block_tril*sizeof(data_t_memory));
					for(int j = 0; j < nnz_term_block_tril; j++)
						block_in_int.mat_term[j] = (d_type_lanczos)tmp_cached[j];
			#endif
		#endif
		//memcpy(block_in_int,(const data_t_memory*)(memory_inout+byte_block_in_offset/4),BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_out_block_in_offset & (1<<31)))
	{
		#ifdef FLOATING_lacnzos
			memcpy(out_block_in_int,(const data_t_memory*)(memory_inout+byte_out_block_in_offset/4),OUT_BLOCK_IN_LENGTH*sizeof(data_t_memory));
		#else
			float tmp_cached2[OUT_BLOCK_IN_LENGTH];
			memcpy(tmp_cached2,(const data_t_memory*)(memory_inout+byte_out_block_in_offset/4),OUT_BLOCK_IN_LENGTH*sizeof(data_t_memory));
				for(int j = 0; j < OUT_BLOCK_IN_LENGTH; j++)
					out_block_in_int[j] = (d_type_lanczos)tmp_cached2[j];

		#endif
	}

	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_x_in_in_offset & (1<<31)))
	{
		memcpy(x_in_in_int,(const data_t_memory*)(memory_inout+byte_x_in_in_offset/4),X_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	//Input vectors are:
	//block_in_int[BLOCK_IN_LENGTH] -> data type is data_t_block_in
	//out_block_in_int[OUT_BLOCK_IN_LENGTH] -> data type is data_t_out_block_in
	//x_in_in_int[X_IN_IN_LENGTH] -> data type is data_t_x_in_in
	//Output vectors are:
	//y_out_out_int[Y_OUT_OUT_LENGTH] -> data type is data_t_y_out_out
	foo_user_top: foo_user(	&block_in_int,
							out_block_in_int,
							x_in_in_int,
							y_out_out_int);

	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_y_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_y_out_out_offset/4),y_out_out_int,Y_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

}
