#include "user_protoip_definer.h"
#include "user_main_header.h"

// Butcher table data
float butcher_table_A[2][2] = {0.0000000000000000,0.0000000000000000,0.5000000000000000,0.5000000000000000,};
float butcher_table_beta[2] = {0.5000000000000000,0.5000000000000000,};

// this function evaluates dynamics ODE
void ode_eval(float x_dot[n_states],float x_u[n_states+m_inputs])
{
	x_dot[0] =   x_u[2-1];
	x_dot[1] =   x_u[2-1]*(-3.1E1/4.0)+x_u[7-1]*(3.1E1/4.0);
	x_dot[2] =   x_u[4-1];
	x_dot[3] =   x_u[4-1]*-1.5E1+x_u[8-1]*1.5E1;
	x_dot[4] =   x_u[6-1];
	x_dot[5] =   -(sin(x_u[5-1])*(9.81E2/1.0E2)-cos(x_u[5-1])*(x_u[2-1]*(3.1E1/4.0)-x_u[7-1]*(3.1E1/4.0))+x_u[4-1]*x_u[6-1]*2.0)/(x_u[3-1]+1.0/2.0);
}

// this function evaluates Jacobian of ODE w.r.t. x
void ode_jac_x_eval(float ode_jac_x[n_states][n_states],float x_u[n_states+m_inputs])
{
	ode_jac_x[0][1] =   1.0;
	ode_jac_x[1][1] =   -3.1E1/4.0;
	ode_jac_x[2][3] =   1.0;
	ode_jac_x[3][3] =   -1.5E1;
	ode_jac_x[4][5] =   1.0;
	ode_jac_x[5][1] =   (cos(x_u[5-1])*(3.1E1/4.0))/(x_u[3-1]+1.0/2.0);
	ode_jac_x[5][2] =   1.0/pow(x_u[3-1]+1.0/2.0,2.0)*(sin(x_u[5-1])*(9.81E2/1.0E2)-cos(x_u[5-1])*(x_u[2-1]*(3.1E1/4.0)-x_u[7-1]*(3.1E1/4.0))+x_u[4-1]*x_u[6-1]*2.0);
	ode_jac_x[5][3] =   (x_u[6-1]*-2.0)/(x_u[3-1]+1.0/2.0);
	ode_jac_x[5][4] =   -(cos(x_u[5-1])*(9.81E2/1.0E2)+sin(x_u[5-1])*(x_u[2-1]*(3.1E1/4.0)-x_u[7-1]*(3.1E1/4.0)))/(x_u[3-1]+1.0/2.0);
	ode_jac_x[5][5] =   (x_u[4-1]*-2.0)/(x_u[3-1]+1.0/2.0);
}

// this function evaluates Jacobian of ODE w.r.t. u
void ode_jac_u_eval(float ode_jac_u[n_states][m_inputs],float x_u[n_states+m_inputs])
{
	ode_jac_u[1][0] =   3.1E1/4.0;
	ode_jac_u[3][1] =   1.5E1;
	ode_jac_u[5][0] =   (cos(x_u[5-1])*(-3.1E1/4.0))/(x_u[3-1]+1.0/2.0);
}

// this function evaluates equality constraints
void f_eval(float f[n_node_eq],float node_theta[n_node_theta])
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

	// slack equalities constraints 
	float *slack_eq_pointer = &f[n_states*(n_stages+1)];// define slack equalities pointer 
	*(slack_eq_pointer+0) =   node_theta[7-1]-node_theta[9-1];
}

// this function evaluates equality constraints jacobian (without x_{k+1})
void f_jac_eval(float f_jac[n_node_eq][n_node_theta],float node_theta[n_node_theta])
{
	f_jac[0][0] =   1.0;
	f_jac[0][9] =   1.0/2.0E1;
	f_jac[0][15] =   1.0/2.0E1;
	f_jac[1][1] =   1.0;
	f_jac[1][10] =   1.0/2.0E1;
	f_jac[1][16] =   1.0/2.0E1;
	f_jac[2][2] =   1.0;
	f_jac[2][11] =   1.0/2.0E1;
	f_jac[2][17] =   1.0/2.0E1;
	f_jac[3][3] =   1.0;
	f_jac[3][12] =   1.0/2.0E1;
	f_jac[3][18] =   1.0/2.0E1;
	f_jac[4][4] =   1.0;
	f_jac[4][13] =   1.0/2.0E1;
	f_jac[4][19] =   1.0/2.0E1;
	f_jac[5][5] =   1.0;
	f_jac[5][14] =   1.0/2.0E1;
	f_jac[5][20] =   1.0/2.0E1;
	f_jac[6][1] =   1.0;
	f_jac[6][9] =   -1.0;
	f_jac[7][1] =   -3.1E1/4.0;
	f_jac[7][6] =   3.1E1/4.0;
	f_jac[7][10] =   -1.0;
	f_jac[8][3] =   1.0;
	f_jac[8][11] =   -1.0;
	f_jac[9][3] =   -1.5E1;
	f_jac[9][7] =   1.5E1;
	f_jac[9][12] =   -1.0;
	f_jac[10][5] =   1.0;
	f_jac[10][13] =   -1.0;
	f_jac[11][1] =   (cos(node_theta[5-1])*(3.1E1/4.0))/(node_theta[3-1]+1.0/2.0);
	f_jac[11][2] =   1.0/pow(node_theta[3-1]+1.0/2.0,2.0)*(sin(node_theta[5-1])*(9.81E2/1.0E2)-cos(node_theta[5-1])*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0))+node_theta[4-1]*node_theta[6-1]*2.0);
	f_jac[11][3] =   (node_theta[6-1]*-2.0)/(node_theta[3-1]+1.0/2.0);
	f_jac[11][4] =   -(cos(node_theta[5-1])*(9.81E2/1.0E2)+sin(node_theta[5-1])*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)))/(node_theta[3-1]+1.0/2.0);
	f_jac[11][5] =   (node_theta[4-1]*-2.0)/(node_theta[3-1]+1.0/2.0);
	f_jac[11][6] =   (cos(node_theta[5-1])*(-3.1E1/4.0))/(node_theta[3-1]+1.0/2.0);
	f_jac[11][14] =   -1.0;
	f_jac[12][1] =   1.0;
	f_jac[12][10] =   1.0/2.0E1;
	f_jac[12][15] =   -1.0;
	f_jac[12][16] =   1.0/2.0E1;
	f_jac[13][1] =   -3.1E1/4.0;
	f_jac[13][6] =   3.1E1/4.0;
	f_jac[13][10] =   -3.1E1/8.0E1;
	f_jac[13][16] =   -1.11E2/8.0E1;
	f_jac[14][3] =   1.0;
	f_jac[14][12] =   1.0/2.0E1;
	f_jac[14][17] =   -1.0;
	f_jac[14][18] =   1.0/2.0E1;
	f_jac[15][3] =   -1.5E1;
	f_jac[15][7] =   1.5E1;
	f_jac[15][12] =   -3.0/4.0;
	f_jac[15][18] =   -7.0/4.0;
	f_jac[16][5] =   1.0;
	f_jac[16][14] =   1.0/2.0E1;
	f_jac[16][19] =   -1.0;
	f_jac[16][20] =   1.0/2.0E1;
	f_jac[17][1] =   (cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(3.1E1/4.0))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][2] =   (sin(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(9.81E2/1.0E2)+(node_theta[4-1]+node_theta[13-1]*(1.0/2.0E1)+node_theta[19-1]*(1.0/2.0E1))*(node_theta[6-1]+node_theta[15-1]*(1.0/2.0E1)+node_theta[21-1]*(1.0/2.0E1))*2.0-cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)+node_theta[11-1]*(3.1E1/8.0E1)+node_theta[17-1]*(3.1E1/8.0E1)))*1.0/pow(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0,2.0);
	f_jac[17][3] =   -(node_theta[6-1]*2.0+node_theta[15-1]*(1.0/1.0E1)+node_theta[21-1]*(1.0/1.0E1))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][4] =   -(cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(9.81E2/1.0E2)+sin(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)+node_theta[11-1]*(3.1E1/8.0E1)+node_theta[17-1]*(3.1E1/8.0E1)))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][5] =   -(node_theta[4-1]*2.0+node_theta[13-1]*(1.0/1.0E1)+node_theta[19-1]*(1.0/1.0E1))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][6] =   (cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(-3.1E1/4.0))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][10] =   (cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(3.1E1/8.0E1))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][11] =   (sin(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(9.81E2/1.0E2)+(node_theta[4-1]+node_theta[13-1]*(1.0/2.0E1)+node_theta[19-1]*(1.0/2.0E1))*(node_theta[6-1]+node_theta[15-1]*(1.0/2.0E1)+node_theta[21-1]*(1.0/2.0E1))*2.0-cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)+node_theta[11-1]*(3.1E1/8.0E1)+node_theta[17-1]*(3.1E1/8.0E1)))*1.0/pow(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0,2.0)*(1.0/2.0E1);
	f_jac[17][12] =   -(node_theta[6-1]*(1.0/1.0E1)+node_theta[15-1]*(1.0/2.0E2)+node_theta[21-1]*(1.0/2.0E2))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][13] =   -(cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*4.905E-1+sin(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)+node_theta[11-1]*(3.1E1/8.0E1)+node_theta[17-1]*(3.1E1/8.0E1))*(1.0/2.0E1))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][14] =   -(node_theta[4-1]*(1.0/1.0E1)+node_theta[13-1]*(1.0/2.0E2)+node_theta[19-1]*(1.0/2.0E2))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][16] =   (cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(3.1E1/8.0E1))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][17] =   (sin(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(9.81E2/1.0E2)+(node_theta[4-1]+node_theta[13-1]*(1.0/2.0E1)+node_theta[19-1]*(1.0/2.0E1))*(node_theta[6-1]+node_theta[15-1]*(1.0/2.0E1)+node_theta[21-1]*(1.0/2.0E1))*2.0-cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)+node_theta[11-1]*(3.1E1/8.0E1)+node_theta[17-1]*(3.1E1/8.0E1)))*1.0/pow(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0,2.0)*(1.0/2.0E1);
	f_jac[17][18] =   -(node_theta[6-1]*(1.0/1.0E1)+node_theta[15-1]*(1.0/2.0E2)+node_theta[21-1]*(1.0/2.0E2))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][19] =   -(cos(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*4.905E-1+sin(node_theta[5-1]+node_theta[14-1]*(1.0/2.0E1)+node_theta[20-1]*(1.0/2.0E1))*(node_theta[2-1]*(3.1E1/4.0)-node_theta[7-1]*(3.1E1/4.0)+node_theta[11-1]*(3.1E1/8.0E1)+node_theta[17-1]*(3.1E1/8.0E1))*(1.0/2.0E1))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0);
	f_jac[17][20] =   -(node_theta[4-1]*(1.0/1.0E1)+node_theta[13-1]*(1.0/2.0E2)+node_theta[19-1]*(1.0/2.0E2))/(node_theta[3-1]+node_theta[12-1]*(1.0/2.0E1)+node_theta[18-1]*(1.0/2.0E1)+1.0/2.0)-1.0;
	f_jac[18][6] =   1.0;
	f_jac[18][8] =   -1.0;
}

// this function evaluates terminal equality constraints function 
void term_f_eval(float term_f[n_term_eq],float term_theta[n_term_theta])
{
	term_f[0] =   term_theta[1-1]-term_theta[7-1];
}

// this function evaluates jacobian of terminal equality constraints function 
void term_f_jac_eval(float term_f_jac[n_term_eq][n_term_theta],float term_theta[n_term_theta])
{
	term_f_jac[0][0] =   1.0;
	term_f_jac[0][6] =   -1.0;
}
