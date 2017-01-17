#include "mex.h"
#include "matrix.h"

#include "../../../src/user_main_header.h"
#include "../../../src/residual.c"



void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
	int i,j,k;
	double *residual_double, *node_theta_double, *node_nu_double, *node_mu_over_g_double,*node_jac_2d_double, *mu_double;
	
	// interface input matrices
	node_theta_double = mxGetPr(prhs[0]);
	node_nu_double = mxGetPr(prhs[1]);
	node_mu_over_g_double = mxGetPr(prhs[2]);
	node_jac_2d_double = mxGetPr(prhs[3]);
	mu_double = mxGetPr(prhs[4]);
	//n = mxGetN(prhs[0]);
	
	// interface output matrices
	plhs[0] = mxCreateDoubleMatrix(n_node_theta+n_node_eq,1,mxREAL);
	residual_double = mxGetPr(plhs[0]);

	// local input and output matrices
	float residual[n_node_theta+n_node_eq];
	float node_theta[n_node_theta];
	float node_nu[n_node_eq];
	float node_mu_over_g[n_bounds];
	float node_jac_2d[n_node_eq][n_node_theta]={0};
	float mu;


	// input interface loops
	for(i = 0; i < n_node_theta; i++)
		node_theta[i] = (float) node_theta_double[i];
	for(i = 0; i < n_node_eq; i++)
		node_nu[i] = (float) node_nu_double[i];
	for(i = 0; i < n_bounds; i++)
		node_mu_over_g[i] = (float) node_mu_over_g_double[i];
	k = 0;
	for(i = 0; i < n_node_eq; i++)
	{
		for(j = 0; j < n_node_theta; j++, k++)
			node_jac_2d[i][j] = (float) node_jac_2d_double[k];
	}
	mu = (float) mu_double[0];
		
	
		

	//call function
	node_residual_eval(residual, node_theta, node_nu, node_mu_over_g, node_jac_2d, mu);
	

	//output interface loop
	for(i = 0; i < n_node_theta+n_node_eq; i++)
	{
		residual_double[i] = (double) residual[i];			
	}

    
}
