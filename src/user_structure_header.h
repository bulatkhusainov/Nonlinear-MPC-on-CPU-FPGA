#ifndef STRUCT_HEADER
#define STRUCT_HEADER

typedef struct part_vector_tag { 
	float vec0[n_states]; 
	float vec[PAR][part_size*(n_node_theta+n_node_eq)]; 
	float vec_term[n_term_theta+n_term_eq]; 
} part_vector; 

typedef struct part_matrix_tag { 
	float mat[PAR][part_size*nnz_block_tril]; 
	float mat_term[nnz_term_block_tril]; 
} part_matrix; 

#endif