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
	int num_node_hessian_tril[3] = {0,4,10,};

	// node Jacobian reading info 
	int row_node_f_jac[12] = {0,2,3,1,2,2,4,4,0,2,1,3,};
	int col_node_f_jac[12] = {0,0,0,1,1,2,2,3,4,4,5,5,};
	int num_node_f_jac[12] = {1,2,3,5,6,8,9,11,12,13,14,15,};

	// node gwg reading info 
	int col_gwg[2] = {1,2,};
	int num_gwg[2] = {4,7,};

	int upper_bounds_indeces[2] = {1,2,};
	int lower_bounds_indeces[1] = {2,};

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
