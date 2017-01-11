#ifndef MAIN_HEADER
#define MAIN_HEADER

#include <math.h>  
#include <stdlib.h>  
#include <stdio.h>  

#define N 30 
#define Ts 5.000000e-01 // sampling frequency 

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

//nnz for nodes 
#define nnz_block_tril 29   
#define nnz_node_hessian_tril 3   
#define nnz_f_jac 25   
#define nnz_gwg 1   

//data for optimization problem 
#define n_all_theta 243  // # of optimization variables 
#define n_all_nu 211  // # of equality constraints 
#define n_all_lambda 60  // # of inequality constraints (assume no inequalities for terminal term) 

#endif