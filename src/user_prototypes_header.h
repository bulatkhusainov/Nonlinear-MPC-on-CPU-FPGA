#ifndef PROTOTYPES
#define PROTOTYPES

void node_block_eval(float block[nnz_block_tril],float node_jac_2d[n_node_eq][n_node_theta],float node_theta[n_node_theta],float node_lambda_over_g[n_bounds]);
void term_block_eval(float term_block[nnz_term_block_tril],float term_jac_2d[n_term_eq][n_term_theta],float term_theta[n_term_theta]);
void node_bounds_eval(float node_bounds[n_bounds],float node_theta[n_node_theta]);
void node_gwg_eval(float node_gwg[n_states+m_inputs+n_node_slack],float node_bounds[n_bounds],float node_lambda[n_bounds]);
void node_gradient_eval(float node_gradient[n_node_theta],float node_theta[n_node_theta]);
void term_gradient_eval(float term_gradient[n_term_theta],float term_theta[n_term_theta]);
void node_hessian_eval(float node_hessian[n_node_theta][n_node_theta],float node_theta[n_node_theta]);
void term_hessian_eval(float term_hessian[n_term_theta][n_term_theta],float term_theta[n_term_theta]);
void f_eval(float f[n_node_eq],float node_theta[n_node_theta]);
void f_jac_eval(float f_jac[n_node_eq][n_node_theta],float node_theta[n_node_theta]);
void term_f_eval(float term_f[n_term_eq],float term_theta[n_term_theta]);
void term_f_jac_eval(float term_f_jac[n_term_eq][n_term_theta],float term_theta[n_term_theta]);
void node_residual_eval(float residual[n_node_theta+n_node_eq],float node_theta[n_node_theta],float node_nu[n_node_eq],float node_mu_over_g[n_bounds],float node_jac_2d[n_node_eq][n_node_theta],float mu);
void term_residual_eval(float term_residual[n_term_theta+n_term_eq],float term_theta[n_term_theta],float term_nu[n_term_eq],float term_jac_2d[n_term_eq][n_term_theta]);


#endif