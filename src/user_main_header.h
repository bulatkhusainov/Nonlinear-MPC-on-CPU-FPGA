#ifndef MAIN_HEADER
#define MAIN_HEADER

#include <math.h>  
#include <stdlib.h>  
#include <stdio.h>  

#define N 5 
#define Ts 1.000000e-01 // sampling frequency 

//data for shooting node 
#define n_states 2 // # of states 
#define m_inputs 1 // # of inputs 
#define n_node_slack 0 // # of slack variables 
#define n_term_slack 0 // # of slack variables for terminal term 
#define n_node_theta 9  // # of optimization variables 
#define n_term_theta 2  // # of optimization variables for terminal term 

#endif