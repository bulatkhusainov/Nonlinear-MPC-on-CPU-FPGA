#include "mex.h"
#include "matrix.h"

#include "../src/user_main_header.h"
#include "../src/user_nnz_header.h"
#include "../src/user_prototypes_header.h"
#include "../src/user_nlp_solver.c"

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{

	int i,j,k;
	double *debug_output_double, *all_theta_double, *all_nu_double, *all_lambda_double; // output
	double *x_hat_double; // input
	
	// interface input matrices
	x_hat_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrices
	plhs[0] = mxCreateDoubleMatrix(n_all_theta,1,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(n_all_nu,1,mxREAL);
	plhs[2] = mxCreateDoubleMatrix(n_all_lambda,1,mxREAL);
	plhs[3] = mxCreateDoubleMatrix(n_all_theta + n_all_nu,1,mxREAL);
	all_theta_double = mxGetPr(plhs[0]);
	all_nu_double = mxGetPr(plhs[1]);
	all_lambda_double = mxGetPr(plhs[2]);
	debug_output_double = mxGetPr(plhs[3]);

	// local input and output matrices
	float debug_output[n_all_theta + n_all_nu];
	float all_theta[n_all_theta];
	float all_nu[n_all_nu];
	float all_lambda[n_all_lambda];
	float x_hat[n_states];

	// input interface loops
	for(i = 0; i < n_states; i++)
		x_hat[i] = (float) x_hat_double[i];
		

	//call function
	nlp_solver(debug_output, all_theta, all_nu, all_lambda, x_hat);
	

	//output interface loops
	for(i = 0; i < n_all_theta + n_all_nu; i++)
		debug_output_double[i] = (double) debug_output[i];
	for(i = 0; i < n_all_theta; i++)
		all_theta_double[i] = (double) all_theta[i];
	for(i = 0; i < n_all_nu; i++)
		all_nu_double[i] = (double) all_nu[i];
	for(i = 0; i < n_all_lambda; i++)
		all_lambda_double[i] = (double) all_lambda[i];

	
    
}
