#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_prototypes_header.h"
#include <math.h>  
#include <stdint.h>

//#define n_linear (n_all_theta+n_all_nu)

extern int counter;
extern float debug_interface[n_linear];

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


#ifdef MINRES_prescaled
	void lanczos(int init, float blocks[], float out_blocks[], float v_tmp1[], float v_tmp2[], float **v_current_out, float sc_in[5], float sc_out[5])
#else
	void lanczos(int init, float blocks[], float v_tmp1[], float v_tmp2[], float **v_current_out, float sc_in[5], float sc_out[5])
#endif
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


	// v_current for debugging
	/*for(i = 0; i < n_linear; i++)
	{
		v_current[i] = i+1;
	}*/

	#ifdef MINRES_prescaled
		#if heterogeneity > 0
			#ifdef PROTOIP
				if(init)
				{
					send_block_in(blocks);
					send_out_block_in(out_blocks);
					send_x_in_in(v_current);
					// call hardware accelerator assuming all interfaces are involoved
					start_foo(1,1,1,1);
					// wait for IP to finish
					while(!(finished_foo())){;}
					// read data from DDR
					receive_y_out_out(A_mult_v);
				}
				else
				{
					while(!(finished_foo())){;}
					// read data from DDR
					receive_y_out_out(A_mult_v);
				}
				
			#else
				wrap_mv_mult_prescaled_HW(A_mult_v, blocks, out_blocks,v_current);
			#endif
		#else
			// SW implementation
			mv_mult_prescaled(A_mult_v, blocks, out_blocks,v_current); // calculate mat-vec product
		#endif
	#else
		mv_mult(A_mult_v,blocks,v_current); // calculate mat-vec product
	#endif


		if(counter == 0)
		{
				for(int i = 0; i < n_linear; i++)
				{
					debug_interface[i] = A_mult_v[i];
				}	
		}

	alfa = vv_mult1(A_mult_v,v_current); // calculate alfa
	for(i = 0; i < n_linear; i++) // calculate new v_current
	{
		v_prev[i] = A_mult_v[i] - alfa*v_current[i] - beta_current*v_prev[i];
	}
	beta_new = sqrtf(vv_mult1(v_prev,v_prev)); 
	for(i = 0; i < n_linear; i++)
		v_prev[i] = v_prev[i]/beta_new;


	#if heterogeneity > 0
			#ifdef PROTOIP
			send_x_in_in(v_prev);
			// call hardware accelerator assuming all interfaces are involoved
			start_foo(0,0,1,1);
		#endif
	#endif

	// put required information to interface arrays and variables
	//for(i = 0; i < n_linear; i++)
		//v_current_out[i] = v_current[i];
	*v_current_out = v_current; // let the algorithm know where to take v_current
	sc_out[0] = alfa;
	sc_out[1] = beta_current;
	sc_out[2] = beta_new;


}



