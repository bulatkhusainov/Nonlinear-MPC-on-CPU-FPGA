#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_gradient.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *term_gradient_double, *term_theta_double;
	
	// interface input matrix
	term_theta_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_term_theta,1,mxREAL);
	term_gradient_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float term_theta[n_term_theta];
	float term_gradient[n_term_theta];

	// input interface loop
	for(i = 0; i < n_term_theta; i++)
	{
		term_theta[i] = (float) term_theta_double[i];
	}

	//call function
	term_gradient_eval(term_gradient,term_theta);
	

	//output interface loop
	for(i = 0; i < n_term_theta; i++)
	{
		term_gradient_double[i] = (double) term_gradient[i];
	}
	
    
}
