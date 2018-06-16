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
#define FLOAT_FIX_BLOCK_IN 0
#define FLOAT_FIX_X_IN_IN 0
#define FLOAT_FIX_Y_OUT_OUT 0

//Input vectors INTEGERLENGTH:
#define BLOCK_IN_INTEGERLENGTH 0
#define X_IN_IN_INTEGERLENGTH 0
//Output vectors INTEGERLENGTH:
#define Y_OUT_OUT_INTEGERLENGTH 0


//Input vectors FRACTIONLENGTH:
#define BLOCK_IN_FRACTIONLENGTH 0
#define X_IN_IN_FRACTIONLENGTH 0
//Output vectors FRACTIONLENGTH:
#define Y_OUT_OUT_FRACTIONLENGTH 0


//Input vectors size:
#define BLOCK_IN_LENGTH 5
#define X_IN_IN_LENGTH 5
//Output vectors size:
#define Y_OUT_OUT_LENGTH 5




typedef float data_t_memory;


#if FLOAT_FIX_BLOCK_IN == 1
	typedef ap_fixed<BLOCK_IN_INTEGERLENGTH+BLOCK_IN_FRACTIONLENGTH,BLOCK_IN_INTEGERLENGTH,AP_TRN,AP_WRAP> data_t_block_in;
	typedef ap_fixed<32,32-BLOCK_IN_FRACTIONLENGTH,AP_TRN,AP_WRAP> data_t_interface_block_in;
#endif
#if FLOAT_FIX_X_IN_IN == 1
	typedef ap_fixed<X_IN_IN_INTEGERLENGTH+X_IN_IN_FRACTIONLENGTH,X_IN_IN_INTEGERLENGTH,AP_TRN,AP_WRAP> data_t_x_in_in;
	typedef ap_fixed<32,32-X_IN_IN_FRACTIONLENGTH,AP_TRN,AP_WRAP> data_t_interface_x_in_in;
#endif
#if FLOAT_FIX_BLOCK_IN == 0
	typedef float data_t_block_in;
	typedef float data_t_interface_block_in;
#endif
#if FLOAT_FIX_X_IN_IN == 0
	typedef float data_t_x_in_in;
	typedef float data_t_interface_x_in_in;
#endif
#if FLOAT_FIX_Y_OUT_OUT == 1 
	typedef ap_fixed<Y_OUT_OUT_INTEGERLENGTH+Y_OUT_OUT_FRACTIONLENGTH,Y_OUT_OUT_INTEGERLENGTH,AP_TRN,AP_WRAP> data_t_y_out_out;
	typedef ap_fixed<32,32-Y_OUT_OUT_FRACTIONLENGTH,AP_TRN,AP_WRAP> data_t_interface_y_out_out;
#endif
#if FLOAT_FIX_Y_OUT_OUT == 0 
	typedef float data_t_y_out_out;
	typedef float data_t_interface_y_out_out;
#endif
