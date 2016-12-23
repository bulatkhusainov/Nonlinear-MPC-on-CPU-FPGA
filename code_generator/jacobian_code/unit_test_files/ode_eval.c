#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/jacobians.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *x_dot_double, *x_u_double;
	
	// interface input matrix
	x_u_double = mxGetPr(prhs[0]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrix
	plhs[0] = mxCreateDoubleMatrix(n_states,1,mxREAL);
	x_dot_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float x_u[n_states+ m_inputs];
	float x_dot[n_states] = {0};

	// input interface loop
	for(i = 0; i < n_states+m_inputs; i++)
	{
		x_u[i] = (float) x_u_double[i];
	}

	//call function
	ode_eval(x_dot,x_u);
	

	//output interface loop
	k = 0;
	for(i = 0; i < n_states; i++)
	{
		x_dot_double[i] = (double) x_dot[i];
		//x_dot_double[i] = (double) 5;
	}
	
    
}
