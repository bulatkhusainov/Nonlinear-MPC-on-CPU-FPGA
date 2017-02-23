#ifndef MAIN_HEADER
#define MAIN_HEADER

#include <math.h>  
#include <stdlib.h>  
#include <stdio.h>  

#define N 11 
#define Ts 1.000000e-01 // sampling frequency 

//data for shooting node 
#define n_stages     2 // # of integration stages 
#define n_states 2 // # of states 
#define m_inputs 1 // # of inputs 
#define n_node_slack 1 // # of slack variables per node 
#define n_node_slack_eq 1 // # of slack equality constraints per node 
#define n_term_slack 1 // # of slack variables for terminal term 
#define n_term_eq 1  // # of terminal equality constraints 
#define n_node_theta 8  // # of optimization variables 
#define n_term_theta 3  // # of optimization variables for terminal term 
#define n_node_eq 7  // # of equality constraints per node 
#define n_upper_bounds 1  // # of upper bounds per node 
#define n_lower_bounds 1  // # of lower bounds per node 
#define n_bounds 2  // # of bounds per node 

//data for optimization problem 
#define n_all_theta 91  // # of optimization variables 
#define n_all_nu 80  // # of equality constraints 
#define n_all_lambda 22  // # of inequality constraints (assume no inequalities for terminal term) 
#define n_linear (n_all_theta+n_all_nu)  // # of linear system dimension 

//number of iterations for iterative algorithms 
#define IP_iter 20  // # of interior point iterations 
#define MINRES_iter n_linear // # of MINRES iterations 
#define MINRES_prescaled // # use/do not use prescaler 

//parallalization related parameters 
#define PAR 3  // # of parallel processors for the main part 
#define part_size 3  // # partition size in terms nodes 
#define rem_partition 2  // # of shooting nodes in the remainder 
#define heterogeneity 3  // # degree of heterogeneouty 

#endif