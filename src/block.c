#include "user_main_header.h"
#include "user_nnz_header.h"

// functions prototypes 
void node_hessian_eval(float node_hessian[n_node_theta][n_node_theta],float node_theta[n_node_theta]); 
void f_jac_eval(float f_jac[n_node_eq][n_node_theta],float node_theta[n_node_theta]); 

void term_hessian_eval(float term_hessian[n_term_theta][n_term_theta],float term_theta[n_term_theta]);; 
void term_f_jac_eval(float term_f_jac[n_term_eq][n_term_theta],float term_theta[n_term_theta]); 

// this function evaluates node blocks 
void node_block_eval(float block[nnz_block_tril],float node_jac_2d[n_node_eq][n_node_theta],float node_theta[n_node_theta],float node_lambda_over_g[n_bounds])
{
	int i, j, k;
	float node_hessian[n_node_theta][n_node_theta];

	// node Hessian reading info 
	int row_node_hessian_tril[3] = {0,1,3,};
	int col_node_hessian_tril[3] = {0,1,3,};
	int num_node_hessian_tril[3] = {0,8,18,};

	// node Jacobian reading info 
	int row_node_f_jac[44] = {0,2,3,4,5,6,7,1,2,4,6,2,4,6,8,8,0,2,4,5,6,7,1,3,4,6,0,4,5,6,7,1,4,5,6,0,4,5,6,7,1,4,6,7,};
	int col_node_f_jac[44] = {0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,4,4,4,4,4,4,5,5,5,5,6,6,6,6,6,7,7,7,7,8,8,8,8,8,9,9,9,9,};
	int num_node_f_jac[44] = {1,2,3,4,5,6,7,9,10,11,12,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,};

	// node gwg reading info 
	int col_gwg[2] = {1,2,};
	int num_gwg[2] = {8,13,};

	int upper_bounds_indeces[2] = {2,1,};
	int lower_bounds_indeces[2] = {2,1,};

	node_hessian_eval(node_hessian, node_theta);
	f_jac_eval(node_jac_2d, node_theta);

	// read hessian
	for(i = 0; i < nnz_node_hessian_tril; i++)
		block[num_node_hessian_tril[i]] = node_hessian[row_node_hessian_tril[i]][col_node_hessian_tril[i]];

	// read jacobian
	for(i = 0; i < nnz_f_jac; i++)
		block[num_node_f_jac[i]] = node_jac_2d[row_node_f_jac[i]][col_node_f_jac[i]];

	// calculate and read gwg
	float node_gwg[n_node_theta];
	for(i = 0; i < n_states+m_inputs+n_node_slack; i++) // reset node_gwg[]
		node_gwg[i] = 0; 
	for(i = 0; i < n_upper_bounds; i++) //handle upper bounds
		node_gwg[upper_bounds_indeces[i]] -= node_lambda_over_g[i];
	for(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++) //handle lower bounds
		node_gwg[lower_bounds_indeces[j]] -= node_lambda_over_g[i];
	for(i = 0; i < nnz_gwg; i++)
		block[num_gwg[i]] += node_gwg[col_gwg[i]]; // read gwg
}

// this function evaluates the terminal block 
void term_block_eval(float term_block[nnz_term_block_tril],float term_jac_2d[n_term_eq][n_term_theta],float term_theta[n_term_theta])
{
	int i, j, k;
	float term_hessian[n_term_theta][n_term_theta];

	// term Hessian reading info 
	int row_term_hessian_tril[2] = {0,1,};
	int col_term_hessian_tril[2] = {0,1,};
	int num_term_hessian_tril[2] = {0,2,};

	// term Jacobian reading info 
	int row_term_f_jac[2] = {0,0,};
	int col_term_f_jac[2] = {0,2,};
	int num_term_f_jac[2] = {1,3,};

	term_hessian_eval(term_hessian, term_theta);
	term_f_jac_eval(term_jac_2d, term_theta);

	// read term hessian
	for(i = 0; i < nnz_term_hessian_tril; i++)
		term_block[num_term_hessian_tril[i]] = term_hessian[row_term_hessian_tril[i]][col_term_hessian_tril[i]];

	// read term jacobian
	for(i = 0; i < nnz_term_f_jac; i++)
		term_block[num_term_f_jac[i]] = term_jac_2d[row_term_f_jac[i]][col_term_f_jac[i]];

}
