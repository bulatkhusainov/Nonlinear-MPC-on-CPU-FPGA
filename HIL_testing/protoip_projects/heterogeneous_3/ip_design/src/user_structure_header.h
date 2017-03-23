#ifndef STRUCT_HEADER
#define STRUCT_HEADER
#include "user_main_header.h"
#include "user_protoip_definer.h"

//#ifdef __SYNTHESIS__

	#ifdef FIXED_lacnzos
		#include "ap_fixed.h"
		typedef ap_fixed<55,55-45,AP_TRN,AP_SAT> d_type_lanczos;
	#else
		//typedef float d_type_lanczos;
	#endif
//#else
//	typedef float d_type_lanczos;
//#endif
//typedef float d_type_lanczos;

	

typedef struct part_vector_tag { 
	d_type_lanczos vec0[n_states]; 
	d_type_lanczos vec[PAR][part_size*(n_node_theta+n_node_eq)]; 
	#ifdef rem_partition
	d_type_lanczos vec_rem[rem_partition*(n_node_theta+n_node_eq)];;
	#endif
	d_type_lanczos vec_term[n_term_theta+n_term_eq]; 
} part_vector; 

typedef struct part_matrix_tag { 
	d_type_lanczos mat[PAR][part_size*nnz_block_tril]; 
	#ifdef rem_partition
	d_type_lanczos mat_rem[rem_partition*nnz_block_tril];
	#endif
	d_type_lanczos mat_term[nnz_term_block_tril]; 
} part_matrix; 

#endif
