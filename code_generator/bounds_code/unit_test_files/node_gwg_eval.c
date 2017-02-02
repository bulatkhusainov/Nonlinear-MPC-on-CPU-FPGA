#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_bounds.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *node_gwg_double, *node_bounds_double, *node_lambda_double;
	
	// interface input matrix 1
	node_bounds_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);

	// interface input matrix 2
	node_lambda_double = mxGetPr(prhs[1]);
	//n = mxGetN(prhs[1]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_states+m_inputs+n_node_slack,1,mxREAL);
	node_gwg_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float node_bounds[n_bounds]; // input 1
	float node_lambda[n_bounds]; // input 2
	float node_gwg[n_states+m_inputs+n_node_slack]; // output

	// input interface loop
	for(i = 0; i < n_bounds; i++)
	{
		node_bounds[i] = (float) node_bounds_double[i];
		node_lambda[i] = (float) node_lambda_double[i];
	}

	//call function
	node_gwg_eval(node_gwg, node_bounds, node_lambda);
	

	//output interface loop
	for(i = 0; i < n_states+m_inputs+n_node_slack; i++)
	{
		node_gwg_double[i] = (double) node_gwg[i];
	}
	    
}
