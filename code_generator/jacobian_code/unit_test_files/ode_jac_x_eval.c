#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/user_jacobians.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *ode_jac_x_double, *x_u_double;
	
	// interface input matrix
	x_u_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_states*n_states,1,mxREAL);
	ode_jac_x_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float x_u[n_states+ m_inputs];
	float ode_jac_x[n_states][n_states] = {0};

	for(i = 0; i < n_states; i++)
		for(j = 0; j < n_states; j++)
		{
			ode_jac_x[i][j] = 0;	
		}

	// input interface loop
	for(i = 0; i < n_states+m_inputs; i++)
	{
		x_u[i] = (float) x_u_double[i];
	}

	//call function
	ode_jac_x_eval(ode_jac_x,x_u);
	

	//output interface loop
	k = 0;
	for(i = 0; i < n_states; i++)
		for(j = 0; j < n_states; j++)
	{
		ode_jac_x_double[k] = (double) ode_jac_x[i][j];
		k++;
	}
	
    
}
