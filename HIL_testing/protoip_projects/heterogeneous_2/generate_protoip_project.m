% figure out vector interfaces lengths
% ip interfaces
init_interface = strcat('init:',num2str(5),':float');
sc_in_interface = strcat('sc_in:',num2str(5),':float');
block_interface = strcat('block:',num2str(5),':float');
out_block_interface = strcat('out_block:',num2str(5),':float');
v_in_interface = strcat('v_in:',num2str(5),':float');
v_out_interface = strcat('v_out:',num2str(5),':float');
sc_out_interface = strcat('sc_out:',num2str(5),':float');

% soc interfaces
x_hat_soc_interface = strcat('x_hat:',num2str(5),':float');
all_theta_soc_interface = strcat('u_opt:',num2str(5),':float'); % assume all optimization variables go here


make_template('type','SOC','project_name','my_project0','input',init_interface,'input',sc_in_interface,'input',block_interface,'input',out_block_interface,'input',v_in_interface,'output',v_out_interface,'output',sc_out_interface,'soc_input',x_hat_soc_interface,'soc_output',all_theta_soc_interface);

%ip_design_build('project_name','my_project0', 'input', block_interface, 'input', out_block_interface,'input', x_in_interface, 'output', y_out_interface);

%ip_design_build_debug('project_name','my_project0');

%ip_prototype_build('project_name','my_project0','board_name','zedboard');

%ip_prototype_build_debug('project_name','my_project0','board_name','zedboard');

%ip_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp');

%ip_prototype_load_debug('project_name','my_project0','board_name','zedboard')

%ip_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);
 
%soc_prototype_load('project_name','my_project0','board_name','zedboard','type_eth','udp', 'soc_input',x_hat_soc_interface,'soc_output',all_theta_soc_interface);

%soc_prototype_load_debug('project_name','my_project0','board_name','zedboard');

%soc_prototype_test('project_name','my_project0','board_name','zedboard','num_test',1);

%ip_design_duplicate('from','my_project0','to','my_project0');

%ip_design_delete('project_name','my_project0');