#include "user_main_header.h"

// this function evaluates node Hessian 
void node_hessian_eval(node_hessian[n_node_theta][n_node_theta],node_theta[n_node_theta])
{
	node_hessian[0][0] =   pow(cos(node_theta[1-1]),2.0)*3.0;
	node_hessian[1][0] =   sqrt(3.0)*cos(node_theta[1-1]);
	node_hessian[1][1] =   5.0;
	node_hessian[2][2] =   5.0;

// this function evaluates terminal Hessian 
void term_hessian_eval(term_hessian[n_term_theta][n_term_theta],term_theta[n_term_theta])
{
	term_hessian[0][0] =   pow(cos(term_theta[1-1]),2.0)*8.0;
	term_hessian[1][1] =   4.0;
}
