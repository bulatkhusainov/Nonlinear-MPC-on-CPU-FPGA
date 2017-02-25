#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_prototypes_header.h"
#include "user_structure_header.h"
#include <math.h>  
#include <stdint.h>

float part_vector_mult(part_vector *x_1, part_vector *x_2)
{
	int i,j;
	float sos = 0;
	for(i = 0; i < n_states; i++) sos += (x_1->vec0[i] * x_2->vec0[i]);
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) sos +=  (x_1->vec[i][j] * x_2->vec[i][j]);
	#ifdef rem_partition
		for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)  sos+= (x_1->vec_rem[i] * x_2->vec_rem[i]);
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) sos += (x_1->vec_term[i] * x_2->vec_term[i]);
	return sos;
}
void reset_part_vector(part_vector *instance)
{
	int i,j;
	for(i = 0; i < n_states; i++) instance->vec0[i] = 0;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) instance->vec[i][j] = 0;
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)  instance->vec_rem[i] = 0;
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) instance->vec_term[i] = 0;
}

void part_vector_v_new(part_vector *v_new, part_vector *A_mult_v, part_vector *v_current, part_vector *v_prev, float alfa, float beta_current)
{
	int i,j;
	for(i = 0; i < n_states; i++) v_new->vec0[i] = A_mult_v->vec0[i] - alfa*v_current->vec0[i] - beta_current*v_prev->vec0[i];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) v_new->vec[i][j] = A_mult_v->vec[i][j] - alfa*v_current->vec[i][j] - beta_current*v_prev->vec[i][j];
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)  v_new->vec_rem[i] = A_mult_v->vec_rem[i] - alfa*v_current->vec_rem[i] - beta_current*v_prev->vec_rem[i];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) v_new->vec_term[i] = A_mult_v->vec_term[i] - alfa*v_current->vec_term[i] - beta_current*v_prev->vec_term[i];
}

void part_vector_normalize(part_vector *instance, float scalar)
{
	int i,j;
	for(i = 0; i < n_states; i++) instance->vec0[i] /= scalar;
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++) instance->vec[i][j] /= scalar;
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++) instance->vec_rem[i] /= scalar;
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++) instance->vec_term[i] /= scalar;
}


void copy_part_vector_to_vector(part_vector *instance, float *vector)
{
	int i,j,k; 
	k = 0;
	for(i = 0; i < n_states; i++, k++) vector[k] = instance->vec0[i];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++, k++) vector[k] = instance->vec[i][j];
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++, k++) vector[k] = instance->vec_rem[i];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++, k++) vector[k] = instance->vec_term[i];
}

void copy_vector_to_part_vector(float *vector, part_vector *instance)
{
	int i,j,k; 
	k = 0;
	for(i = 0; i < n_states; i++, k++) instance->vec0[i] = vector[k];
	for(i = 0; i < PAR; i++)
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++, k++) instance->vec[i][j] = vector[k];
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++, k++) instance->vec_rem[i] = vector[k];
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++, k++) instance->vec_term[i] = vector[k];
}

void lanczos_HW(int init, part_matrix *blocks, float out_blocks[], float v_current_in[n_linear], float v_current_out[n_linear], float sc_in[5], float sc_out[5])
{
	static part_vector v_current, v_prev, v_new;
	static float beta_new = 0;
	float alfa, beta_current;
	part_vector A_mult_v;

	beta_current = init*sc_in[0] + (!init)*beta_new; // conditionals statement without branching
	if(init) reset_part_vector(&v_prev); else v_prev = v_current;
	if(init) copy_vector_to_part_vector(v_current_in, &v_current); else v_current = v_new;

	mv_mult_prescaled_HW(&A_mult_v, blocks, out_blocks, &v_current);

	alfa = part_vector_mult(&A_mult_v, &v_current); // calculate alfa
	part_vector_v_new(&v_new, &A_mult_v, &v_current, &v_prev, alfa, beta_current);
	beta_new = sqrtf(part_vector_mult(&v_new,&v_new)); 

	part_vector_normalize(&v_new, beta_new);

	// put required information to interface arrays and variables
	copy_part_vector_to_vector(&v_current, v_current_out);
	sc_out[0] = alfa;
	sc_out[1] = beta_current;
	sc_out[2] = beta_new;
}