#include "user_main_header.h"

// Butcher table data
float butcher_table_A[3][3] = {0.0000000000000000,0.0000000000000000,0.0000000000000000,0.2083333333333333,0.3333333333333333,-0.0416666666666667,0.1666666666666667,0.6666666666666666,0.1666666666666667,};
float butcher_table_beta[3] = {0.1666666666666667,0.6666666666666666,0.1666666666666667,};

// this function evaluates dynamics ODE
void ode_eval(float x_dot[n_states],float x_u[n_states+m_inputs])
{
	x_dot[0] =   -x_u[2-1]+x_u[3-1]-x_u[1-1]*(x_u[2-1]*x_u[2-1]-1.0);
	x_dot[1] =   x_u[1-1]*(1.0/5.0E1);
}

// this function evaluates Jacobian of ODE w.r.t. x
void ode_jac_x_eval(float ode_jac_x[n_states][n_states],float x_u[n_states+m_inputs])
{
	ode_jac_x[0][0] =   -x_u[2-1]*x_u[2-1]+1.0;
	ode_jac_x[0][1] =   x_u[1-1]*x_u[2-1]*-2.0-1.0;
	ode_jac_x[1][0] =   1.0/5.0E1;
	ode_jac_x[1][1] =   0.0;
}

// this function evaluates Jacobian of ODE w.r.t. u
void ode_jac_u_eval(float ode_jac_u[n_states][m_inputs],float x_u[n_states+m_inputs])
{
	ode_jac_u[0][0] =   1.0;
	ode_jac_u[1][0] =   0.0;
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
	*(slack_eq_pointer+0) =   node_theta[3-1]-node_theta[4-1];
}

// this function evaluates equality constraints jacobian (without x_{k+1})
void f_jac_eval(float f_jac[n_node_eq][n_node_theta],float node_theta[n_node_theta])
{
	f_jac[0][0] =   1.0;
	f_jac[0][1] =   0.0;
	f_jac[0][2] =   0.0;
	f_jac[0][3] =   0.0;
	f_jac[0][4] =   8.496829721704961E-2;
	f_jac[0][5] =   0.0;
	f_jac[0][6] =   3.398731888681984E-1;
	f_jac[0][7] =   0.0;
	f_jac[0][8] =   8.496829721704961E-2;
	f_jac[0][9] =   0.0;
	f_jac[1][0] =   0.0;
	f_jac[1][1] =   1.0;
	f_jac[1][2] =   0.0;
	f_jac[1][3] =   0.0;
	f_jac[1][4] =   0.0;
	f_jac[1][5] =   8.496829721704961E-2;
	f_jac[1][6] =   0.0;
	f_jac[1][7] =   3.398731888681984E-1;
	f_jac[1][8] =   0.0;
	f_jac[1][9] =   8.496829721704961E-2;
	f_jac[2][0] =   -node_theta[2-1]*node_theta[2-1]+1.0;
	f_jac[2][1] =   node_theta[1-1]*node_theta[2-1]*-2.0-1.0;
	f_jac[2][2] =   1.0;
	f_jac[2][3] =   0.0;
	f_jac[2][4] =   -1.0;
	f_jac[2][5] =   0.0;
	f_jac[2][6] =   0.0;
	f_jac[2][7] =   0.0;
	f_jac[2][8] =   0.0;
	f_jac[2][9] =   0.0;
	f_jac[3][0] =   1.0/5.0E1;
	f_jac[3][1] =   0.0;
	f_jac[3][2] =   0.0;
	f_jac[3][3] =   0.0;
	f_jac[3][4] =   0.0;
	f_jac[3][5] =   -1.0;
	f_jac[3][6] =   0.0;
	f_jac[3][7] =   0.0;
	f_jac[3][8] =   0.0;
	f_jac[3][9] =   0.0;
	f_jac[4][0] =   -pow(node_theta[2-1]+node_theta[6-1]*1.06210371521312E-1+node_theta[8-1]*1.699365944340992E-1-node_theta[10-1]*2.12420743042624E-2,2.0)+1.0;
	f_jac[4][1] =   -(node_theta[1-1]+node_theta[5-1]*1.06210371521312E-1+node_theta[7-1]*1.699365944340992E-1-node_theta[9-1]*2.12420743042624E-2)*(node_theta[2-1]*2.0+node_theta[6-1]*2.12420743042624E-1+node_theta[8-1]*3.398731888681984E-1-node_theta[10-1]*4.24841486085248E-2)-1.0;
	f_jac[4][2] =   1.0;
	f_jac[4][3] =   0.0;
	f_jac[4][4] =   pow(node_theta[2-1]+node_theta[6-1]*1.06210371521312E-1+node_theta[8-1]*1.699365944340992E-1-node_theta[10-1]*2.12420743042624E-2,2.0)*(-1.06210371521312E-1)+1.06210371521312E-1;
	f_jac[4][5] =   -(node_theta[1-1]+node_theta[5-1]*1.06210371521312E-1+node_theta[7-1]*1.699365944340992E-1-node_theta[9-1]*2.12420743042624E-2)*(node_theta[2-1]*2.12420743042624E-1+node_theta[6-1]*2.256128603739025E-2+node_theta[8-1]*3.60980576598244E-2-node_theta[10-1]*4.51225720747805E-3)-1.06210371521312E-1;
	f_jac[4][6] =   pow(node_theta[2-1]+node_theta[6-1]*1.06210371521312E-1+node_theta[8-1]*1.699365944340992E-1-node_theta[10-1]*2.12420743042624E-2,2.0)*(-1.699365944340992E-1)-8.300634055659008E-1;
	f_jac[4][7] =   -(node_theta[1-1]+node_theta[5-1]*1.06210371521312E-1+node_theta[7-1]*1.699365944340992E-1-node_theta[9-1]*2.12420743042624E-2)*(node_theta[2-1]*3.398731888681984E-1+node_theta[6-1]*3.60980576598244E-2+node_theta[8-1]*5.775689225571903E-2-node_theta[10-1]*7.219611531964879E-3)-1.699365944340992E-1;
	f_jac[4][8] =   pow(node_theta[2-1]+node_theta[6-1]*1.06210371521312E-1+node_theta[8-1]*1.699365944340992E-1-node_theta[10-1]*2.12420743042624E-2,2.0)*2.12420743042624E-2-2.12420743042624E-2;
	f_jac[4][9] =   (node_theta[1-1]+node_theta[5-1]*1.06210371521312E-1+node_theta[7-1]*1.699365944340992E-1-node_theta[9-1]*2.12420743042624E-2)*(node_theta[2-1]*4.24841486085248E-2+node_theta[6-1]*4.51225720747805E-3+node_theta[8-1]*7.219611531964879E-3-node_theta[10-1]*9.024514414956098E-4)+2.12420743042624E-2;
	f_jac[5][0] =   1.0/5.0E1;
	f_jac[5][1] =   0.0;
	f_jac[5][2] =   0.0;
	f_jac[5][3] =   0.0;
	f_jac[5][4] =   2.12420743042624E-3;
	f_jac[5][5] =   0.0;
	f_jac[5][6] =   3.398731888681984E-3;
	f_jac[5][7] =   -1.0;
	f_jac[5][8] =   -4.24841486085248E-4;
	f_jac[5][9] =   0.0;
	f_jac[6][0] =   -pow(node_theta[2-1]+node_theta[6-1]*8.49682972170496E-2+node_theta[8-1]*3.398731888681984E-1+node_theta[10-1]*8.49682972170496E-2,2.0)+1.0;
	f_jac[6][1] =   -(node_theta[1-1]+node_theta[5-1]*8.49682972170496E-2+node_theta[7-1]*3.398731888681984E-1+node_theta[9-1]*8.49682972170496E-2)*(node_theta[2-1]*2.0+node_theta[6-1]*1.699365944340992E-1+node_theta[8-1]*6.797463777363968E-1+node_theta[10-1]*1.699365944340992E-1)-1.0;
	f_jac[6][2] =   1.0;
	f_jac[6][3] =   0.0;
	f_jac[6][4] =   pow(node_theta[2-1]+node_theta[6-1]*8.49682972170496E-2+node_theta[8-1]*3.398731888681984E-1+node_theta[10-1]*8.49682972170496E-2,2.0)*(-8.49682972170496E-2)+8.49682972170496E-2;
	f_jac[6][5] =   -(node_theta[1-1]+node_theta[5-1]*8.49682972170496E-2+node_theta[7-1]*3.398731888681984E-1+node_theta[9-1]*8.49682972170496E-2)*(node_theta[2-1]*1.699365944340992E-1+node_theta[6-1]*1.443922306392976E-2+node_theta[8-1]*5.775689225571903E-2+node_theta[10-1]*1.443922306392976E-2)-8.49682972170496E-2;
	f_jac[6][6] =   pow(node_theta[2-1]+node_theta[6-1]*8.49682972170496E-2+node_theta[8-1]*3.398731888681984E-1+node_theta[10-1]*8.49682972170496E-2,2.0)*(-3.398731888681984E-1)+3.398731888681984E-1;
	f_jac[6][7] =   -(node_theta[1-1]+node_theta[5-1]*8.49682972170496E-2+node_theta[7-1]*3.398731888681984E-1+node_theta[9-1]*8.49682972170496E-2)*(node_theta[2-1]*6.797463777363968E-1+node_theta[6-1]*5.775689225571903E-2+node_theta[8-1]*2.310275690228761E-1+node_theta[10-1]*5.775689225571903E-2)-3.398731888681984E-1;
	f_jac[6][8] =   pow(node_theta[2-1]+node_theta[6-1]*8.49682972170496E-2+node_theta[8-1]*3.398731888681984E-1+node_theta[10-1]*8.49682972170496E-2,2.0)*(-8.49682972170496E-2)-9.150317027829504E-1;
	f_jac[6][9] =   -(node_theta[1-1]+node_theta[5-1]*8.49682972170496E-2+node_theta[7-1]*3.398731888681984E-1+node_theta[9-1]*8.49682972170496E-2)*(node_theta[2-1]*1.699365944340992E-1+node_theta[6-1]*1.443922306392976E-2+node_theta[8-1]*5.775689225571903E-2+node_theta[10-1]*1.443922306392976E-2)-8.49682972170496E-2;
	f_jac[7][0] =   1.0/5.0E1;
	f_jac[7][1] =   0.0;
	f_jac[7][2] =   0.0;
	f_jac[7][3] =   0.0;
	f_jac[7][4] =   1.699365944340992E-3;
	f_jac[7][5] =   0.0;
	f_jac[7][6] =   6.797463777363968E-3;
	f_jac[7][7] =   0.0;
	f_jac[7][8] =   1.699365944340992E-3;
	f_jac[7][9] =   -1.0;
	f_jac[8][0] =   0.0;
	f_jac[8][1] =   0.0;
	f_jac[8][2] =   1.0;
	f_jac[8][3] =   -1.0;
	f_jac[8][4] =   0.0;
	f_jac[8][5] =   0.0;
	f_jac[8][6] =   0.0;
	f_jac[8][7] =   0.0;
	f_jac[8][8] =   0.0;
	f_jac[8][9] =   0.0;
}

// this function evaluates terminal equality constraints function 
void term_f_eval(float term_f[n_term_eq],float term_theta[n_term_theta])
{
	term_f[0] =   term_theta[1-1]-term_theta[3-1];
}

// this function evaluates jacobian of terminal equality constraints function 
void term_f_jac_eval(float term_f_jac[n_term_eq][n_term_theta],float term_theta[n_term_theta])
{
	term_f_jac[0][0] =   1.0;
	term_f_jac[0][1] =   0.0;
	term_f_jac[0][2] =   -1.0;
}