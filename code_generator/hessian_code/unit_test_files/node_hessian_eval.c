#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_hessians.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *node_hessian_double, *node_theta_double;
	
	// interface input matrix
	node_theta_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_node_theta*n_node_theta,1,mxREAL);
	node_hessian_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float node_theta[n_node_theta];
	float node_hessian[n_node_theta][n_node_theta] = {0};

	// input interface loop
	for(i = 0; i < n_node_theta; i++)
	{
		node_theta[i] = (float) node_theta_double[i];
	}

	//call function
	node_hessian_eval(node_hessian,node_theta);
	

	//output interface loop
	k = 0;
	for(i = 0; i < n_node_theta; i++)
	{
		for(j = 0; j < n_node_theta; j++)
		{
			node_hessian_double[k] = (double) node_hessian[i][j];
			k++;
		}	
	}
	
    
}
