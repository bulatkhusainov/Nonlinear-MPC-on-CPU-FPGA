/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_function_wrapped.h"

typedef uint32_t           Xint32;

XFoo xcore;

//functions for sending data from PS to DDR
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
void send_x_in_in(float* x_in_in)
{
	Xint32 *x_in_in_ptr_ddr = (Xint32 *)x_in_IN_DEFINED_MEM_ADDRESS;
	int32_t inputvec_fix[X_IN_IN_VECTOR_LENGTH];
	int i;

	//write x_in_in to DDR
	if (FLOAT_FIX_X_IN_IN == 1)
	{
		for(i = 0; i < X_IN_IN_VECTOR_LENGTH; i++) // convert floating point to fixed
		{
			inputvec_fix[i] = (int32_t)(x_in_in[i]*pow(2, X_IN_IN_FRACTIONLENGTH));
		}
		memcpy(x_in_in_ptr_ddr, inputvec_fix, X_IN_IN_VECTOR_LENGTH*4);
	}
	else { //floating point
		memcpy(x_in_in_ptr_ddr, x_in_in, X_IN_IN_VECTOR_LENGTH*4);
	}
	Xil_DCacheFlushRange((uint)x_in_in_ptr_ddr, X_IN_IN_VECTOR_LENGTH*4);
}

//function for calling foo_user IP
void start_foo(uint32_t block_in_required,uint32_t out_block_in_required,uint32_t x_in_in_required,uint32_t y_out_out_required)
{
	xcore.Bus_a_BaseAddress = 0x43c00000;
	xcore.IsReady = XIL_COMPONENT_IS_READY;

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
		if(x_in_in_required)
		{
			XFoo_Set_byte_x_in_in_offset(&xcore,x_in_IN_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_x_in_in_offset(&xcore,(1<<31));
		}
		if(y_out_out_required)
		{
			XFoo_Set_byte_y_out_out_offset(&xcore,y_out_OUT_DEFINED_MEM_ADDRESS);
		}
		else
		{
			XFoo_Set_byte_y_out_out_offset(&xcore,(1<<31));
		}
		XFoo_Start(&xcore);
}

//function for checking foo_user IP
uint32_t finished_foo(void)
{
	return XFoo_IsIdle(&xcore);
}
//functions for receiving data from DDR to PS
void receive_y_out_out(float* y_out_out)
{
	Xint32 *y_out_out_ptr_ddr = (Xint32 *)y_out_OUT_DEFINED_MEM_ADDRESS;
	int32_t outputvec_fix[Y_OUT_OUT_VECTOR_LENGTH];
	int i;
	Xil_DCacheInvalidateRange((uint)y_out_out_ptr_ddr, Y_OUT_OUT_VECTOR_LENGTH*4);


	//read y_out_out from DDR
	if (FLOAT_FIX_Y_OUT_OUT == 1) { //fixed point
		memcpy(outputvec_fix,y_out_out_ptr_ddr,  Y_OUT_OUT_VECTOR_LENGTH*4);
		for(i = 0; i < Y_OUT_OUT_VECTOR_LENGTH; i++)
		{
			y_out_out[i] = ((float)outputvec_fix[i]/pow(2, Y_OUT_OUT_FRACTIONLENGTH));
		}
	} else { //floating point
		memcpy(y_out_out,y_out_out_ptr_ddr,  Y_OUT_OUT_VECTOR_LENGTH*4);
	}
}
//--------------------------------------------------------------------
