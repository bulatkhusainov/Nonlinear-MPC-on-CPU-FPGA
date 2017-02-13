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
fprintf(fileID, '#define n_bounds %d  // # of bounds per node \n\n',n_bounds);

fprintf(fileID, '//data for optimization problem \n');
fprintf(fileID, '#define n_all_theta %d  // # of optimization variables \n',n_node_theta*N + n_term_theta);
fprintf(fileID, '#define n_all_nu %d  // # of equality constraints \n',n_node_eq*N + n_term_eq+n_states);
fprintf(fileID, '#define n_all_lambda %d  // # of inequality constraints (assume no inequalities for terminal term) \n',n_bounds*N);
fprintf(fileID, '#define n_linear (%s)  // # of linear system dimension \n\n','n_all_theta+n_all_nu');

fprintf(fileID, '//number of iterations for iterative algorithms \n');
fprintf(fileID, '#define IP_iter %d  // # of interior point iterations \n',IP_iter);
fprintf(fileID, '#define MINRES_iter %s // # of MINRES iterations \n',MINRES_iter);
if MINRES_prescaled
    fprintf(fileID, '#define MINRES_prescaled // # use/do not use prescaler \n\n');
end

fprintf(fileID, '//parallalization related parameters \n');
fprintf(fileID, '#define PAR %d  // # of parallel processors for the main part \n',PAR);
fprintf(fileID, '#define part_size %d  // # partition size in terms nodes \n',part_size);
if rem_partition > 0
fprintf(fileID, '#define rem_partition %d  // # of shooting nodes in the remainder \n',rem_partition);
end
fprintf(fileID, '#define heterogeneity %d  // # degree of heterogeneouty \n\n',heterogeneity);


fprintf(fileID, '#endif');
fclose(fileID);
cd ../code_generator