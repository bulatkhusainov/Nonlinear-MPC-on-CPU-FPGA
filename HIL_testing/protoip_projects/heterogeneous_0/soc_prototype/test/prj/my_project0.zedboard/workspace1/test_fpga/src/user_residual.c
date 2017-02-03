#include "user_main_header.h"

// functions prototypes 
void node_gradient_eval(float node_gradient[n_node_theta],float node_theta[n_node_theta]); 
void f_eval(float f[n_node_eq],float node_theta[n_node_theta]); 
void term_gradient_eval(float term_gradient[n_term_theta],float term_theta[n_term_theta]); 
void term_f_eval(float term_f[n_term_eq],float term_theta[n_term_theta]); 

// this function evaluates node residual 
void node_residual_eval(float residual[n_node_theta+n_node_eq],float node_theta[n_node_theta],float node_nu[n_node_eq],float node_mu_over_g[n_bounds],float node_jac_2d[n_node_eq][n_node_theta],float mu)
{
	int i,j;
	float tmp_array[n_node_theta];

	// bounds indices
	int upper_bounds_indeces[2] = {2,1,};
	int lower_bounds_indeces[1] = {2,};

	// evaluate gradient
	node_gradient_eval(tmp_array, node_theta); 

	// multiply jacobian transpose by nu
	for(i = 0; i < n_node_eq; i++)
	{
		for(j = 0; j < n_node_theta; j++)
		{
			tmp_array[j] += node_jac_2d[i][j]*node_nu[i];
		}
	}

	// handle bounds
	float tmp_upper[n_node_theta], tmp_lower[n_node_theta];
	for(i = 0; i < n_node_theta; i++)
		tmp_upper[i] = 0;
	for(i = 0; i < n_node_theta; i++)
		tmp_lower[i] = 0;
	for(i = 0; i < n_upper_bounds; i++)
		tmp_upper[upper_bounds_indeces[i]] = node_mu_over_g[i];
	for(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++)
		tmp_lower[lower_bounds_indeces[j]] = -node_mu_over_g[i];

	// optimality error residual
	for(i = 0; i < n_node_theta; i++)
	{
		residual[i] = -tmp_array[i] + tmp_upper[i] + tmp_lower[i];
	}

	// feasibility error residual
	f_eval(&residual[n_node_theta], node_theta);
	for(i = n_node_theta; i < n_node_theta+n_node_eq; i++)
		residual[i] = -residual[i];
}
// this function evaluates terminal residual 
void term_residual_eval(float term_residual[n_term_theta+n_term_eq],float term_theta[n_term_theta],float term_nu[n_term_eq],float term_jac_2d[n_term_eq][n_term_theta])
{
	int i,j;
	float tmp_array[n_term_theta];

	// evaluate terminal gradient
	term_gradient_eval(tmp_array, term_theta); 

	// multiply jacobian transpose by nu
	for(i = 0; i < n_term_eq; i++)
	{
		for(j = 0; j < n_term_theta; j++)
		{
			tmp_array[j] += term_jac_2d[i][j]*term_nu[i];
		}
	}

	// optimality error residual
	for(i = 0; i < n_term_theta; i++)
	{
		term_residual[i] = -tmp_array[i];
	}

	// feasibility error residual
	term_f_eval(&term_residual[n_term_theta], term_theta);
	for(i = n_term_theta; i < n_term_theta+n_term_eq; i++)
		term_residual[i] = -term_residual[i];
}
