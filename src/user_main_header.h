#ifndef MAIN_HEADER
#define MAIN_HEADER

#include <math.h>  
#include <stdlib.h>  
#include <stdio.h>  

#define N 50 
#define Ts 1 // sampling frequency 

//data for shooting node 
#define n_states 2 // # of states 
#define m_inputs 1 // # of inputs 
#define n_node_slack 1 // # of slack variables 
#define n_term_slack 1 // # of slack variables for terminal term 
#define n_stages     2 // # of integration stages 
#define n_node_theta 8  // # of optimization variables 
#define n_term_theta 3  // # of optimization variables for terminal term 
#define n_node_eq 7  // # of equality constraints 
#define n_term_eq 1  // # of terminal equality constraints 

#endif