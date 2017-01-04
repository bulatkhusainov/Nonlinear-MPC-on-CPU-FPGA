#include "user_main_header.h"

// this function evaluates node gradient 
void node_gradient_eval(float node_gradient[n_node_theta],float node_theta[n_node_theta])
{
	node_gradient[0] =   0.0;
	node_gradient[1] =   node_theta[2-1]*2.0;
	node_gradient[2] =   node_theta[3-1]*2.0;
	node_gradient[3] =   node_theta[4-1]*2.0-2.0;
	node_gradient[4] =   0.0;
	node_gradient[5] =   0.0;
	node_gradient[6] =   0.0;
	node_gradient[7] =   0.0;
}

// this function evaluates terminal gradient 
void term_gradient_eval(float term_gradient[n_term_theta],float term_theta[n_term_theta])
{
	term_gradient[0] =   0.0;
	term_gradient[1] =   term_theta[2-1]*2.0;
	term_gradient[2] =   term_theta[3-1]*2.0E2-2.0E2;
}