% figure out vector interfaces length
% soc interfaces
x_hat_soc_interface = strcat('x_hat:',num2str(n_states),':float');
all_theta_soc_interface = strcat('u_opt:',num2str(n_all_theta),':float'); % assume all optimization variables go here

 
% delete previous test files
delete('soc_prototype/test/results/my_project0/*.dat');


soc_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp', 'soc_input',x_hat_soc_interface,'soc_output',all_theta_soc_interface);

%soc_prototype_load_debug('project_name','my_project0','board_name','zedboard');

soc_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);


% mkdir(strcat('soc_prototype/test/results/my_project0/PAR_',num2str(PAR)));
% copyfile('soc_prototype/test/results/my_project0/*.dat', strcat('soc_prototype/test/results/my_project0/N_',num2str(N),'_PAR_',num2str(PAR+double(logical(double(rem_partition))))));
% delete('soc_prototype/test/results/my_project0/*.dat');

% read obectives
% performance = sum(importdata('soc_prototype/test/results/my_project0/objective.dat'));
% tmp_vector = (importdata('soc_prototype/test/results/my_project0/fpga_time_log.dat'));
% tmp_vector = tmp_vector.textdata;
% cpu_time = max(str2num([tmp_vector{:}]));
