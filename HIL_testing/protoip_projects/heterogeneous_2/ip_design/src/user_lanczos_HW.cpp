#include "user_protoip_definer.h"
#ifdef PROTOIP
#include "foo_data.h"
#endif
#include "user_main_header.h"
#include "user_prototypes_header.h"
#include "user_structure_header.h"
#include <math.h>  
#include <stdint.h>
#include "user_structure_header.h"
//#include "mex.h"

extern float debug_interface[n_linear];

d_type_lanczos part_vector_mult(part_vector *x_1, part_vector *x_2);
d_type_lanczos part_vector_mult_par(part_vector *x_1, part_vector *x_2);
void reset_part_vector(part_vector *instance);
d_type_lanczos part_vector_v_new(part_vector *v_new, part_vector *A_mult_v, part_vector *v_current, float v_current_out[n_linear], part_vector *v_prev, d_type_lanczos alfa, d_type_lanczos beta_current);
void part_vector_normalize_update(part_vector *v_new, part_vector *v_current, part_vector *v_prev, d_type_lanczos scalar);
//void copy_part_vector_to_vector(part_vector *instance, float *vector);
void copy_vector_to_part_vector(float *vector, part_vector *instance);

void lanczos_HW(int init, part_matrix *blocks, d_type_lanczos out_blocks[], float v_current_in[n_linear], float v_current_out[n_linear], float sc_in[5], float sc_out[5])
{
	static part_vector v_current, v_prev, v_new;
	#pragma HLS ARRAY_PARTITION variable=v_new.vec complete dim=1
	#pragma HLS ARRAY_PARTITION variable=v_prev.vec complete dim=1
	#pragma HLS ARRAY_PARTITION variable=v_current.vec complete dim=1
	static d_type_lanczos beta_new = 0, beta_current;
	d_type_lanczos alfa;
	part_vector A_mult_v;
	#pragma HLS ARRAY_PARTITION variable=A_mult_v.vec complete dim=1

	
	if(init)
	{
		beta_current = sc_in[0];
		reset_part_vector(&v_prev);
		copy_vector_to_part_vector(v_current_in, &v_current);
	} 


	mv_mult_prescaled_HW(&A_mult_v, blocks, out_blocks, &v_current);
	alfa = part_vector_mult_par(&A_mult_v, &v_current); // calculate alfa

	beta_new = part_vector_v_new(&v_new, &A_mult_v, &v_current, v_current_out, &v_prev, alfa, beta_current);
	// normalize and update v_prev, v_current, v_new
	part_vector_normalize_update(&v_new, &v_current, &v_prev, beta_new);

	// give required data to MINRES (scalars only)
	sc_out[0] = (float) alfa;
	sc_out[1] = (float) beta_current;
	sc_out[2] = (float) beta_new;

	// update beta
	beta_current = beta_new;

}


// functions implementations
void copy_vector_to_part_vector(float *vector, part_vector *instance)
{
	#pragma HLS INLINE
	int i,j,k;
	k = 0;
	copy_vector_to_part_vector_0:for(i = 0; i < n_states; i++, k++)
	{
		#pragma HLS PIPELINE
		instance->vec0[i] = (d_type_lanczos) vector[k];
	}
	copy_vector_to_part_vector_1:for(i = 0; i < PAR; i++)
	{
		copy_vector_to_part_vector_1_0:for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++, k++)
		{
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			instance->vec[i][j] = (d_type_lanczos) vector[k];
		}
	}
	#ifdef rem_partition
	copy_vector_to_part_vector_2:for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++, k++)
	{
		#pragma HLS PIPELINE
		instance->vec_rem[i] = (d_type_lanczos) vector[k];
	}
	#endif
	copy_vector_to_part_vector_3:for(i = 0; i < n_term_theta+n_term_eq; i++, k++)
	{
		#pragma HLS PIPELINE
		instance->vec_term[i] = (d_type_lanczos) vector[k];
	}
}


void part_vector_normalize_update(part_vector *v_new, part_vector *v_current, part_vector *v_prev, d_type_lanczos scalar)
{
	#pragma HLS INLINE
	int i,j;
	d_type_lanczos over_scalar;
	over_scalar = 1/scalar;

	merge_noramalize_loops:{
		#pragma HLS LOOP_MERGE
		part_vector_normalize_0: for(i = 0; i < n_states; i++)
		{
			#pragma HLS PIPELINE
			v_prev->vec0[i] = v_current->vec0[i];
			v_current->vec0[i] = over_scalar*v_new->vec0[i];
		}
		part_vector_normalize_1_0:for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
		{
			#pragma HLS PIPELINE
			part_vector_normalize_1_1:for(i = 0; i < PAR; i++)
			{
				#pragma HLS UNROLL skip_exit_check
				v_prev->vec[i][j] = v_current->vec[i][j];
				v_current->vec[i][j] = over_scalar*v_new->vec[i][j];
			}
		}
		#ifdef rem_partition
		part_vector_normalize_2:for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)
		{
			#pragma HLS PIPELINE
			v_prev->vec_rem[i] = v_current->vec_rem[i];
			v_current->vec_rem[i] = over_scalar*v_new->vec_rem[i];
		}
		
		#endif
		part_vector_normalize_3:for(i = 0; i < n_term_theta+n_term_eq; i++)
		{
			#pragma HLS PIPELINE
			v_prev->vec_term[i] = v_current->vec_term[i];
			v_current->vec_term[i] = over_scalar*v_new->vec_term[i];
		}
	}
}

d_type_lanczos part_vector_v_new(part_vector *v_new, part_vector *A_mult_v, part_vector *v_current, float v_current_out[n_linear], part_vector *v_prev, d_type_lanczos alfa, d_type_lanczos beta_current)
{
	#pragma HLS INLINE
	int i,j,k,l;
	int mask[2] = {0, ~((int) 0)};
	d_type_lanczos sos[10], sos_final, tmp_var;
	part_vector_mult_init: for(i = 0; i < 10; i++)
	{
		#pragma HLS PIPELINE
		sos[i] = 0;
	}
	sos_final = 0;
	k = 0;
	l = 0; // this counter is used for v_current_out
	part_vector_v_new_0:for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		#pragma HLS DEPENDENCE variable=sos array inter distance=10 true
		tmp_var = A_mult_v->vec0[i] - alfa*v_current->vec0[i] - beta_current*v_prev->vec0[i];
		v_current_out[l] = (float) v_current->vec0[i];
		v_new->vec0[i] = tmp_var;
		sos[k] += tmp_var*tmp_var;
		k = (k+1) & mask[(k+1) != 10];
		l++;
	}
	part_vector_v_new_1:for(i = 0; i < PAR; i++)
	{
		part_vector_v_new_1_0:for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
		{
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			#pragma HLS DEPENDENCE variable=sos array inter distance=10 true
			tmp_var = A_mult_v->vec[i][j] - alfa*v_current->vec[i][j] - beta_current*v_prev->vec[i][j];
			v_current_out[l] = (float) v_current->vec[i][j];
			v_new->vec[i][j] = tmp_var;
			sos[k] += tmp_var*tmp_var;
			k = (k+1) & mask[(k+1) != 10];
			l++;
		}
	}
	#ifdef rem_partition
	part_vector_v_new_2:for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)
	{
		#pragma HLS PIPELINE
		#pragma HLS DEPENDENCE variable=sos array inter distance=10 true
		tmp_var = A_mult_v->vec_rem[i] - alfa*v_current->vec_rem[i] - beta_current*v_prev->vec_rem[i];
		v_current_out[l] = (float) v_current->vec_rem[i];
		v_new->vec_rem[i] = tmp_var;
		sos[k] += tmp_var*tmp_var;
		k = (k+1) & mask[(k+1) != 10];
		l++;
	}
	#endif
	part_vector_v_new_3:for(i = 0; i < n_term_theta+n_term_eq; i++)
	{
		#pragma HLS PIPELINE
		#pragma HLS DEPENDENCE variable=sos array inter distance=10 true
		tmp_var = A_mult_v->vec_term[i] - alfa*v_current->vec_term[i] - beta_current*v_prev->vec_term[i];
		v_current_out[l] = (float) v_current->vec_term[i];
		v_new->vec_term[i] = tmp_var;
		sos[k] += tmp_var*tmp_var;
		k = (k+1) & mask[(k+1) != 10];
		l++;
	}

	part_vector_mult_final:for(i = 0; i < 10; i++)
	{
		sos_final += sos[i];
	}

	// return beta new
	#ifdef PROTOIP
		return hls::sqrtf(sos_final);
	#else
		return sqrtf(sos_final);
	#endif




}

void reset_part_vector(part_vector *instance)
{
	#pragma HLS INLINE
	int i,j;
	reset_part_vector_0:for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		instance->vec0[i] = 0;
	}
	reset_part_vector_1:for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
	{
	#pragma HLS PIPELINE
		for(i = 0; i < PAR; i++)
		{
#pragma HLS UNROLL skip_exit_check
			instance->vec[i][j] = 0;
		}
	}

	#ifdef rem_partition
	reset_part_vector_2:for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)
	{
		#pragma HLS PIPELINE
		instance->vec_rem[i] = 0;
	}
	#endif
	reset_part_vector_3:for(i = 0; i < n_term_theta+n_term_eq; i++)
	{
		#pragma HLS PIPELINE
		instance->vec_term[i] = 0;
	}
}


d_type_lanczos part_vector_mult(part_vector *x_1, part_vector *x_2)
{
	#pragma HLS INLINE off
	int i,j, k;
	int mask[2] = {0, ~((int) 0)};
	d_type_lanczos sos[8], sos_final;
	part_vector_mult_init: for(i = 0; i < 8; i++)
	{
		//#pragma HLS PIPELINE
		sos[i] = 0;
	}
	sos_final = 0;
	//k = 0;
	part_vector_mult_0: for(k = 0, i = 0; i < n_states; i++)
	{
		#pragma HLS DEPENDENCE variable=sos pointer inter distance=8 true
		//#pragma HLS PIPELINE
		sos[k] += (x_1->vec0[i] * x_2->vec0[i]);
		k = (k+1) & mask[(k+1) != 8];
	}
	part_vector_mult_1:for(i = 0; i < PAR; i++)
	{
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
		{
			#pragma HLS DEPENDENCE variable=sos pointer inter distance=8 true
			#pragma HLS LOOP_FLATTEN
			//#pragma HLS PIPELINE
			sos[k] +=  (x_1->vec[i][j] * x_2->vec[i][j]);
			k = (k+1) & mask[(k+1) != 8];
		}
	}
	#ifdef rem_partition
	part_vector_mult_2:for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)
	{
		#pragma HLS DEPENDENCE variable=sos array inter distance=8 true
		//#pragma HLS PIPELINE
		sos[k]+= (x_1->vec_rem[i] * x_2->vec_rem[i]);
		k = (k+1) & mask[(k+1) != 8];
	}
	#endif
	part_vector_mult_3:for(i = 0; i < n_term_theta+n_term_eq; i++)
	{
		#pragma HLS DEPENDENCE variable=sos array inter distance=8 true
		//#pragma HLS PIPELINE
		sos[k] += (x_1->vec_term[i] * x_2->vec_term[i]);
		k = (k+1) & mask[(k+1) != 8];
	}

	part_vector_mult_final:for(i = 0; i < 8; i++)
	{
		sos_final += sos[i];
	}
	return sos_final;
}


d_type_lanczos part_vector_mult_par(part_vector *x_1, part_vector *x_2)
{
	//#pragma HLS INLINE off
	int i, i1,i2, j, k, k1, k2;
	int mask1[2] = {0, ~((int) 0)};
	int mask2[2] = {0, ~((int) 0)};
	d_type_lanczos sos1[10], sos2[10], sos_final;
	part_vector_mult_init: for(int i = 0; i < 10; i++)
	{
		#pragma HLS PIPELINE
		sos1[i] = 0;
		sos2[i] = 0;
	}
	sos_final = 0;
	k1 = 0;
	part_vector_mult_0: for(k1 = 0, i1 = 0; i1 < n_states; i1++)
	{
		#pragma HLS DEPENDENCE variable=sos1 pointer inter distance=10 true
		#pragma HLS PIPELINE
		sos1[k1] += (x_1->vec0[i1] * x_2->vec0[i1]);
		k1 = (k1+1) & mask1[(k1+1) != 10];
	}
	k2 = 0;
	part_vector_mult_3:for(i2 = 0; i2 < n_term_theta+n_term_eq; i2++)
	{
		#pragma HLS DEPENDENCE variable=sos2 array inter distance=10 true
		#pragma HLS PIPELINE
		sos2[k2] += (x_1->vec_term[i2] * x_2->vec_term[i2]);
		k2 = (k2+1) & mask2[(k2+1) != 10];
	}
	k = 0;
	part_vector_mult_1:for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
	{
		for(i = 0; i < PAR; i+=2)
		{
			#pragma HLS DEPENDENCE variable=sos1 pointer inter distance=10 true
			#pragma HLS DEPENDENCE variable=sos2 pointer inter distance=10 true
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			sos1[k] +=  (x_1->vec[i][j] * x_2->vec[i][j]);
			sos2[k] +=  (x_1->vec[i+1][j] * x_2->vec[i+1][j]);
			k = (k+1) & mask1[(k+1) != 10];
		}
	}
	#ifdef rem_partition
	// ramainder is not handled (!)
	#endif


	part_vector_mult_final:for(i = 0; i < 10; i++)
	{
		sos_final += sos1[i] + sos2[i];
	}
	return sos_final;
}

/*
// this function is not needed because structure assignment seems to have the same efficiency
void part_vector_copy(part_vector *copy, part_vector *original)
{
	#pragma HLS INLINE
	int i,j;
	for(i = 0; i < n_states; i++)
	{
		#pragma HLS PIPELINE
		copy->vec0[i] = original->vec0[i];
	}
	for(i = 0; i < PAR; i++)
	{
		for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++)
		{
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			copy->vec[i][j] = original->vec[i][j];
		}
	}
	#ifdef rem_partition
	for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++)
	{
		#pragma HLS PIPELINE
		copy->vec_rem[i] = original->vec_rem[i];
	}
	#endif
	for(i = 0; i < n_term_theta+n_term_eq; i++)
	{
		#pragma HLS PIPELINE
		copy->vec_term[i] = original->vec_term[i];
	}
}*/

/* 

void copy_part_vector_to_vector(part_vector *instance, float *vector)
{
	#pragma HLS INLINE
	int i,j,k;
	k = 0;
	copy_part_vector_to_vector_0: for(i = 0; i < n_states; i++, k++)
	{
		#pragma HLS PIPELINE
		vector[k] = (float) instance->vec0[i];
	}
	copy_part_vector_to_vector_1: for(i = 0; i < PAR; i++)
	{
		copy_part_vector_to_vector_1_0: for(j = 0; j < part_size*(n_node_theta+n_node_eq); j++, k++)
		{
			#pragma HLS LOOP_FLATTEN
			#pragma HLS PIPELINE
			vector[k] = (float) instance->vec[i][j];
		}
	}

	#ifdef rem_partition
	copy_part_vector_to_vector_2: for(i = 0; i < rem_partition*(n_node_theta+n_node_eq); i++, k++)
	{
		#pragma HLS PIPELINE
		vector[k] = (float) instance->vec_rem[i];
	}
	#endif
	copy_part_vector_to_vector_3: for(i = 0; i < n_term_theta+n_term_eq; i++, k++)
	{
		#pragma HLS PIPELINE
		vector[k] = (float) instance->vec_term[i];
	}
}

*/