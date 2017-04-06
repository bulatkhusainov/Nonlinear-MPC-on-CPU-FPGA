/* 
* icl::protoip
* Authors: asuardi <https://github.com/asuardi>, bulatkhusainov <https://github.com/bulatkhusainov>
* Date: November - 2014
*/


#include "soc_user.h"
#include "foo_function_wrapped.h"
#include "user_main_header.h"

void nlp_solver(float debug_output[n_all_theta + n_all_nu], float all_theta[n_all_theta], float all_nu[n_all_nu], float all_lambda[n_all_lambda], float x_hat[n_states]);

void soc_user(float soc_x_hat_in[SOC_X_HAT_IN_VECTOR_LENGTH],float soc_u_opt_out[SOC_U_OPT_OUT_VECTOR_LENGTH])
{
	
	int i,j,k;
	float debug_output[n_all_theta + n_all_nu]={0};
	float all_theta[n_all_theta]={0,};
	float all_nu[n_all_nu]={0,};
	float all_lambda[n_all_lambda] = {0,};
	float x_hat[n_states];

	// initial condition
	for(i = 0; i < n_states; i++)
	{
		x_hat[i] = soc_x_hat_in[i];
	}

	//x_hat[0] = 0.5;
	//x_hat[1] = 0;

	nlp_solver(debug_output, all_theta, all_nu, all_lambda, x_hat);

	for(i = 0; i < n_all_theta; i++)
	{
		soc_u_opt_out[i] = all_theta[i];
	}
}


/*
	// declare input and output interfaces arrays
	float *init_in,*sc_in_in,*block_in,*out_block_in,*v_in_in;
	float *v_out_out,*sc_out_out;


	// send data to DDR
	send_init_in(init_in);
	send_sc_in_in(sc_in_in);
	send_block_in(block_in);
	send_out_block_in(out_block_in);
	send_v_in_in(v_in_in);


	// call hardware accelerator assuming all interfaces are involoved
	start_foo(1,1,1,1,1,1,1);


	// wait for IP to finish
	while(!(finished_foo())){;}


	// read data from DDR
	receive_v_out_out(v_out_out);
	receive_sc_out_out(sc_out_out);
*/
