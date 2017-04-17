#include "user_protoip_definer.h"
#ifdef PROTOIP
#include "foo_data.h"
#endif
#include "user_main_header.h"
#include "user_prototypes_header.h"
#include <math.h>  
//#include "mex.h"

float vv_mult_HW(float *x_1, float *x_2)
{
	int i,j;
	float sos_final, sos[10];
	int mask[2] = {0, ~((int) 0)};
	sos_final = 0;
	for(i = 0; i < 10; i++)
	{
		#pragma HLS PIPELINE
		sos[i] = 0;
	}
	j = 0;
	for(i = 0;i < n_linear; i++)
	{
		#pragma HLS DEPENDENCE variable=sos array inter distance=10 true
		#pragma HLS PIPELINE
		sos[j] = sos[j] + x_1[i]*x_2[i];
		j = (j+1) & mask[(j+1) != 10];
	}
	for(i = 0; i < 10; i++)
	{
		sos_final += sos[i];
	}

	return sos_final;
}

void copy_vector_to_part_vector(float *vector, part_vector *instance);
void reset_part_vector(part_vector *instance);
d_type_lanczos part_vector_mult(part_vector *x_1, part_vector *x_2);
d_type_lanczos part_vector_v_new(part_vector *v_new, part_vector *A_mult_v, part_vector *v_current, float v_current_out[n_linear], part_vector *v_prev, d_type_lanczos alfa, d_type_lanczos beta_current);
void part_vector_normalize_update(part_vector *v_new, part_vector *v_current, part_vector *v_prev, d_type_lanczos scalar);
void copy_part_vector_to_vector(part_vector *instance, float *vector);
d_type_lanczos part_vector_mult_par(part_vector *x_1, part_vector *x_2);


void minres_HW(part_matrix *blocks, d_type_lanczos* out_blocks, float* b,float* x_current, float* minres_data)
{


	//variables declaration
	int counter = 1, i, j, k, l; 
	float x_new[n_linear];
		//x_current[n_linear] // x_current is a solution guess (is coming from function interface)
	part_vector v_current, v_prev, v_new;
	#pragma HLS ARRAY_PARTITION variable=v_new.vec complete dim=1
	#pragma HLS ARRAY_PARTITION variable=v_prev.vec complete dim=1
	#pragma HLS ARRAY_PARTITION variable=v_current.vec complete dim=1
	float v_current_alg_array[n_linear];
	part_vector A_mult_v;
	#pragma HLS ARRAY_PARTITION variable=A_mult_v.vec complete dim=1
	float beta_current, beta_new, alfa_current;
	float beta_current_alg, beta_new_alg, alfa_current_alg;
	float nu_current, nu_new;
	float gamma_prev = 1, gamma_current = 1, gamma_new;
	float sigma_prev = 0, sigma_current = 0, sigma_new;
	float omega_pprev[n_linear], omega_prev[n_linear], omega_current[n_linear];
	float delta, over_ro_1, ro_2, ro_3;

	float dummy_array[n_linear];

	#ifdef PROTOIP
		beta_current = hls::sqrtf(vv_mult_HW(b,b));
	#else
		beta_current = sqrtf(vv_mult_HW(b,b));
	#endif
	
	//initialisation
	init_loop:for(i = 0; i < n_linear; i++)
	{
		#pragma HLS PIPELINE
		b[i] = b[i]/beta_current;
	}

	nu_current = beta_current;

	reset_part_vector(&v_prev);
	copy_vector_to_part_vector(b, &v_current);

	// main loop
	main_loop: for(counter = 0; counter < (int) minres_data[0]; counter++)
	{	
		// Calculate QR factors
		delta = gamma_current*alfa_current_alg - gamma_prev*sigma_current*beta_current_alg;
		#ifdef PROTOIP
			over_ro_1 = 1/(hls::sqrtf(delta*delta + beta_new_alg*beta_new_alg));
		#else
			over_ro_1 = 1/(sqrtf(delta*delta + beta_new_alg*beta_new_alg));
		#endif
		ro_2 = sigma_current*alfa_current_alg + gamma_prev*gamma_current*beta_current_alg;
		ro_3 = sigma_prev*beta_current_alg;

		//calculate Givens rotation
    	gamma_new = delta*over_ro_1;
    	sigma_new = beta_new_alg*over_ro_1;

    	mv_mult_prescaled_HW(&A_mult_v, blocks, out_blocks, &v_current);
    	alfa_current = part_vector_mult_par(&A_mult_v, &v_current); // calculate alfa

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

			// solution update
    		omega_current[l] = (v_current_alg_array[l] - ro_3*omega_pprev[l] - ro_2*omega_prev[l])*over_ro_1;
    		x_new[l] = x_current[l] + gamma_new*nu_current*omega_current[l];

    		// variable update
    		x_current[l] = x_new[l];
    		omega_pprev[l] = omega_prev[l];
    		omega_prev[l] = omega_current[l];

			tmp_var = A_mult_v.vec0[i] - alfa_current*v_current.vec0[i] - beta_current*v_prev.vec0[i];
			v_current_alg_array[l] = (float) v_current.vec0[i];
			v_new.vec0[i] = tmp_var;
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

				// solution update
	    		omega_current[l] = (v_current_alg_array[l] - ro_3*omega_pprev[l] - ro_2*omega_prev[l])*over_ro_1;
	    		x_new[l] = x_current[l] + gamma_new*nu_current*omega_current[l];

	    		// variable update
	    		x_current[l] = x_new[l];
	    		omega_pprev[l] = omega_prev[l];
	    		omega_prev[l] = omega_current[l];

				tmp_var = A_mult_v.vec[i][j] - alfa_current*v_current.vec[i][j] - beta_current*v_prev.vec[i][j];
				v_current_alg_array[l] = (float) v_current.vec[i][j];
				v_new.vec[i][j] = tmp_var;
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

			// solution update
    		omega_current[l] = (v_current_alg_array[l] - ro_3*omega_pprev[l] - ro_2*omega_prev[l])*over_ro_1;
    		x_new[l] = x_current[l] + gamma_new*nu_current*omega_current[l];

    		// variable update
    		x_current[l] = x_new[l];
    		omega_pprev[l] = omega_prev[l];
    		omega_prev[l] = omega_current[l];

			tmp_var = A_mult_v.vec_rem[i] - alfa_current*v_current.vec_rem[i] - beta_current*v_prev.vec_rem[i];
			v_current_alg_array[l] = (float) v_current.vec_rem[i];
			v_new.vec_rem[i] = tmp_var;
			sos[k] += tmp_var*tmp_var;
			k = (k+1) & mask[(k+1) != 10];
			l++;
		}
		#endif
		part_vector_v_new_3:for(i = 0; i < n_term_theta+n_term_eq; i++)
		{
			#pragma HLS PIPELINE
			#pragma HLS DEPENDENCE variable=sos array inter distance=10 true

			// solution update
    		omega_current[l] = (v_current_alg_array[l] - ro_3*omega_pprev[l] - ro_2*omega_prev[l])*over_ro_1;
    		x_new[l] = x_current[l] + gamma_new*nu_current*omega_current[l];

    		// variable update
    		x_current[l] = x_new[l];
    		omega_pprev[l] = omega_prev[l];
    		omega_prev[l] = omega_current[l];

			tmp_var = A_mult_v.vec_term[i] - alfa_current*v_current.vec_term[i] - beta_current*v_prev.vec_term[i];
			v_current_alg_array[l] = (float) v_current.vec_term[i];
			v_new.vec_term[i] = tmp_var;
			sos[k] += tmp_var*tmp_var;
			k = (k+1) & mask[(k+1) != 10];
			l++;
		}

		part_vector_mult_final:for(i = 0; i < 10; i++)
		{
			sos_final += sos[i];
		}
		#ifdef PROTOIP
			beta_new = hls::sqrtf(sos_final);
		#else
			beta_new = sqrtf(sos_final);
		#endif

    	//beta_new = part_vector_v_new(&v_new, &A_mult_v, &v_current, dummy_array, &v_prev, alfa_current, beta_current);
    	//copy_part_vector_to_vector(&v_current, v_current_alg_array);

		part_vector_normalize_update(&v_new, &v_current, &v_prev, beta_new);

		beta_current_alg = beta_current;
		beta_new_alg = beta_new;
		alfa_current_alg = alfa_current;

		beta_current = beta_new;

    	nu_current = -sigma_new*nu_current;
 		
    	// update variables
    	gamma_prev = gamma_current;
    	gamma_current = gamma_new;

    	sigma_prev = sigma_current;
    	sigma_current = sigma_new;

    	if(counter == 0)
    	{
    		init_loop1:for(i = 0; i < n_linear; i++)
			{
				#pragma HLS PIPELINE
				omega_pprev[i] = 0;
				omega_prev[i] = 0;
				x_current[i] = 0;
			}
			nu_current = beta_current_alg;
			gamma_prev = 1; gamma_current = 1;
			sigma_prev = 0; sigma_current = 0;
    	}
	}

	
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
