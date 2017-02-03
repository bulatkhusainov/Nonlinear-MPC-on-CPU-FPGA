/* 
* icl::protoip
* Authors: asuardi <https://github.com/asuardi>, bulatkhusainov <https://github.com/bulatkhusainov>
* Date: November - 2014
*/


#ifndef FOO_FUNCTION_WRAPPED
#define FOO_FUNCTION_WRAPPED
#include "FPGAserver.h"
#include "xfoo.h"
#include <stdio.h>
#include <stdint.h>
#include <math.h>
//functions for sending data from PS to DDR
void send_block_in(float* block_in);
void send_x_in_in(float* x_in_in);

//function for calling foo_user IP
void start_foo(uint32_t block_in_required,uint32_t x_in_in_required,uint32_t y_out_out_required);

//function for checking foo_user IP
uint32_t finished_foo(void);

//functions for receiving data from DDR to PS
void receive_y_out_out(float* y_out_out);
#endif
