% figure out vector interfaces length
% soc interfaces
x_hat_soc_interface = strcat('x_hat:',num2str(n_states),':float');
all_theta_soc_interface = strcat('u_opt:',num2str(n_all_theta),':float'); % assume all optimization variables go here

 
soc_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp', 'soc_input',x_hat_soc_interface,'soc_output',all_theta_soc_interface);

%soc_prototype_load_debug('project_name','my_project0','board_name','zedboard');

soc_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);
