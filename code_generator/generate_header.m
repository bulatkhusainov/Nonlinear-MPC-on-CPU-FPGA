%% Generate main header file
cd ../src 
file_name = strcat('user_main_header','.h');
fileID = fopen(file_name,'w');
fprintf(fileID, strcat('#ifndef ',' MAIN_HEADER\n'));
fprintf(fileID, strcat('#define ',' MAIN_HEADER\n\n'));

fprintf(fileID, '#include <math.h>  \n');
fprintf(fileID, '#include <stdlib.h>  \n');
fprintf(fileID, '#include <stdio.h>  \n\n');

fprintf(fileID, '#define N %d \n',N);
fprintf(fileID, '#define Ts %d // sampling frequency \n\n',Ts);

fprintf(fileID, '//data for shooting node \n');
fprintf(fileID, '#define n_stages     %d // # of integration stages \n', n_stages);
fprintf(fileID, '#define n_states %d // # of states \n',n_states);
fprintf(fileID, '#define m_inputs %d // # of inputs \n',m_inputs);
fprintf(fileID, '#define n_node_slack %d // # of slack variables per node \n', n_node_slack);
fprintf(fileID, '#define n_node_slack_eq %d // # of slack equality constraints per node \n', n_node_slack_eq);
fprintf(fileID, '#define n_term_slack %d // # of slack variables for terminal term \n', n_term_slack);
fprintf(fileID, '#define n_term_eq %d  // # of terminal equality constraints \n',n_term_eq);
fprintf(fileID, '#define n_node_theta %d  // # of optimization variables \n',n_node_theta);
fprintf(fileID, '#define n_term_theta %d  // # of optimization variables for terminal term \n',n_term_theta);
fprintf(fileID, '#define n_node_eq %d  // # of equality constraints per node \n',n_node_eq);
fprintf(fileID, '#define n_upper_bounds %d  // # of upper bounds per node \n',n_upper_bounds);
fprintf(fileID, '#define n_lower_bounds %d  // # of lower bounds per node \n',n_upper_bounds);
fprintf(fileID, '#define n_bounds %d  // # of lower bounds per node \n\n',n_bounds);

fprintf(fileID, '#endif');
fclose(fileID);
cd ../code_generator