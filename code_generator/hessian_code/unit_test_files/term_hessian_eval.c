#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/hessians.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *term_hessian_double, *term_theta_double;
	
	// interface input matrix
	term_theta_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_term_theta*n_term_theta,1,mxREAL);
	term_hessian_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float term_theta[n_term_theta];
	float term_hessian[n_term_theta][n_term_theta] = {0};

	// input interface loop
	for(i = 0; i < n_term_theta; i++)
	{
		term_theta[i] = (float) term_theta_double[i];
	}

	//call function
	term_hessian_eval(term_hessian,term_theta);
	

	//output interface loop
	k = 0;
	for(i = 0; i < n_term_theta; i++)
	{
		for(j = 0; j < n_term_theta; j++)
		{
			term_hessian_double[k] = (double) term_hessian[i][j];
			k++;
		}	
	}
	
    
}
