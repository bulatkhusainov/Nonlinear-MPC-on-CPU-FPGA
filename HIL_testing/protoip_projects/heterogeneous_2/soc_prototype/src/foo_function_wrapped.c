/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_function_wrapped.h"

typedef uint32_t           Xint32;

XFoo xcore;

//functions for sending data from PS to DDR
void send_init_in(float* init_in)
{
	Xint32 *init_in_ptr_ddr = (Xint32 *)init_IN_DEFINED_MEM_ADDRESS;
	int32_t inputvec_fix[INIT_IN_VECTOR_LENGTH];
	int i;

	//write init_in to DDR
	if (FLOAT_FIX_INIT_IN == 1)
	{
		for(i = 0; i < INIT_IN_VECTOR_LENGTH; i++) // convert floating point to fixed
		{
			inputvec_fix[i] = (int32_t)(init_in[i]*pow(2, INIT_IN_FRACTIONLENGTH));
		}
		memcpy(init_in_ptr_ddr, inputvec_fix, INIT_IN_VECTOR_LENGTH*4);
	}
	else { //floating point
		memcpy(init_in_ptr_ddr, init_in, INIT_IN_VECTOR_LENGTH*4);
	}
	Xil_DCacheFlushRange((uint)init_in_ptr_ddr, INIT_IN_VECTOR_LENGTH*4);
}
void send_sc_in_in(float* sc_in_in)
{
	Xint32 *sc_in_in_ptr_ddr = (Xint32 *)sc_in_IN_DEFINED_MEM_ADDRESS;
	int32_t inputvec_fix[SC_IN_IN_VECTOR_LENGTH];
	int i;

	//write sc_in_in to DDR
	if (FLOAT_FIX_SC_IN_IN == 1)
	{
		for(i = 0; i < SC_IN_IN_VECTOR_LENGTH; i++) // convert floating point to fixed
		{
			inputvec_fix[i] = (int32_t)(sc_in_in[i]*pow(2, SC_IN_IN_FRACTIONLENGTH));
		}
		memcpy(sc_in_in_ptr_ddr, inputvec_fix, SC_IN_IN_VECTOR_LENGTH*4);
	}
	else { //floating point
		memcpy(sc_in_in_ptr_ddr, sc_in_in, SC_IN_IN_VECTOR_LENGTH*4);
	}
	Xil_DCacheFlushRange((uint)sc_in_in_ptr_ddr, SC_IN_IN_VECTOR_LENGTH*4);
}
void send_block_in(float* block_in)
{
	Xint32 *block_in_ptr_ddr = (Xint32 *)block_IN_DEFINED_MEM_ADDRESS;
	int32_t inputvec_fix[BLOCK_IN_VECTOR_LENGTH];
	int i;

	//write block_in to DDR
	if (FLOAT_FIX_BLOCK_IN == 1)
	{
		for(i = 0; i < BLOCK_IN_VECTOR_LENGTH; i++) // convert floating point to fixed
		{
			inputvec_fix[i] = (int32_t)(block_in[i]*pow(2, BLOCK_IN_FRACTIONLENGTH));
		}
		memcpy(block_in_ptr_ddr, inputvec_fix, BLOCK_IN_VECTOR_LENGTH*4);
	}
	else { //floating point
		memcpy(block_in_ptr_ddr, block_in, BLOCK_IN_VECTOR_LENGTH*4);
	}
	Xil_DCacheFlushRange((uint)block_in_ptr_ddr, BLOCK_IN_VECTOR_LENGTH*4);
}
void send_out_block_in(float* out_block_in)
{
	Xint32 *out_block_in_ptr_ddr = (Xint32 *)out_block_IN_DEFINED_MEM_ADDRESS;
	int32_t inputvec_fix[OUT_BLOCK_IN_VECTOR_LENGTH];
	int i;

	//write out_block_in to DDR
	if (FLOAT_FIX_OUT_BLOCK_IN == 1)
	{
		for(i = 0; i < OUT_BLOCK_IN_VECTOR_LENGTH; i++) // convert floating point to fixed
		{
			inputvec_fix[i] = (int32_t)(out_block_in[i]*pow(2, OUT_BLOCK_IN_FRACTIONLENGTH));
		}
		memcpy(out_block_in_ptr_ddr, inputvec_fix, OUT_BLOCK_IN_VECTOR_LENGTH*4);
	}
	else { //floating point
		memcpy(out_block_in_ptr_ddr, out_block_in, OUT_BLOCK_IN_VECTOR_LENGTH*4);
	}
	Xil_DCacheFlushRange((uint)out_block_in_ptr_ddr, OUT_BLOCK_IN_VECTOR_LENGTH*4);
}
void send_v_in_in(float* v_in_in)
{
	Xint32 *v_in_in_ptr_ddr = (Xint32 *)v_in_IN_DEFINED_MEM_ADDRESS;
	int32_t inputvec_fix[V_IN_IN_VECTOR_LENGTH];
	int i;

	//write v_in_in to DDR
	if (FLOAT_FIX_V_IN_IN == 1)
	{
		for(i = 0; i < V_IN_IN_VECTOR_LENGTH; i++) // convert floating point to fixed
		{
			inputvec_fix[i] = (int32_t)(v_in_in[i]*pow(2, V_IN_IN_FRACTIONLENGTH));
		}
		memcpy(v_in_in_ptr_ddr, inputvec_fix, V_IN_IN_VECTOR_LENGTH*4);
	}
	else { //floating point
		memcpy(v_in_in_ptr_ddr, v_in_in, V_IN_IN_VECTOR_LENGTH*4);
	}
	Xil_DCacheFlushRange((uint)v_in_in_ptr_ddr, V_IN_IN_VECTOR_LENGTH*4);
}

//function for calling foo_user IP
void start_foo(uint32_t init_in_required,uint32_t sc_in_in_required,uint32_t block_in_required,uint32_t out_block_in_required,uint32_t v_in_in_required,uint32_t v_out_out_required,uint32_t sc_out_out_required)
{
	xcore.Bus_a_BaseAddress = 0x43c00000;
	xcore.IsReady = XIL_COMPONENT_IS_READY;

		if(init_in_required)
		{
			XFoo_Set_byte_init_in_offset(&xcore,init_IN_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_init_in_offset(&xcore,(1<<31));
		}
		if(sc_in_in_required)
		{
			XFoo_Set_byte_sc_in_in_offset(&xcore,sc_in_IN_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_sc_in_in_offset(&xcore,(1<<31));
		}
		if(block_in_required)
		{
			XFoo_Set_byte_block_in_offset(&xcore,block_IN_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_block_in_offset(&xcore,(1<<31));
		}
		if(out_block_in_required)
		{
			XFoo_Set_byte_out_block_in_offset(&xcore,out_block_IN_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_out_block_in_offset(&xcore,(1<<31));
		}
		if(v_in_in_required)
		{
			XFoo_Set_byte_v_in_in_offset(&xcore,v_in_IN_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_v_in_in_offset(&xcore,(1<<31));
		}
		if(v_out_out_required)
		{
			XFoo_Set_byte_v_out_out_offset(&xcore,v_out_OUT_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_v_out_out_offset(&xcore,(1<<31));
		}
		if(sc_out_out_required)
		{
			XFoo_Set_byte_sc_out_out_offset(&xcore,sc_out_OUT_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_sc_out_out_offset(&xcore,(1<<31));
		}
		XFoo_Start(&xcore);
}

//function for checking foo_user IP
uint32_t finished_foo(void)
{
	return XFoo_IsIdle(&xcore);
}
//functions for receiving data from DDR to PS
void receive_v_out_out(float* v_out_out)
{
	Xint32 *v_out_out_ptr_ddr = (Xint32 *)v_out_OUT_DEFINED_MEM_ADDRESS;
	int32_t outputvec_fix[V_OUT_OUT_VECTOR_LENGTH];
	int i;
	Xil_DCacheInvalidateRange((uint)v_out_out_ptr_ddr, V_OUT_OUT_VECTOR_LENGTH*4);


	//read v_out_out from DDR
	if (FLOAT_FIX_V_OUT_OUT == 1) { //fixed point
		memcpy(outputvec_fix,v_out_out_ptr_ddr,  V_OUT_OUT_VECTOR_LENGTH*4);
		for(i = 0; i < V_OUT_OUT_VECTOR_LENGTH; i++)
		{
			v_out_out[i] = ((float)outputvec_fix[i]/pow(2, V_OUT_OUT_FRACTIONLENGTH));
		}
	} else { //floating point
		memcpy(v_out_out,v_out_out_ptr_ddr,  V_OUT_OUT_VECTOR_LENGTH*4);
	}
}
void receive_sc_out_out(float* sc_out_out)
{
	Xint32 *sc_out_out_ptr_ddr = (Xint32 *)sc_out_OUT_DEFINED_MEM_ADDRESS;
	int32_t outputvec_fix[SC_OUT_OUT_VECTOR_LENGTH];
	int i;
	Xil_DCacheInvalidateRange((uint)sc_out_out_ptr_ddr, SC_OUT_OUT_VECTOR_LENGTH*4);

	//read sc_out_out from DDR
	if (FLOAT_FIX_SC_OUT_OUT == 1) { //fixed point
		memcpy(outputvec_fix,sc_out_out_ptr_ddr,  SC_OUT_OUT_VECTOR_LENGTH*4);
		for(i = 0; i < SC_OUT_OUT_VECTOR_LENGTH; i++)
		{
			sc_out_out[i] = ((float)outputvec_fix[i]/pow(2, SC_OUT_OUT_FRACTIONLENGTH));
		}
	} else { //floating point
		memcpy(sc_out_out,sc_out_out_ptr_ddr,  SC_OUT_OUT_VECTOR_LENGTH*4);
	}
}
//--------------------------------------------------------------------
