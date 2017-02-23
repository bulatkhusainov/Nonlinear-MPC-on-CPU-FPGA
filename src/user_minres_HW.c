#include "user_main_header.h"
#include "user_prototypes_header.h"
#include <math.h>  
#include "mex.h"

float vv_mult_HW(float *x_1, float *x_2)
{
	int i;
	float sos = 0;
	for(i=0;i<n_linear;i++)
	{
		sos = sos + x_1[i]*x_2[i];
	}
	return sos;
}


void minres_HW(part_matrix *blocks, float* out_blocks, float* b,float* x_current)
{


	//variables declaration
	int counter = 1, i; 
	float x_new[n_linear];
		//x_current[n_linear] // x_current is a solution guess (is coming from function interface)
	float v_current_HW_in[n_linear];
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


	//initialisation
	for(i = 0; i < n_linear; i++)
		omega_pprev[i] = 0;
	for(i = 0; i < n_linear; i++)
		omega_prev[i] = 0;
	for(i = 0; i < n_linear; i++)
		x_current[i] = 0;
	for(i = 0; i < n_linear; i++)
		v_current_HW_in[i] = b[i]; // initially this vector stores v_current

	beta_current = sqrtf(vv_mult_HW(v_current_HW_in,v_current_HW_in));
	nu_current = beta_current;

	// manually perform first iteration of Lanczos kernel to achieve pipelining
	for(i = 0; i < n_linear; i++)
		v_current_HW_in[i] = v_current_HW_in[i]/beta_current;
	sc_in[0] = beta_current;
	#ifdef MINRES_prescaled
		lanczos_HW(1, blocks, out_blocks, v_current_HW_in,  v_current_HW, sc_in, sc_out);
	#else
		// no hardware realization of unprescaled implementation
	#endif

	// main loop
	for(counter = 0; counter < MINRES_iter; counter++)
	{	


		// extract reqired info from the lanczos kernel
		for(i = 0; i < n_linear; i++)
				v_current_alg[i] = v_current_HW[i];
		alfa_current = sc_out[0];
		beta_current = sc_out[1];
		beta_new = sc_out[2];

		// start a new iteration of Lanczos kernel (this function operates in parallel with the rest of MINRES ieration)
		#ifdef MINRES_prescaled
			lanczos_HW(0, blocks, out_blocks, v_current_HW_in,  v_current_HW, sc_in, sc_out);
		#else
			// no hardware realization of unprescaled implementation
		#endif

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
    		omega_current[i] = (v_current_alg[i] - ro_3*omega_pprev[i] - ro_2*omega_prev[i])*over_ro_1;
    	for(i = 0; i < n_linear; i++)
    		x_new[i] = x_current[i] + gamma_new*nu_current*omega_current[i];
    	nu_new = -sigma_new*nu_current;


    	// update variables and pointers
		for(i = 0; i < n_linear; i++)
		{
			x_current[i] = x_new[i];
		}

		for(i = 0; i < n_linear; i++)
		{
			omega_pprev[i] = omega_prev[i];
			omega_prev[i] = omega_current[i];
		}
 	
    	nu_current = nu_new; // update variables

    	gamma_prev = gamma_current;
    	gamma_current = gamma_new;

    	sigma_prev = sigma_current;
    	sigma_current = sigma_new;

	}

	
}



