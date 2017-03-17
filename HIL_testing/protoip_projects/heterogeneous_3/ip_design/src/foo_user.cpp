/* 
* icl::protoip
* Author: asuardi <https://github.com/asuardi>
* Date: November - 2014
*/

#include "foo_data.h"
#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_structure_header.h"
#include "user_prototypes_header.h"



void foo_user(  data_t_minres_data_in minres_data_in_int[MINRES_DATA_IN_LENGTH],
		 	 	part_matrix *block_in_int,
				d_type_lanczos out_block_in_int[OUT_BLOCK_IN_LENGTH],
				data_t_x_in_in x_in_in_int[X_IN_IN_LENGTH],
				data_t_y_out_out y_out_out_int[Y_OUT_OUT_LENGTH])
{

	minres_HW(block_in_int, out_block_in_int, x_in_in_int, y_out_out_int, minres_data_in_int);

}
