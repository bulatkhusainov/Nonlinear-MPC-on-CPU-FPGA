#include "user_main_header.h"
#include "user_prototypes_header.h"
#include <math.h>  
#include <stdint.h>

//#define n_linear (n_all_theta+n_all_nu)

float vv_mult1(float *x_1, float *x_2)
{
	int i;
	float sos = 0;
	for(i=0;i<n_linear;i++)
	{
		sos = sos + x_1[i]*x_2[i];
	}
	return sos;
}

void lanczos(int init, float blocks[], float v_tmp1[], float v_tmp2[], float **v_current_out, float sc_in[5], float sc_out[5])
{
	int i;
	static float *v_current, *v_prev, *tmp_pointer;
	static float beta_new;
	float alfa, beta_current;
	float A_mult_v[n_linear];

	beta_current = init*sc_in[0] + (!init)*beta_new; // conditionals statement without branching
	tmp_pointer = v_prev;
	v_prev = (float *)((init * ((uintptr_t)v_tmp1)) + ((!init) * ((uintptr_t)v_current)));
	v_current = (float *)((init * ((uintptr_t)v_tmp2)) + ((!init) * ((uintptr_t)tmp_pointer)));

	mv_mult(A_mult_v,blocks,v_current); // calculate mat-vec product
	alfa = vv_mult1(A_mult_v,v_current); // calculate alfa
	for(i = 0; i < n_linear; i++) // calculate new v_current
	{
		v_prev[i] = A_mult_v[i] - alfa*v_current[i] - beta_current*v_prev[i];
	}
	beta_new = sqrtf(vv_mult1(v_prev,v_prev)); 
	for(i = 0; i < n_linear; i++)
		v_prev[i] = v_prev[i]/beta_new;

	// put required information to interface arrays and variables
	//for(i = 0; i < n_linear; i++)
		//v_current_out[i] = v_current[i];
	*v_current_out = v_current; // let the algorithm know where to take v_current
	sc_out[0] = alfa;
	sc_out[1] = beta_current;
	sc_out[2] = beta_new;
}


