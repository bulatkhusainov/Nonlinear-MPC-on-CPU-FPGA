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


void minres_HW(part_matrix *blocks, d_type_lanczos* out_blocks, float* b,float* x_current, float* minres_data)
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
	init_loop:for(i = 0; i < n_linear; i++)
	{
		#pragma HLS PIPELINE
		omega_pprev[i] = 0;
		omega_prev[i] = 0;
		x_current[i] = 0;
		v_current_HW_in[i] = b[i];
	}
	/*v_current_set_loop:for(i = 0; i < n_linear; i++)
	{
		#pragma HLS PIPELINE
		v_current_HW_in[i] = b[i]; // initially this vector stores v_current
	}*/


	#ifdef PROTOIP
	beta_current = hls::sqrtf(vv_mult_HW(v_current_HW_in,v_current_HW_in));
	#else
	beta_current = sqrtf(vv_mult_HW(v_current_HW_in,v_current_HW_in));
	#endif
	nu_current = beta_current;

	// manually perform first iteration of Lanczos kernel to achieve pipelining
	init_lanczos_loop: for(i = 0; i < n_linear; i++)
	{
		#pragma HLS PIPELINE
		v_current_HW_in[i] = v_current_HW_in[i]/beta_current;
	}

	//sc_in[0] = 1;

	sc_in[0] = beta_current;
	#ifdef MINRES_prescaled
		lanczos_HW(1, blocks, out_blocks, v_current_HW_in,  v_current_HW, sc_in, sc_out);
	#else
		// no hardware realization of unprescaled implementation
	#endif

	// extract required info from the lanczos kernel
	extract_from_lanczos_loop: for(i = 0; i < n_linear; i++)
	{
		#pragma HLS PIPELINE
		v_current_alg[i] = v_current_HW[i];
	}

	// main loop
	//main_loop: for(counter = 0; counter < MINRES_iter; counter++)
	main_loop: for(counter = 0; counter < (int) minres_data[0]; counter++)
	{	

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
		#ifdef PROTOIP
			over_ro_1 = 1/(hls::sqrtf(delta*delta + beta_new*beta_new));
		#else
			over_ro_1 = 1/(sqrtf(delta*delta + beta_new*beta_new));
		#endif
		ro_2 = sigma_current*alfa_current + gamma_prev*gamma_current*beta_current;
		ro_3 = sigma_prev*beta_current;

		//calculate Givens rotation
    	gamma_new = delta*over_ro_1;
    	sigma_new = beta_new*over_ro_1;

    	//update solution
    	solution_update_loop:for(i = 0;i < n_linear; i++)
    	{
    		#pragma HLS PIPELINE
    		omega_current[i] = (v_current_alg[i] - ro_3*omega_pprev[i] - ro_2*omega_prev[i])*over_ro_1;
    		x_new[i] = x_current[i] + gamma_new*nu_current*omega_current[i];

    		x_current[i] = x_new[i];
    		omega_pprev[i] = omega_prev[i];
    		omega_prev[i] = omega_current[i];
    		v_current_alg[i] = v_current_HW[i];
    	}

    	nu_new = -sigma_new*nu_current;

    	// update variables and pointers
		/*variables_update_loop: for(i = 0; i < n_linear; i++)

			#pragma HLS PIPELINE
			x_current[i] = x_new[i];
			omega_pprev[i] = omega_prev[i];
			omega_prev[i] = omega_current[i];
			v_current_alg[i] = v_current_HW[i];
		}*/

		/*variables_update_loop2: for(int i1 = 0; i1 < n_linear; i1++)
		{
			#pragma HLS PIPELINE
			//v_current_alg[i1] = v_current_HW[i1];
		}*/
 	
    	nu_current = nu_new; // update variables

    	gamma_prev = gamma_current;
    	gamma_current = gamma_new;

    	sigma_prev = sigma_current;
    	sigma_current = sigma_new;
	}

	
}



