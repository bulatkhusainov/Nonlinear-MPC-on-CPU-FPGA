#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_nnz_header.h"
#include "../../../src/user_block.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *term_block_double, *term_jac_2d_double, *term_theta_double;
	
	// interface input matrix
	term_theta_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrices
	plhs[0] = mxCreateDoubleMatrix(nnz_term_block_tril,1,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(n_term_eq*n_term_theta,1,mxREAL);
	term_block_double = mxGetPr(plhs[0]);
	term_jac_2d_double = mxGetPr(plhs[1]);

	// local input and output matrices
	float term_block[nnz_term_block_tril];
	float term_jac_2d[n_term_eq][n_term_theta]={0};
	float term_theta[n_term_theta];

	// input interface loops
	for(i = 0; i < n_term_theta; i++)
		term_theta[i] = (float) term_theta_double[i];

	//call function
	term_block_eval(term_block, term_jac_2d, term_theta);
	

	//output interface loop
	for(i = 0; i < nnz_term_block_tril; i++)
		term_block_double[i] = (double) term_block[i];

	k = 0;
	for(i = 0; i < n_term_eq; i++)
	{
		for(j = 0; j < n_term_theta; j++)
		{
			term_jac_2d_double[k] = term_jac_2d[i][j];
			k++;
		}	
	}
	
    
}
