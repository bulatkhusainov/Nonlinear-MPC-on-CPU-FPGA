/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/


#include "foo_data.h"


void foo_user(  data_t_block_in block_in_int[BLOCK_IN_LENGTH],
				data_t_x_in_in x_in_in_int[X_IN_IN_LENGTH],
				data_t_y_out_out y_out_out_int[Y_OUT_OUT_LENGTH])
{

	///////////////////////////////////////
	//ADD USER algorithm here below:
	//(this is an example)
	alg_0 : for(int i = 0; i <Y_OUT_OUT_LENGTH; i++)
	{
		y_out_out_int[i]=0;
		loop_block : for(int i_block = 0; i_block <BLOCK_IN_LENGTH; i_block++)
		{
			y_out_out_int[i]=y_out_out_int[i] + (data_t_y_out_out)block_in_int[i_block];
		}
		loop_x_in : for(int i_x_in = 0; i_x_in <X_IN_IN_LENGTH; i_x_in++)
		{
			y_out_out_int[i]=y_out_out_int[i] + (data_t_y_out_out)x_in_in_int[i_x_in];
		}
	}

}
