#include "user_main_header.h"

// Butcher table data
float butcher_table_A[3][3] = {0.0000000000000000,0.0000000000000000,0.0000000000000000,0.2083333333333333,0.3333333333333333,-0.0416666666666667,0.1666666666666667,0.6666666666666666,0.1666666666666667,};
float butcher_table_beta[3] = {0.1666666666666667,0.6666666666666666,0.1666666666666667,};

// this function evaluates dynamics ODE
void ode_eval(float x_dot[n_states],float x_u[n_states+m_inputs])
{
	x_dot[0] =   x_u[2-1];
	x_dot[1] =   x_u[3-1]+(x_u[1-1]*x_u[1-1])*2.0+x_u[2-1]*x_u[2-1];
}

// this function evaluates Jacobian of ODE w.r.t. x
void ode_jac_x_eval(float ode_jac_x[n_states][n_states],float x_u[n_states+m_inputs])
{
	ode_jac_x[0][0] =   0.0;
	ode_jac_x[0][1] =   1.0;
	ode_jac_x[1][0] =   x_u[1-1]*4.0;
	ode_jac_x[1][1] =   x_u[2-1]*2.0;
}

// this function evaluates Jacobian of ODE w.r.t. u
void ode_jac_u_eval(float ode_jac_u[n_states][m_inputs],float x_u[n_states+m_inputs])
{
	ode_jac_u[0][0] =   0.0;
	ode_jac_u[1][0] =   1.0;
}

// this function evaluates equality constraints
void f_eval(float f[n_states*(n_stages+1)],float node_theta[n_node_theta])
{
	int i, j, k;
	int offset_node_theta, offset_f;
	// trajectory continuity constraint
	for(i = 0; i < n_states; i++)
	{
		f[i] = node_theta[i];
	}

	for(i = 0; i < n_states; i++)
	{
		offset_node_theta = n_states + m_inputs + n_node_slack + i;
		for(j = 0; j < n_stages; j++)
		{
			f[i] += Ts*butcher_table_beta[j]*node_theta[offset_node_theta + j*n_states];
		}
	}

	// integration stages constaints
	for(i = 0; i < n_stages; i++)
	{
		offset_f = n_states + i*n_states;
	
		// calculate local "x_u"
		float local_x_u[n_states+m_inputs];
		for(j = 0; j < n_states; j++)
		{
			local_x_u[j] = node_theta[j];
			offset_node_theta = n_states + m_inputs + n_node_slack+ j;
			for(k = 0; k < n_stages; k++)
			{
				local_x_u[j] += Ts*butcher_table_A[i][k]*node_theta[offset_node_theta+k*n_states];
			}
		}
		for(j = n_states; j < n_states+m_inputs; j++)
		{
			local_x_u[j] = node_theta[j];
		}

		// calculate local "x_dot"
		float local_x_dot[n_states];
		ode_eval(local_x_dot, local_x_u);

		// final result
		offset_node_theta = n_states + m_inputs + n_node_slack + i*n_states;
		for(j = 0; j < n_states; j++)
		{
			f[offset_f+j] = -node_theta[offset_node_theta+j] + local_x_dot[j];
		}
	}
}

// this function evaluates equality constraints jacobian (without x_{k+1})
void f_jac_eval(float f_jac[n_states*(n_stages+1)][n_node_theta],float node_theta[n_node_theta])
{
	f_jac[0][0] =   1.0;
	f_jac[0][1] =   0.0;
	f_jac[0][2] =   0.0;
	f_jac[0][3] =   1.0/6.0E1;
	f_jac[0][4] =   0.0;
	f_jac[0][5] =   1.0/1.5E1;
	f_jac[0][6] =   0.0;
	f_jac[0][7] =   1.0/6.0E1;
	f_jac[0][8] =   0.0;
	f_jac[1][0] =   0.0;
	f_jac[1][1] =   1.0;
	f_jac[1][2] =   0.0;
	f_jac[1][3] =   0.0;
	f_jac[1][4] =   1.0/6.0E1;
	f_jac[1][5] =   0.0;
	f_jac[1][6] =   1.0/1.5E1;
	f_jac[1][7] =   0.0;
	f_jac[1][8] =   1.0/6.0E1;
	f_jac[2][0] =   0.0;
	f_jac[2][1] =   1.0;
	f_jac[2][2] =   0.0;
	f_jac[2][3] =   -1.0;
	f_jac[2][4] =   0.0;
	f_jac[2][5] =   0.0;
	f_jac[2][6] =   0.0;
	f_jac[2][7] =   0.0;
	f_jac[2][8] =   0.0;
	f_jac[3][0] =   node_theta[1-1]*4.0;
	f_jac[3][1] =   node_theta[2-1]*2.0;
	f_jac[3][2] =   1.0;
	f_jac[3][3] =   0.0;
	f_jac[3][4] =   -1.0;
	f_jac[3][5] =   0.0;
	f_jac[3][6] =   0.0;
	f_jac[3][7] =   0.0;
	f_jac[3][8] =   0.0;
	f_jac[4][0] =   0.0;
	f_jac[4][1] =   1.0;
	f_jac[4][2] =   0.0;
	f_jac[4][3] =   0.0;
	f_jac[4][4] =   1.0/4.8E1;
	f_jac[4][5] =   -1.0;
	f_jac[4][6] =   1.0/3.0E1;
	f_jac[4][7] =   0.0;
	f_jac[4][8] =   -1.0/2.4E2;
	f_jac[5][0] =   node_theta[1-1]*4.0+node_theta[4-1]*(1.0/1.2E1)+node_theta[6-1]*(2.0/1.5E1)-node_theta[8-1]*(1.0/6.0E1);
	f_jac[5][1] =   node_theta[2-1]*2.0+node_theta[5-1]*(1.0/2.4E1)+node_theta[7-1]*(1.0/1.5E1)-node_theta[9-1]*(1.0/1.2E2);
	f_jac[5][2] =   1.0;
	f_jac[5][3] =   node_theta[1-1]*(1.0/1.2E1)+node_theta[4-1]*(1.0/5.76E2)+node_theta[6-1]*(1.0/3.6E2)-node_theta[8-1]*3.472222222222222E-4;
	f_jac[5][4] =   node_theta[2-1]*(1.0/2.4E1)+node_theta[5-1]*8.680555555555556E-4+node_theta[7-1]*(1.0/7.2E2)-node_theta[9-1]*1.736111111111111E-4;
	f_jac[5][5] =   node_theta[1-1]*(2.0/1.5E1)+node_theta[4-1]*(1.0/3.6E2)+node_theta[6-1]*(1.0/2.25E2)-node_theta[8-1]*5.555555555555556E-4;
	f_jac[5][6] =   node_theta[2-1]*(1.0/1.5E1)+node_theta[5-1]*(1.0/7.2E2)+node_theta[7-1]*(1.0/4.5E2)-node_theta[9-1]*2.777777777777778E-4-1.0;
	f_jac[5][7] =   node_theta[1-1]*(-1.0/6.0E1)-node_theta[4-1]*3.472222222222222E-4-node_theta[6-1]*5.555555555555556E-4+node_theta[8-1]*6.944444444444444E-5;
	f_jac[5][8] =   node_theta[2-1]*(-1.0/1.2E2)-node_theta[5-1]*1.736111111111111E-4-node_theta[7-1]*2.777777777777778E-4+node_theta[9-1]*3.472222222222222E-5;
	f_jac[6][0] =   0.0;
	f_jac[6][1] =   1.0;
	f_jac[6][2] =   0.0;
	f_jac[6][3] =   0.0;
	f_jac[6][4] =   1.0/6.0E1;
	f_jac[6][5] =   0.0;
	f_jac[6][6] =   1.0/1.5E1;
	f_jac[6][7] =   -1.0;
	f_jac[6][8] =   1.0/6.0E1;
	f_jac[7][0] =   node_theta[1-1]*4.0+node_theta[4-1]*(1.0/1.5E1)+node_theta[6-1]*(4.0/1.5E1)+node_theta[8-1]*(1.0/1.5E1);
	f_jac[7][1] =   node_theta[2-1]*2.0+node_theta[5-1]*(1.0/3.0E1)+node_theta[7-1]*(2.0/1.5E1)+node_theta[9-1]*(1.0/3.0E1);
	f_jac[7][2] =   1.0;
	f_jac[7][3] =   node_theta[1-1]*(1.0/1.5E1)+node_theta[4-1]*(1.0/9.0E2)+node_theta[6-1]*(1.0/2.25E2)+node_theta[8-1]*(1.0/9.0E2);
	f_jac[7][4] =   node_theta[2-1]*(1.0/3.0E1)+node_theta[5-1]*5.555555555555556E-4+node_theta[7-1]*(1.0/4.5E2)+node_theta[9-1]*5.555555555555556E-4;
	f_jac[7][5] =   node_theta[1-1]*(4.0/1.5E1)+node_theta[4-1]*(1.0/2.25E2)+node_theta[6-1]*(4.0/2.25E2)+node_theta[8-1]*(1.0/2.25E2);
	f_jac[7][6] =   node_theta[2-1]*(2.0/1.5E1)+node_theta[5-1]*(1.0/4.5E2)+node_theta[7-1]*(2.0/2.25E2)+node_theta[9-1]*(1.0/4.5E2);
	f_jac[7][7] =   node_theta[1-1]*(1.0/1.5E1)+node_theta[4-1]*(1.0/9.0E2)+node_theta[6-1]*(1.0/2.25E2)+node_theta[8-1]*(1.0/9.0E2);
	f_jac[7][8] =   node_theta[2-1]*(1.0/3.0E1)+node_theta[5-1]*5.555555555555556E-4+node_theta[7-1]*(1.0/4.5E2)+node_theta[9-1]*5.555555555555556E-4-1.0;
}
