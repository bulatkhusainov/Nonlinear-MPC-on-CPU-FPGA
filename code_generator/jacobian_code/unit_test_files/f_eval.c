#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/jacobians.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *f_double, *node_theta_double;
	
	// interface input matrix
	node_theta_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_states*(n_stages+1),1,mxREAL);
	f_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float node_theta[n_node_theta];
	float f[n_states*(n_stages+1)] = {0};

	// input interface loop
	for(i = 0; i < n_node_theta; i++)
	{
		node_theta[i] = (float) node_theta_double[i];
	}

	//call function
	f_eval(f,node_theta);
	
	//output interface loop
	for(i = 0; i < n_states*(n_stages+1); i++)
	{
		f_double[i] = (double) f[i];
	}
}
