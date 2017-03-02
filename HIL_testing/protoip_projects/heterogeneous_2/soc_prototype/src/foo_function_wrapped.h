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
void send_init_in(float* init_in);
void send_sc_in_in(float* sc_in_in);
void send_block_in(float* block_in);
void send_out_block_in(float* out_block_in);
void send_v_in_in(float* v_in_in);

//function for calling foo_user IP
void start_foo(uint32_t init_in_required,uint32_t sc_in_in_required,uint32_t block_in_required,uint32_t out_block_in_required,uint32_t v_in_in_required,uint32_t v_out_out_required,uint32_t sc_out_out_required);

//function for checking foo_user IP
uint32_t finished_foo(void);

//functions for receiving data from DDR to PS
void receive_v_out_out(float* v_out_out);
void receive_sc_out_out(float* sc_out_out);
#endif
