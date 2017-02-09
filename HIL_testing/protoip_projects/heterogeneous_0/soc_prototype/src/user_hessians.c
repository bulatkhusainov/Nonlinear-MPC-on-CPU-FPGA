#include "user_main_header.h"

// this function evaluates node Hessian 
void node_hessian_eval(float node_hessian[n_node_theta][n_node_theta],float node_theta[n_node_theta])
{
	node_hessian[0][0] =   1.019619566604595E-2;
	node_hessian[1][1] =   5.098097833022976E1;
	node_hessian[3][3] =   1.019619566604595E-4;
}

// this function evaluates terminal Hessian 
void term_hessian_eval(float term_hessian[n_term_theta][n_term_theta],float term_theta[n_term_theta])
{
	term_hessian[0][0] =   1.0/5.0E1;
	term_hessian[1][1] =   1.0E2;
}
