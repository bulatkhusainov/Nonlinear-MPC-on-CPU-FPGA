#include "user_main_header.h"
#include "user_nnz_header.h"

void qp_solver(float x_hat[n_states], u_opt[m_inputs])
{
	// counters
	int i,j,k;
	int ip_counter;

	float all_theta[n_all_theta], d_all_theta[n_all_theta]; // optimization variables
	float all_nu[n_all_nu], d_all_nu[n_all_nu]; // equality constraints Lagrange multipliers
	float all_lambda[n_all_lambda], d_all_lambda[n_all_lambda]; // inequality constraints Lagrange multipliers
	float bounds[n_all_lambda];
	float all_one_over_g[n_all_lambda];
	float all_mu_over_g[n_all_lambda];
	float all_lambda_over_g[n_all_lambda];

	float mu = 0.001; // barrier parameter

	float blocks[N*nnz_block_tril + nnz_term_block_tril]; // linear system for calculating Newton's step
	float b[n_all_theta + n_all_nu]; // residual
	float d_x[n_all_theta + n_all_nu]; // Newton's direction

	float node_jac_2d[N][n_node_eq][n_node_theta];
	float term_jac_2d[n_term_eq][n_term_theta];

	// initial guess
	for(i = 0; i < n_all_theta; i++)
		all_theta[i] = 0; // make sure guess is feasible w.r.t. inequalities
	for(i = 0; i < n_all_nu; i++)
		all_nu[i] = 0;
	for(i = 0; i < n_all_lambda; i++)
		all_lambda[i] = 1;

	// interior point iterations
	for(ip_counter = 0; ip_counter < 1; ip_counter++)
	{
		// evaluate bound constraints
		for(i = 0; i < N; i++)
			node_bounds_eval(&node_bounds[i*n_bounds], &node_theta[i*n_node_theta]);

		
		for(i = 0; i < n_all_lambda; i++) // precalculate 1 over g
			all_one_over_g[i] = 1/bounds[i];
		for(i = 0; i < n_all_lambda; i++) // precalculate lambda over g
			all_lambda_over_g[i] = all_lambda_over_g[i]*all_one_over_g[i];
		for(i = 0; i < n_all_lambda; i++) // precalculate mu over g
			all_mu_over_g[i] = mu*all_one_over_g[i];		

		// evaluate blocks
		for(i = 0; i < N; i++) // node blocks
			node_block_eval(blocks[i*nnz_block_tril], node_theta[i*n_node_theta], node_lambda_over_g[i*n_bounds]);
		term_block_eval( &term_block[N*nnz_block_tril], &term_theta[N*n_node_theta]); // terminal block

		// evaluate residuals


	}





}