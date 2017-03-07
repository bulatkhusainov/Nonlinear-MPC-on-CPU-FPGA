#include "user_protoip_definer.h"
#include "user_main_header.h"
#include "user_nnz_header.h"

// this function extracts d_all_theta[], d_all_lambda[],
// recovers d_lambda[] and extract data d_all_theta_search[] for line search
void rec_sol(float d_all_theta[n_all_theta],float d_all_nu[n_all_nu],float d_all_lambda[n_all_lambda],float d_all_theta_search[n_all_lambda],float d_x[n_linear],float all_lambda[n_all_lambda],float all_mu_over_g[n_all_lambda],float all_lambda_over_g[n_all_lambda])
{
	int i,j,k;
	float *local_ptr1, *local_ptr2, *local_ptr3, *local_ptr4, *local_ptr5; // local pointers for efficient handling of nested loops

	int upper_bounds_indeces[1] = {4,};
	int lower_bounds_indeces[1] = {4,};
	float upper_bounds[1] = {0.4000000000000000,};
	float lower_bounds[1] = {-0.4000000000000000,};

	// extract d_all_theta[] from d_x[]
	for(i = 0; i < N; i++)
	{
		local_ptr1 = &d_all_theta[i*n_node_theta];
		local_ptr2 = &d_x[n_states + i*(n_node_theta+n_node_eq)];
		for(j = 0; j < n_node_theta; j++)
			local_ptr1[j] = local_ptr2[j];
	}
	local_ptr1 = &d_all_theta[N*n_node_theta];
	local_ptr2 = &d_x[n_states + N*(n_node_theta+n_node_eq)];
	for(j = 0; j < n_term_theta; j++)
		local_ptr1[j] = local_ptr2[j];

	// extract d_all_nu[] from d_x[]
	for(i = 0; i < n_states; i++)
		d_all_nu[i] = d_x[i];
	for(i = 0; i < N; i++)
	{
		local_ptr1 = &d_all_nu[n_states + i*n_node_eq];
		local_ptr2 = &d_x[n_states + n_node_theta + i*(n_node_theta+n_node_eq)];
		for(j = 0; j < n_node_eq; j++)
			local_ptr1[j] = local_ptr2[j];
	}
	local_ptr1 = &d_all_nu[n_states + N*n_node_eq];
	local_ptr2 = &d_x[n_states + N*(n_node_theta+n_node_eq) + n_term_theta];
	for(j = 0; j < n_term_eq; j++)
		local_ptr1[j] = local_ptr2[j];

	// recover  d_lambda[] and extract data d_all_theta_search[] for line search
	for(i = 0; i < N; i++)
	{
		local_ptr1 = &d_all_theta_search[i*n_bounds];
		local_ptr2 = &d_all_theta[i*n_node_theta];
		for(j = 0; j < n_upper_bounds; j++)
			local_ptr1[j] = local_ptr2[upper_bounds_indeces[j]];
		local_ptr1 = &d_all_theta_search[i*n_bounds+n_upper_bounds];
		for(j = 0; j < n_lower_bounds; j++)
			local_ptr1[j] = -local_ptr2[lower_bounds_indeces[j]];
		local_ptr1 = &d_all_lambda[i*n_bounds];
		local_ptr2 = &all_lambda[i*n_bounds];
		local_ptr3 = &all_mu_over_g[i*n_bounds];
		local_ptr4 = &all_lambda_over_g[i*n_bounds];
		local_ptr5 = &d_all_theta_search[i*n_bounds];
		for(j = 0; j < n_bounds; j++)
			local_ptr1[j] = -local_ptr5[j]*local_ptr4[j] - local_ptr3[j] - local_ptr2[j];
	}
}
