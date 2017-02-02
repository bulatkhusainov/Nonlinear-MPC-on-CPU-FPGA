#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_nnz_header.h"
#include "../../../src/user_block.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *block_double, *node_jac_2d_double, *node_theta_double, *node_lambda_over_g_double;
	
	// interface input matrices
	node_theta_double = mxGetPr(prhs[0]);
	node_lambda_over_g_double = mxGetPr(prhs[1]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrices
	plhs[0] = mxCreateDoubleMatrix(nnz_block_tril,1,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(n_node_eq*n_node_theta,1,mxREAL);
	block_double = mxGetPr(plhs[0]);
	node_jac_2d_double = mxGetPr(plhs[1]);

	// local input and output matrices
	float block[nnz_block_tril];
	float node_theta[n_node_theta];
	float node_lambda_over_g[n_bounds];
	float node_jac_2d[n_node_eq][n_node_theta]={0};

	// input interface loops
	for(i = 0; i < n_node_theta; i++)
		node_theta[i] = (float) node_theta_double[i];
	for(i = 0; i < n_bounds; i++)
		node_lambda_over_g[i] = (float) node_lambda_over_g_double[i];
		

	//call function
	node_block_eval(block, node_jac_2d, node_theta, node_lambda_over_g);
	

	//output interface loop
	for(i = 0; i < nnz_block_tril; i++)
		block_double[i] = (double) block[i];

	k = 0;
	for(i = 0; i < n_node_eq; i++)
	{
		for(j = 0; j < n_node_theta; j++)
		{
			node_jac_2d_double[k] = node_jac_2d[i][j];
			k++;
		}	
	}



	
    
}
