#include "user_main_header.h"
#include "user_prototypes_header.h"
#include <math.h>  
#include "mex.h"

//#define n_linear (n_all_theta+n_all_nu)

float vv_mult(float *x_1, float *x_2)
{
	int i;
	float sos = 0;
	for(i=0;i<n_linear;i++)
	{
		sos = sos + x_1[i]*x_2[i];
	}
	return sos;
}

#ifdef MINRES_prescaled
	void minres(float* blocks, float* out_blocks, float* b,float* x_current)
#else
	void minres(float* blocks, float* b,float* x_current)
#endif
{


	//variables declaration
	int counter = 1, i; 
	float x_new[n_linear];
		//x_current[n_linear] // x_current is a solution guess (is coming from function interface)
	float *v_current, v_tmp1[n_linear], v_tmp2[n_linear]; // Lanczos vectors for SW implementation
	float v_current_HW[n_linear]; // v_current for HW realization
	float v_current_alg[n_linear]; // v_current for MINRES algorithm
	float beta_current, over_beta_current, beta_new, beta_nnew;
	float nu_current, nu_new;
	float gamma_prev = 1, gamma_current = 1, gamma_new;
	float sigma_prev = 0, sigma_current = 0, sigma_new;
	float omega_pprev[n_linear], omega_prev[n_linear], omega_current[n_linear];
	float alfa_current;
	float delta, over_ro_1, ro_2, ro_3;
	float sc_in[5], sc_out[5];

	// declare and define pointers
	float *x_current_p = x_current; // x arrays
	float *x_new_p = x_new;
	float *omega_pprev_p = omega_pprev; // omega arrays
	float *omega_prev_p = omega_prev;
	float *omega_current_p = omega_current;
	float *tmp_pointer;

	//initialisation
	for(i = 0; i < n_linear; i++)
		omega_pprev_p[i] = 0;
	for(i = 0; i < n_linear; i++)
		omega_prev_p[i] = 0;
	for(i = 0; i < n_linear; i++)
		x_current_p[i] = 0;
	for(i = 0; i < n_linear; i++)
		v_tmp1[i] = 0; // initially this vector stores v_prev
	for(i = 0; i < n_linear; i++)
		v_tmp2[i] = b[i]; // initially this vector stores v_current

	beta_current = sqrtf(vv_mult(v_tmp2,v_tmp2));
	nu_current = beta_current;

	// manually perform first iteration of Lanczos kernel to achieve pipelining
	for(i = 0; i < n_linear; i++)
		v_tmp2[i] = v_tmp2[i]/beta_current;
	sc_in[0] = beta_current;
	#ifdef MINRES_prescaled
		#if heterogeneity > 1
			wrap_lanczos_HW(1, blocks, out_blocks, v_tmp2, v_current_HW, sc_in, sc_out); // HW implementation
		#else
			lanczos(1, blocks, out_blocks, v_tmp1, v_tmp2, &v_current, sc_in, sc_out); // SW implementation
		#endif
	#else
		lanczos(1, blocks, v_tmp1, v_tmp2, &v_current, sc_in, sc_out);
	#endif

	for(i = 0; i < n_linear; i++)
	{
		//printf("error[%d] = %f\n", i, v_current_HW[i] - v_current[i]);
	}
	

	// main loop
	for(counter = 0; counter < MINRES_iter; counter++)
	{	


		// extract reqired info from the lanczos kernel
		#if heterogeneity > 1
			for(i = 0; i < n_linear; i++)
				v_current_alg[i] = v_current_HW[i];
		#else
			for(i = 0; i < n_linear; i++)
				v_current_alg[i] = v_current[i];
		#endif
		alfa_current = sc_out[0];
		beta_current = sc_out[1];
		beta_new = sc_out[2];


		// start a new iteration of Lanczos kernel (this function operates in parallel with the rest of MINRES ieration)
		#ifdef MINRES_prescaled
			#if heterogeneity > 1
				wrap_lanczos_HW(0, blocks, out_blocks, v_tmp2, v_current_HW, sc_in, sc_out); // HW implementation
			#else
				lanczos(0, blocks, out_blocks, v_tmp1, v_tmp2, &v_current, sc_in, sc_out); // SW implementation
			#endif
		#else
			lanczos(0, blocks, v_tmp1, v_tmp2, &v_current, sc_in, sc_out);
		#endif

		for(i = 0; i < n_linear; i++)
		{
			//printf("error[%d] = %f\n", i, v_current_HW[i] - v_current[i]);
		}
	

		// Calculate QR factors
		delta = gamma_current*alfa_current - gamma_prev*sigma_current*beta_current;
		over_ro_1 = 1/(sqrtf(delta*delta + beta_new*beta_new));
		ro_2 = sigma_current*alfa_current + gamma_prev*gamma_current*beta_current;
		ro_3 = sigma_prev*beta_current;

		//calculate Givens rotation
    	gamma_new = delta*over_ro_1;
    	sigma_new = beta_new*over_ro_1;

    	//update solution
    	for(i = 0;i < n_linear; i++)
    		omega_current_p[i] = (v_current_alg[i] - ro_3*omega_pprev_p[i] - ro_2*omega_prev_p[i])*over_ro_1;
    	for(i = 0; i < n_linear; i++)
    		x_new_p[i] = x_current_p[i] + gamma_new*nu_current*omega_current_p[i];
    	nu_new = -sigma_new*nu_current;

    	// update variables and pointers
		tmp_pointer = x_current_p; // update pointers the for x
		x_current_p = x_new_p;
		x_new_p = tmp_pointer;

		tmp_pointer = omega_pprev_p; // udpdate pointers for omega
		omega_pprev_p = omega_prev_p;
		omega_prev_p = omega_current_p;
		omega_current_p = tmp_pointer;
 	
    	nu_current = nu_new; // update variables

    	gamma_prev = gamma_current;
    	gamma_current = gamma_new;

    	sigma_prev = sigma_current;
    	sigma_current = sigma_new;

	}

	
}



