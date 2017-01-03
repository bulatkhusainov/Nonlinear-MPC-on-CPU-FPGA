#include "user_main_header.h"

// this function evaluates node Hessian 
void node_hessian_eval(float node_hessian[n_node_theta][n_node_theta],float node_theta[n_node_theta])
{
	node_hessian[1][1] =   1.0/5.0;
	node_hessian[2][2] =   2.0;
	node_hessian[3][3] =   2.0;
}

// this function evaluates terminal Hessian 
void term_hessian_eval(float term_hessian[n_term_theta][n_term_theta],float term_theta[n_term_theta])
{
	term_hessian[1][1] =   1.0/5.0;
	term_hessian[2][2] =   2.0E1;
}
