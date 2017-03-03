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

void foo_user(  data_t_init_in init_in_int[INIT_IN_LENGTH],
				data_t_sc_in_in sc_in_in_int[SC_IN_IN_LENGTH],
				part_matrix *block_in_int,
				data_t_out_block_in out_block_in_int[OUT_BLOCK_IN_LENGTH],
				data_t_v_in_in v_in_in_int[V_IN_IN_LENGTH],
				data_t_v_out_out v_out_out_int[V_OUT_OUT_LENGTH],
				data_t_sc_out_out sc_out_out_int[SC_OUT_OUT_LENGTH]);


void foo	(
				uint32_t byte_init_in_offset,
				uint32_t byte_sc_in_in_offset,
				uint32_t byte_block_in_offset,
				uint32_t byte_out_block_in_offset,
				uint32_t byte_v_in_in_offset,
				uint32_t byte_v_out_out_offset,
				uint32_t byte_sc_out_out_offset,
				volatile data_t_memory *memory_inout)
{


	static data_t_init_in  init_in_int[INIT_IN_LENGTH];
	static data_t_sc_in_in  sc_in_in_int[SC_IN_IN_LENGTH];
	static part_matrix  block_in_int;
#pragma HLS ARRAY_PARTITION variable=block_in_int.mat complete dim=1
	static data_t_out_block_in  out_block_in_int[OUT_BLOCK_IN_LENGTH];
	static data_t_v_in_in  v_in_in_int[V_IN_IN_LENGTH];
	data_t_v_out_out  v_out_out_int[V_OUT_OUT_LENGTH];
	data_t_sc_out_out  sc_out_out_int[SC_OUT_OUT_LENGTH];


	
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_init_in_offset & (1<<31)))
	{
		memcpy(init_in_int,(const data_t_memory*)(memory_inout+byte_init_in_offset/4),INIT_IN_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_sc_in_in_offset & (1<<31)))
	{
		memcpy(sc_in_in_int,(const data_t_memory*)(memory_inout+byte_sc_in_in_offset/4),SC_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_block_in_offset & (1<<31)))
	{
		interface_loop_block:for(int i = 0; i < PAR; i++)
		{
			#pragma HLS PIPELINE
			memcpy(&block_in_int.mat[i][0],(const data_t_memory*)(memory_inout+byte_block_in_offset/4+(i*part_size)*nnz_block_tril),
					(part_size*nnz_block_tril)*sizeof(data_t_memory));
		}
		#ifdef rem_partition
		memcpy(block_in_int.mat_rem,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+(PAR*part_size*nnz_block_tril)),
									(rem_partition*nnz_block_tril)*sizeof(data_t_memory));
		memcpy(block_in_int.mat_term,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+((PAR*part_size+rem_partition)*nnz_block_tril)),
														nnz_term_block_tril*sizeof(data_t_memory));
		#else
		memcpy(block_in_int.mat_term,(const data_t_memory*)(memory_inout+byte_block_in_offset/4+((PAR*part_size)*nnz_block_tril)),
											nnz_term_block_tril*sizeof(data_t_memory));
		#endif

		//memcpy(block_in_int,(const data_t_memory*)(memory_inout+byte_block_in_offset/4),BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}
	
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_out_block_in_offset & (1<<31)))
	{
		memcpy(out_block_in_int,(const data_t_memory*)(memory_inout+byte_out_block_in_offset/4),OUT_BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}


	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_v_in_in_offset & (1<<31)))
	{
		memcpy(v_in_in_int,(const data_t_memory*)(memory_inout+byte_v_in_in_offset/4),V_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//USER algorithm function (foo_user.cpp) call
	//Input vectors are:
	//init_in_int[INIT_IN_LENGTH] -> data type is data_t_init_in
	//sc_in_in_int[SC_IN_IN_LENGTH] -> data type is data_t_sc_in_in
	//block_in_int[BLOCK_IN_LENGTH] -> data type is data_t_block_in
	//out_block_in_int[OUT_BLOCK_IN_LENGTH] -> data type is data_t_out_block_in
	//v_in_in_int[V_IN_IN_LENGTH] -> data type is data_t_v_in_in
	//Output vectors are:
	//v_out_out_int[V_OUT_OUT_LENGTH] -> data type is data_t_v_out_out
	//sc_out_out_int[SC_OUT_OUT_LENGTH] -> data type is data_t_sc_out_out
	foo_user_top: foo_user(	init_in_int,
							sc_in_in_int,
							&block_in_int,
							out_block_in_int,
							v_in_in_int,
							v_out_out_int,
							sc_out_out_int);

	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_v_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_v_out_out_offset/4),v_out_out_int,V_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_sc_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_sc_out_out_offset/4),sc_out_out_int,SC_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

}
