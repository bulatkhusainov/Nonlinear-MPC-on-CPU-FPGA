#ifndef MAIN_HEADER
#define MAIN_HEADER

#include <math.h>  
#include <stdlib.h>  
#include <stdio.h>  

#define N 5 
#define Ts 5.000000e-01 // sampling frequency 

//data for shooting node 
#define n_stages     1 // # of integration stages 
#define n_states 2 // # of states 
#define m_inputs 1 // # of inputs 
#define n_node_slack 1 // # of slack variables per node 
#define n_node_slack_eq 1 // # of slack equality constraints per node 
#define n_term_slack 1 // # of slack variables for terminal term 
#define n_term_eq 1  // # of terminal equality constraints 
#define n_node_theta 6  // # of optimization variables 
#define n_term_theta 3  // # of optimization variables for terminal term 
#define n_node_eq 5  // # of equality constraints per node 
#define n_upper_bounds 2  // # of upper bounds per node 
#define n_lower_bounds 2  // # of lower bounds per node 
#define n_bounds 3  // # of bounds per node 

//data for optimization problem 
#define n_all_theta 33  // # of optimization variables 
#define n_all_nu 28  // # of equality constraints 
#define n_all_lambda 15  // # of inequality constraints (assume no inequalities for terminal term) 
#define n_linear (n_all_theta+n_all_nu)  // # of linear system dimension 

//number of iterations for iterative algorithms 
#define IP_iter 1  // # of interior point iterations 
#define MINRES_iter 1000 // # of MINRES iterations 
#define MINRES_prescaler // # use/do not use prescaler 

#endif