#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/residual.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *term_residual_double, *term_theta_double, *term_nu_double, *term_jac_2d_double;
	
	// interface input matrices
	term_theta_double = mxGetPr(prhs[0]);
	term_nu_double = mxGetPr(prhs[1]);
	term_jac_2d_double = mxGetPr(prhs[2]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrices
	plhs[0] = mxCreateDoubleMatrix(n_term_theta+n_term_eq,1,mxREAL);
	term_residual_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float term_residual[n_term_theta+n_term_eq];
	float term_theta[n_term_theta];
	float term_nu[n_term_eq];
	float term_jac_2d[n_term_eq][n_term_theta]={0};

	// input interface loops
	for(i = 0; i < n_term_theta; i++)
		term_theta[i] = (float) term_theta_double[i];
	for(i = 0; i < n_term_eq; i++)
		term_nu[i] = (float) term_nu_double[i];
	k = 0;
	for(i = 0; i < n_term_eq; i++)
	{
		for(j = 0; j < n_term_theta; j++, k++)
			term_jac_2d[i][j] = (float) term_jac_2d_double[k];
	}

	//call function
	term_residual_eval(term_residual, term_theta, term_nu, term_jac_2d);
	

	//output interface loop
	for(i = 0; i < n_term_theta+n_term_eq; i++)
	{
		term_residual_double[i] = (double) term_residual[i];			
	}

    
}
