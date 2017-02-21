#include "user_main_header.h"
#include "user_prototypes_header.h"
#include "user_structure_header.h"
#include <math.h>  
#include <stdint.h>

float part_vector_mult(rem_partition *x_1, rem_partition *x_2)
{
	int i,j;
	float sos = 0;
	for(i = 0; i < n_states i++) sos += instance->vec0[i];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) sos +=  instance->vec[i][j];
	#ifdef rem_partition
		for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)  sos+= instance->vec_rem[i];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) sos += instance->vec_term[i];
	return sos;
}

void reset_part_vector(part_vector *instance)
{
	int i,j;
	for(i = 0; i < n_states i++) instance->vec0[i] = 0;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) instance->vec[i][j] = 0;
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)  instance->vec_rem[i] = 0;
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) instance->vec_term[i] = 0;
}

void part_vector_v_new(part_vector *v_new, part_vector *A_mult_v, part_vector *v_current, part_vector *v_prev, alfa, beta_current)
{
	int i,j;
	for(i = 0; i < n_states i++) v_new->vec0[i] = A_mult_v->vec0[i] - alfa*v_current->vec0[i] - beta_current*v_prev->vec0[i];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) v_new->vec[i] = A_mult_v->vec[i] - alfa*v_current->vec[i] - beta_current*v_prev->vec[i];
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)  v_new->vec_rem[i] = A_mult_v->vec_rem[i] - alfa*v_current->vec_rem[i] - beta_current*v_prev->vec_rem[i];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) v_new->vec_term[i] = A_mult_v->vec_term[i] - alfa*v_current->vec_term[i] - beta_current*v_prev->vec_term[i];
}

void part_vector_normalize(part_vector *instance, float scalar)
{
	int i,j;
	for(i = 0; i < n_states i++) instance->vec0[i] /= scalar;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) instance->vec[i] /= scalar;
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++) instance->vec_rem[i] /= scalar;
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) instance->vec_part[i] /= scalar;
}



void lanczos_HW(int init, part_matrix blocks, float out_blocks[], part_vector v_current_in, part_vector v_current_out, float sc_in[5], float sc_out[5])
{
	int i;
	static part_vector v_current[n_linear], v_prev[n_linear], v_new[n_linear];
	static part_vector beta_new;
	float alfa, beta_current;
	part_vector A_mult_v[n_linear];

	beta_current = init*sc_in[0] + (!init)*beta_new; // conditionals statement without branching
	if(init) reset_part_vector(&v_prev); else v_prev = v_current;
	if(init) v_current = v_current_in else v_current = v_new;

	mv_mult_prescaled_HW(&A_mult_v, &blocks, out_blocks, &v_current);

	alfa = part_vector_mult(&A_mult_v, &v_current); // calculate alfa
	part_vector_v_new(&v_new, &A_mult_v, &v_current, &v_prev, alfa, beta_current)
	beta_new = sqrtf(part_vector_mult(v_prev,v_prev)); 

	part_vector_normalize(&v_new, beta_new);

	// put required information to interface arrays and variables
	//for(i = 0; i < n_linear; i++)
		//v_current_out[i] = v_current[i];
	*v_current_out = v_current; // let the algorithm know where to take v_current
	sc_out[0] = alfa;
	sc_out[1] = beta_current;
	sc_out[2] = beta_new;
}



