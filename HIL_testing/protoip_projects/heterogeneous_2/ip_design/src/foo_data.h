/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include <vector>
#include <iostream>
#include <stdio.h>
#include "math.h"
#include "ap_fixed.h"
#include <stdint.h>
#include <cstdlib>
#include <cstring>
#include <stdio.h>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <hls_math.h>


// Define FLOAT_FIX_VECTOR_NAME=1 to enable  fixed-point (up to 32 bits word length) arithmetic precision or 
// FLOAT_FIX_VECTOR_NAME=0 to enable floating-point single arithmetic precision.
#define FLOAT_FIX_INIT_IN 0
#define FLOAT_FIX_SC_IN_IN 0
#define FLOAT_FIX_BLOCK_IN 0
#define FLOAT_FIX_OUT_BLOCK_IN 0
#define FLOAT_FIX_V_IN_IN 0
#define FLOAT_FIX_V_OUT_OUT 0
#define FLOAT_FIX_SC_OUT_OUT 0

//Input vectors INTEGERLENGTH:
#define INIT_IN_INTEGERLENGTH 0
#define SC_IN_IN_INTEGERLENGTH 0
#define BLOCK_IN_INTEGERLENGTH 0
#define OUT_BLOCK_IN_INTEGERLENGTH 0
#define V_IN_IN_INTEGERLENGTH 0
//Output vectors INTEGERLENGTH:
#define V_OUT_OUT_INTEGERLENGTH 0
#define SC_OUT_OUT_INTEGERLENGTH 0


//Input vectors FRACTIONLENGTH:
#define INIT_IN_FRACTIONLENGTH 0
#define SC_IN_IN_FRACTIONLENGTH 0
#define BLOCK_IN_FRACTIONLENGTH 0
#define OUT_BLOCK_IN_FRACTIONLENGTH 0
#define V_IN_IN_FRACTIONLENGTH 0
//Output vectors FRACTIONLENGTH:
#define V_OUT_OUT_FRACTIONLENGTH 0
#define SC_OUT_OUT_FRACTIONLENGTH 0


//Input vectors size:
#define INIT_IN_LENGTH 3
#define SC_IN_IN_LENGTH 5
#define BLOCK_IN_LENGTH 849
#define OUT_BLOCK_IN_LENGTH 66
#define V_IN_IN_LENGTH 414
//Output vectors size:
#define V_OUT_OUT_LENGTH 414
#define SC_OUT_OUT_LENGTH 5




typedef float data_t_memory;


#if FLOAT_FIX_INIT_IN == 1
	typedef ap_fixed<INIT_IN_INTEGERLENGTH+INIT_IN_FRACTIONLENGTH,INIT_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_init_in;
	typedef ap_fixed<32,32-INIT_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_init_in;
#endif
#if FLOAT_FIX_SC_IN_IN == 1
	typedef ap_fixed<SC_IN_IN_INTEGERLENGTH+SC_IN_IN_FRACTIONLENGTH,SC_IN_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_sc_in_in;
	typedef ap_fixed<32,32-SC_IN_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_sc_in_in;
#endif
#if FLOAT_FIX_BLOCK_IN == 1
	typedef ap_fixed<BLOCK_IN_INTEGERLENGTH+BLOCK_IN_FRACTIONLENGTH,BLOCK_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_block_in;
	typedef ap_fixed<32,32-BLOCK_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_block_in;
#endif
#if FLOAT_FIX_OUT_BLOCK_IN == 1
	typedef ap_fixed<OUT_BLOCK_IN_INTEGERLENGTH+OUT_BLOCK_IN_FRACTIONLENGTH,OUT_BLOCK_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_out_block_in;
	typedef ap_fixed<32,32-OUT_BLOCK_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_out_block_in;
#endif
#if FLOAT_FIX_V_IN_IN == 1
	typedef ap_fixed<V_IN_IN_INTEGERLENGTH+V_IN_IN_FRACTIONLENGTH,V_IN_IN_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_v_in_in;
	typedef ap_fixed<32,32-V_IN_IN_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_v_in_in;
#endif
#if FLOAT_FIX_INIT_IN == 0
	typedef float data_t_init_in;
	typedef float data_t_interface_init_in;
#endif
#if FLOAT_FIX_SC_IN_IN == 0
	typedef float data_t_sc_in_in;
	typedef float data_t_interface_sc_in_in;
#endif
#if FLOAT_FIX_BLOCK_IN == 0
	typedef float data_t_block_in;
	typedef float data_t_interface_block_in;
#endif
#if FLOAT_FIX_OUT_BLOCK_IN == 0
	typedef float data_t_out_block_in;
	typedef float data_t_interface_out_block_in;
#endif
#if FLOAT_FIX_V_IN_IN == 0
	typedef float data_t_v_in_in;
	typedef float data_t_interface_v_in_in;
#endif
#if FLOAT_FIX_V_OUT_OUT == 1 
	typedef ap_fixed<V_OUT_OUT_INTEGERLENGTH+V_OUT_OUT_FRACTIONLENGTH,V_OUT_OUT_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_v_out_out;
	typedef ap_fixed<32,32-V_OUT_OUT_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_v_out_out;
#endif
#if FLOAT_FIX_SC_OUT_OUT == 1 
	typedef ap_fixed<SC_OUT_OUT_INTEGERLENGTH+SC_OUT_OUT_FRACTIONLENGTH,SC_OUT_OUT_INTEGERLENGTH,AP_TRN_ZERO,AP_SAT> data_t_sc_out_out;
	typedef ap_fixed<32,32-SC_OUT_OUT_FRACTIONLENGTH,AP_TRN_ZERO,AP_SAT> data_t_interface_sc_out_out;
#endif
#if FLOAT_FIX_V_OUT_OUT == 0 
	typedef float data_t_v_out_out;
	typedef float data_t_interface_v_out_out;
#endif
#if FLOAT_FIX_SC_OUT_OUT == 0 
	typedef float data_t_sc_out_out;
	typedef float data_t_interface_sc_out_out;
#endif
