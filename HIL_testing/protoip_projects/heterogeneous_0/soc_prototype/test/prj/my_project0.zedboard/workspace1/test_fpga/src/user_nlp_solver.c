#include "user_main_header.h"
#include "user_nnz_header.h"
#include "user_prototypes_header.h"

void nlp_solver(float debug_output[n_all_theta + n_all_nu], float all_theta[n_all_theta], float all_nu[n_all_nu], float all_lambda[n_all_lambda], float x_hat[n_states])
{
	// counters
	int i,j,k;
	int ip_counter;

	float d_all_theta[n_all_theta];// all_theta[n_all_theta]; // optimization variables
	float d_all_nu[n_all_nu];// all_nu[n_all_nu]; // equality constraints Lagrange multipliers
	float d_all_lambda[n_all_lambda]; // all_lambda[n_all_lambda]; // inequality constraints Lagrange multipliers
	float bounds[n_all_lambda];
	float all_one_over_g[n_all_lambda];
	float all_mu_over_g[n_all_lambda];
	float all_lambda_over_g[n_all_lambda];
	float d_all_theta_search[n_all_lambda];

	float mu = 0.001; // barrier parameter

	float blocks[N*nnz_block_tril + nnz_term_block_tril]={0}; // linear system for calculating Newton's step
	float b[n_all_theta + n_all_nu]={0,}; // residual
	float d_x[n_all_theta + n_all_nu]; // Newton's direction

	float node_jac_2d[N][n_node_eq][n_node_theta]={0,};
	float term_jac_2d[n_term_eq][n_term_theta]={0,};

	for(i = 0; i < N; i++)
		for(j = 0; j < n_node_eq; j++)
			for(k = 0; k < n_node_theta; k++)
				node_jac_2d[i][j][k] = 0;


	float *local_ptr1, *local_ptr2, *local_ptr3, *local_ptr4, *local_ptr5; // local pointers for efficient handling of nested loops

	// initial guess
	for(i = 0; i < n_all_theta; i++)
		all_theta[i] = 0; 
		//all_theta[i] = 0.77*sinf((float)(i+1)); // make sure guess is feasible w.r.t. inequalities
	for(i = 0; i < n_all_nu; i++)
		all_nu[i] = 0;
		//all_nu[i] = 0.5*sinf((float)(i+1));
	for(i = 0; i < n_all_lambda; i++)
		all_lambda[i] = 1;

	//all_theta[901] = 12;
	//all_nu[300] = 4;

	

	// interior point iterations
	for(ip_counter = 0; ip_counter < IP_iter; ip_counter++)
	{

		// evaluate bound constraints
		for(i = 0; i < N; i++)
			node_bounds_eval(&bounds[i*n_bounds], &all_theta[i*n_node_theta]);

		for(i = 0; i < n_all_lambda; i++) // precalculate 1 over g
			all_one_over_g[i] = 1/bounds[i];
		for(i = 0; i < n_all_lambda; i++) // precalculate lambda over g
			all_lambda_over_g[i] = all_lambda[i]*all_one_over_g[i];
		for(i = 0; i < n_all_lambda; i++) // precalculate mu over g
			all_mu_over_g[i] = mu*all_one_over_g[i];


		for(i = 0; i < N*nnz_block_tril + nnz_term_block_tril; i++) blocks[i] = 0;
		// evaluate blocks
		for(i = 0; i < N; i++) // node blocks
			node_block_eval(&blocks[i*nnz_block_tril], (float (*)[n_node_theta]) &node_jac_2d[i][0][0], &all_theta[i*n_node_theta], &all_lambda_over_g[i*n_bounds]);
		 term_block_eval(&blocks[N*nnz_block_tril], term_jac_2d, &all_theta[N*n_node_theta]); // terminal block


		/* k = 0;
		for(i = 0; i < n_node_eq; i++)
		{
			for(j = 0; j < n_node_theta; j++)
				//printf("node_jac_2d[%d][%d] = %f\n",i,j,node_jac_2d[0][i][j]);
				debug_output[k] = node_jac_2d[0][i][j];
			k++;

		}*/

		// evaluate residuals
 		for(i = 0; i < n_states; i++) // handle initial condition
			b[i] = all_theta[i] - x_hat[i];
		for(i = 0; i < N; i++) // node residuals (without handling negative identities and initial condition)
			node_residual_eval(&b[n_states + i*(n_node_theta+n_node_eq)], &all_theta[i*n_node_theta], &all_nu[n_states+i*n_node_eq], &all_mu_over_g[i*n_bounds], (float (*)[n_node_theta]) &node_jac_2d[i][0][0], mu);
		term_residual_eval(&b[n_states + i*(n_node_theta+n_node_eq)], &all_theta[N*n_node_theta], &all_nu[n_states+N*n_node_eq], term_jac_2d); // terminal residual

		for(i = 0; i < n_states; i++) // handle negative identities for optimality error
			b[n_states + i] += all_nu[i];
		for(i = 1; i < N+1; i++)
		{
			local_ptr1 = &b[n_states+i*(n_node_theta+n_node_eq)];
			local_ptr2 = &all_nu[n_states+(i-1)*n_node_eq];
			for(j = 0; j < n_states; j++) 
				local_ptr1[j] += local_ptr2[j];
		}
		for(i = 0; i < N; i++) // negative identities for feasibility error
		{
			local_ptr1 = &b[n_states+n_node_theta+i*(n_node_eq+n_node_theta)];
			local_ptr2 = &all_theta[(i+1)*n_node_theta];
			for(j = 0; j < n_states; j++) 
				local_ptr1[j] += local_ptr2[j];
		}

		// evaluate mat vec multiplication
		//mv_mult(d_x,blocks,b);




		// solve linear system with minres
		#ifdef MINRES_prescaled
			prescaler(blocks, b,d_x);
		#else
			minres(blocks, b, d_x);
		#endif

		// recover solution
		rec_sol(d_all_theta, d_all_nu, d_all_lambda, d_all_theta_search, d_x, all_lambda, all_mu_over_g, all_lambda_over_g);

		// line search
		float alfa;
		int lsearch_counter;
		alfa = 1;
		lsearch_counter = 0;
		while(lsearch_counter < n_all_lambda)
		{
			if(   (  (all_lambda[lsearch_counter] + alfa*d_all_lambda[lsearch_counter]) < 0  ) ||
			  	  (  (     bounds[lsearch_counter] + alfa*d_all_theta_search[lsearch_counter]) > 0  )   )
				alfa = alfa*0.9;
			else
				lsearch_counter += 1;	
		}

		// perform step
		for(i = 0; i < n_all_theta; i++)
			all_theta[i] += alfa*d_all_theta[i];
		for(i = 0; i < n_all_nu; i++)
			all_nu[i] += alfa*d_all_nu[i];
		for(i = 0; i < n_all_lambda; i++)
			all_lambda[i] += alfa*d_all_lambda[i];

		//printf("iteration: %d, alfa: %f\n",ip_counter,alfa );


	}

	// print for debugging purpose
	for(i = 0; i < n_all_theta; i++)
	{
		//debug_output[i] = all_theta[i];
	}

}