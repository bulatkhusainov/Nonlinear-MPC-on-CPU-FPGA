#include "user_main_header.h"

// this function evaluates bounds constraints 
void node_bounds_eval(float node_bounds[n_bounds],float node_theta[n_node_theta])
{
	int upper_bounds_indeces[1] = {2,};
	int lower_bounds_indeces[1] = {2,};
	float upper_bounds[1] = {0.5000000000000000,};
	float lower_bounds[1] = {-0.5000000000000000,};

	int i, j;

	//handle upper bounds
	for(i = 0; i < n_upper_bounds; i++)
	{
		node_bounds[i] = node_theta[upper_bounds_indeces[i]] - upper_bounds[i];
	}

	//handle lower bounds
	for(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++)
	{
		node_bounds[i] = -node_theta[lower_bounds_indeces[j]] + lower_bounds[j];
	}
}

// this function evaluates node gwg 
void node_gwg_eval(float node_gwg[n_states+m_inputs+n_node_slack],float node_bounds[n_bounds],float node_lambda[n_bounds])
{
	int upper_bounds_indeces[1] = {2,};
	int lower_bounds_indeces[1] = {2,};

	int i, j;
	float tmp_array[n_bounds];

	for(i = 0; i < n_bounds; i++)
	{
		tmp_array[i] = -node_lambda[i]/node_bounds[i];
	}

	//reset node_gwg[] 
	for(i = 0; i < n_states+m_inputs+n_node_slack; i++) 
	{
		node_gwg[i] = 0; 
	}

	//handle upper bounds
	for(i = 0; i < n_upper_bounds; i++)
	{
		node_gwg[upper_bounds_indeces[i]] += tmp_array[i];
	}

	//handle lower bounds
	for(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++)
	{
		node_gwg[lower_bounds_indeces[j]] += tmp_array[i];
	}

}
