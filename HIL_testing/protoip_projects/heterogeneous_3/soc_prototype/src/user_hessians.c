#include "user_protoip_definer.h"
#include "user_main_header.h"

// this function evaluates node Hessian 
void node_hessian_eval(float node_hessian[n_node_theta][n_node_theta],float node_theta[n_node_theta])
{
	node_hessian[0][0] =   1.0/5.0;
	node_hessian[2][0] =   sin(node_theta[5-1])*(1.0/5.0);
	node_hessian[2][2] =   pow(cos(node_theta[5-1]),2.0)*(1.0/5.0)+pow(sin(node_theta[5-1]),2.0)*(1.0/5.0);
	node_hessian[4][0] =   cos(node_theta[5-1])*(node_theta[3-1]+1.0/2.0)*(1.0/5.0);
	node_hessian[4][4] =   pow(cos(node_theta[5-1]),2.0)*pow(node_theta[3-1]+1.0/2.0,2.0)*(1.0/5.0)+pow(sin(node_theta[5-1]),2.0)*pow(node_theta[3-1]+1.0/2.0,2.0)*(1.0/5.0);
	node_hessian[5][5] =   1.0/5.0;
	node_hessian[6][6] =   2.0E-4;
	node_hessian[7][7] =   2.0E-4;
}

// this function evaluates terminal Hessian 
void term_hessian_eval(float term_hessian[n_term_theta][n_term_theta],float term_theta[n_term_theta])
{
	term_hessian[0][0] =   2.0;
	term_hessian[2][0] =   sin(term_theta[5-1])*2.0;
	term_hessian[2][2] =   pow(cos(term_theta[5-1]),2.0)*2.0+pow(sin(term_theta[5-1]),2.0)*2.0;
	term_hessian[4][0] =   cos(term_theta[5-1])*(term_theta[3-1]+1.0/2.0)*2.0;
	term_hessian[4][4] =   pow(cos(term_theta[5-1]),2.0)*pow(term_theta[3-1]+1.0/2.0,2.0)*2.0+pow(sin(term_theta[5-1]),2.0)*pow(term_theta[3-1]+1.0/2.0,2.0)*2.0;
	term_hessian[5][5] =   2.0;
}
