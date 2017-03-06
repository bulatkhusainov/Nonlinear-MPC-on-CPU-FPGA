% figure out vector interfaces length
% ip interfaces
block_interface = strcat('block:',num2str(N*nnz_block_tril + nnz_term_block_tril),':float');
out_block_interface = strcat('out_block:',num2str((N+1)*n_states),':float');
x_in_interface = strcat('x_in:',num2str(n_linear),':float');
y_out_interface = strcat('y_out:',num2str(n_linear),':float');

% soc interfaces
x_hat_soc_interface = strcat('x_hat:',num2str(n_states),':float');
all_theta_soc_interface = strcat('u_opt:',num2str(n_all_theta),':float'); % assume all optimization variables go here


% delete previous test files
delete('soc_prototype/test/results/my_project0/*.dat');

%ip_design_build('project_name','my_project0', 'input', block_interface, 'input',out_block_interface, 'input', x_in_interface, 'output', y_out_interface);

%ip_design_build_debug('project_name','my_project0');

ip_prototype_build('project_name','my_project0','board_name','zedboard');

%ip_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp');

%ip_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);

soc_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp', 'soc_input',x_hat_soc_interface,'soc_output',all_theta_soc_interface);

%soc_prototype_load_debug('project_name','my_project0','board_name','zedboard');

soc_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);


% read obectives
% performance = sum(importdata('soc_prototype/test/results/my_project0/objective.dat'));
% tmp_vector = (importdata('soc_prototype/test/results/my_project0/fpga_time_log.dat'));
% tmp_vector = tmp_vector.textdata;
% cpu_time = max(str2num([tmp_vector{:}]));
