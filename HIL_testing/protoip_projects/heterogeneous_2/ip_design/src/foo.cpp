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
				data_t_block_in block_in_int[BLOCK_IN_LENGTH],
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

	#ifndef __SYNTHESIS__
	//Any system calls which manage memory allocation within the system, for example malloc(), alloc() and free(), must be removed from the design code prior to synthesis. 

	data_t_interface_init_in *init_in;
	init_in = (data_t_interface_init_in *)malloc(INIT_IN_LENGTH*sizeof(data_t_interface_init_in));
	data_t_interface_sc_in_in *sc_in_in;
	sc_in_in = (data_t_interface_sc_in_in *)malloc(SC_IN_IN_LENGTH*sizeof(data_t_interface_sc_in_in));
	data_t_interface_block_in *block_in;
	block_in = (data_t_interface_block_in *)malloc(BLOCK_IN_LENGTH*sizeof(data_t_interface_block_in));
	data_t_interface_out_block_in *out_block_in;
	out_block_in = (data_t_interface_out_block_in *)malloc(OUT_BLOCK_IN_LENGTH*sizeof(data_t_interface_out_block_in));
	data_t_interface_v_in_in *v_in_in;
	v_in_in = (data_t_interface_v_in_in *)malloc(V_IN_IN_LENGTH*sizeof(data_t_interface_v_in_in));
	data_t_interface_v_out_out *v_out_out;
	v_out_out = (data_t_interface_v_out_out *)malloc(V_OUT_OUT_LENGTH*sizeof(data_t_interface_v_out_out));
	data_t_interface_sc_out_out *sc_out_out;
	sc_out_out = (data_t_interface_sc_out_out *)malloc(SC_OUT_OUT_LENGTH*sizeof(data_t_interface_sc_out_out));

	data_t_init_in *init_in_int;
	init_in_int = (data_t_init_in *)malloc(INIT_IN_LENGTH*sizeof (data_t_init_in));
	data_t_sc_in_in *sc_in_in_int;
	sc_in_in_int = (data_t_sc_in_in *)malloc(SC_IN_IN_LENGTH*sizeof (data_t_sc_in_in));
	data_t_block_in *block_in_int;
	block_in_int = (data_t_block_in *)malloc(BLOCK_IN_LENGTH*sizeof (data_t_block_in));
	data_t_out_block_in *out_block_in_int;
	out_block_in_int = (data_t_out_block_in *)malloc(OUT_BLOCK_IN_LENGTH*sizeof (data_t_out_block_in));
	data_t_v_in_in *v_in_in_int;
	v_in_in_int = (data_t_v_in_in *)malloc(V_IN_IN_LENGTH*sizeof (data_t_v_in_in));
	data_t_v_out_out *v_out_out_int;
	v_out_out_int = (data_t_v_out_out *)malloc(V_OUT_OUT_LENGTH*sizeof (data_t_v_out_out));
	data_t_sc_out_out *sc_out_out_int;
	sc_out_out_int = (data_t_sc_out_out *)malloc(SC_OUT_OUT_LENGTH*sizeof (data_t_sc_out_out));

	#else
	//for synthesis

	data_t_interface_init_in  init_in[INIT_IN_LENGTH];
	data_t_interface_sc_in_in  sc_in_in[SC_IN_IN_LENGTH];
	data_t_interface_block_in  block_in[BLOCK_IN_LENGTH];
	data_t_interface_out_block_in  out_block_in[OUT_BLOCK_IN_LENGTH];
	data_t_interface_v_in_in  v_in_in[V_IN_IN_LENGTH];
	data_t_interface_v_out_out  v_out_out[V_OUT_OUT_LENGTH];
	data_t_interface_sc_out_out  sc_out_out[SC_OUT_OUT_LENGTH];

	static data_t_init_in  init_in_int[INIT_IN_LENGTH];
	static data_t_sc_in_in  sc_in_in_int[SC_IN_IN_LENGTH];
	static data_t_block_in  block_in_int[BLOCK_IN_LENGTH];
	static data_t_out_block_in  out_block_in_int[OUT_BLOCK_IN_LENGTH];
	static data_t_v_in_in  v_in_in_int[V_IN_IN_LENGTH];
	data_t_v_out_out  v_out_out_int[V_OUT_OUT_LENGTH];
	data_t_sc_out_out  sc_out_out_int[SC_OUT_OUT_LENGTH];

	#endif

	#if FLOAT_FIX_INIT_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_init_in_offset & (1<<31)))
	{
		memcpy(init_in,(const data_t_memory*)(memory_inout+byte_init_in_offset/4),INIT_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_init:for (int i=0; i< INIT_IN_LENGTH; i++)
			init_in_int[i]=(data_t_init_in)init_in[i];

	}
	

	#elif FLOAT_FIX_INIT_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_init_in_offset & (1<<31)))
	{
		memcpy(init_in_int,(const data_t_memory*)(memory_inout+byte_init_in_offset/4),INIT_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_SC_IN_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_sc_in_in_offset & (1<<31)))
	{
		memcpy(sc_in_in,(const data_t_memory*)(memory_inout+byte_sc_in_in_offset/4),SC_IN_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_sc_in:for (int i=0; i< SC_IN_IN_LENGTH; i++)
			sc_in_in_int[i]=(data_t_sc_in_in)sc_in_in[i];

	}
	

	#elif FLOAT_FIX_SC_IN_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_sc_in_in_offset & (1<<31)))
	{
		memcpy(sc_in_in_int,(const data_t_memory*)(memory_inout+byte_sc_in_in_offset/4),SC_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_BLOCK_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_block_in_offset & (1<<31)))
	{
		memcpy(block_in,(const data_t_memory*)(memory_inout+byte_block_in_offset/4),BLOCK_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_block:for (int i=0; i< BLOCK_IN_LENGTH; i++)
			block_in_int[i]=(data_t_block_in)block_in[i];

	}
	

	#elif FLOAT_FIX_BLOCK_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_block_in_offset & (1<<31)))
	{
		memcpy(block_in_int,(const data_t_memory*)(memory_inout+byte_block_in_offset/4),BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_OUT_BLOCK_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_out_block_in_offset & (1<<31)))
	{
		memcpy(out_block_in,(const data_t_memory*)(memory_inout+byte_out_block_in_offset/4),OUT_BLOCK_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_out_block:for (int i=0; i< OUT_BLOCK_IN_LENGTH; i++)
			out_block_in_int[i]=(data_t_out_block_in)out_block_in[i];

	}
	

	#elif FLOAT_FIX_OUT_BLOCK_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_out_block_in_offset & (1<<31)))
	{
		memcpy(out_block_in_int,(const data_t_memory*)(memory_inout+byte_out_block_in_offset/4),OUT_BLOCK_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_V_IN_IN == 1
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_v_in_in_offset & (1<<31)))
	{
		memcpy(v_in_in,(const data_t_memory*)(memory_inout+byte_v_in_in_offset/4),V_IN_IN_LENGTH*sizeof(data_t_memory));

    	//Initialisation: cast to the precision used for the algorithm
		input_cast_loop_v_in:for (int i=0; i< V_IN_IN_LENGTH; i++)
			v_in_in_int[i]=(data_t_v_in_in)v_in_in[i];

	}
	

	#elif FLOAT_FIX_V_IN_IN == 0
	///////////////////////////////////////
	//load input vectors from memory (DDR)

	if(!(byte_v_in_in_offset & (1<<31)))
	{
		memcpy(v_in_in_int,(const data_t_memory*)(memory_inout+byte_v_in_in_offset/4),V_IN_IN_LENGTH*sizeof(data_t_memory));
	}

	#endif



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
							block_in_int,
							out_block_in_int,
							v_in_in_int,
							v_out_out_int,
							sc_out_out_int);


	#if FLOAT_FIX_V_OUT_OUT == 1
	///////////////////////////////////////
	//store output vectors to memory (DDR)

	if(!(byte_v_out_out_offset & (1<<31)))
	{
		output_cast_loop_v_out: for(int i = 0; i <  V_OUT_OUT_LENGTH; i++)
			v_out_out[i]=(data_t_interface_v_out_out)v_out_out_int[i];

		//write results vector y_out to DDR
		memcpy((data_t_memory *)(memory_inout+byte_v_out_out_offset/4),v_out_out,V_OUT_OUT_LENGTH*sizeof(data_t_memory));

	}
	#elif FLOAT_FIX_V_OUT_OUT == 0
	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_v_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_v_out_out_offset/4),v_out_out_int,V_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

	#endif


	#if FLOAT_FIX_SC_OUT_OUT == 1
	///////////////////////////////////////
	//store output vectors to memory (DDR)

	if(!(byte_sc_out_out_offset & (1<<31)))
	{
		output_cast_loop_sc_out: for(int i = 0; i <  SC_OUT_OUT_LENGTH; i++)
			sc_out_out[i]=(data_t_interface_sc_out_out)sc_out_out_int[i];

		//write results vector y_out to DDR
		memcpy((data_t_memory *)(memory_inout+byte_sc_out_out_offset/4),sc_out_out,SC_OUT_OUT_LENGTH*sizeof(data_t_memory));

	}
	#elif FLOAT_FIX_SC_OUT_OUT == 0
	///////////////////////////////////////
	//write results vector y_out to DDR
	if(!(byte_sc_out_out_offset & (1<<31)))
	{
		memcpy((data_t_memory *)(memory_inout+byte_sc_out_out_offset/4),sc_out_out_int,SC_OUT_OUT_LENGTH*sizeof(data_t_memory));
	}

	#endif




}
