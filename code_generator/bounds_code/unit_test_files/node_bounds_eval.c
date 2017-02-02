#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_bounds.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *node_bounds_double, *node_theta_double;
	
	// interface input matrix
	node_theta_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_bounds,1,mxREAL);
	node_bounds_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float node_theta[n_node_theta];
	float node_bounds[n_bounds];

	// input interface loop
	for(i = 0; i < n_node_theta; i++)
	{
		node_theta[i] = (float) node_theta_double[i];
	}

	//call function
	node_bounds_eval(node_bounds,node_theta);
	

	//output interface loop
	for(i = 0; i < n_bounds; i++)
	{
		node_bounds_double[i] = (double) node_bounds[i];
	}
	
    
}
