%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Authors: asuardi <https://github.com/asuardi>, bulatkhusainov <https://github.com/bulatkhusainov
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function test_HIL(project_name)


addpath('../../.metadata');
mex FPGAclientMATLAB.c
load_configuration_parameters(project_name)


rng('shuffle');


% name for the crash report
crash_file = strcat('crash_',num2str(rand),'.mat');


%load data
load ../../../../../code_generator/problem_data

% to see if the file is copied
% import casadi
import casadi.*

% define casadi integration parameters
x = SX.sym('x',n_states,1); %state vector
u = SX.sym('u',m_inputs,1); %input vector
% give meaningful names to states and inputs
x_coord     = x(1); % this is copied from proble_data
x_speed     = x(2);
z_coord     = x(3);
z_speed     = x(4);
theta_angle = x(5);
theta_speed = x(6);
input_x     = u(1);
input_z     = u(2);
ode = SX.zeros(1, n_states);
ode(1) = x_speed; % this is copied from problem data
ode(2) = -(1/tau_x)*x_speed + (1/tau_x)*input_x;
ode(3) = z_speed;
ode(4) = -(1/tau_z)*z_speed + (1/tau_z)*input_z;
ode(5) = theta_speed;
ode(6) = (-1/(0.5 + z_coord))*( (-x_speed/(tau_x) + input_x/tau_x)*cos(theta_angle) + g*sin(theta_angle) + 2*z_speed*theta_speed);
x_dot = ode';
% this is copied from problem data
 node_objective_residual = sqrt(Ts)*[ sqrt(10)*(x(1)); 
                                         sqrt(0.001)*(x(2));
                                         sqrt(10)*(x(3));
                                         sqrt(0.001)*(x(4));
                                         sqrt(10)*(x(5));
                                         sqrt(0.01)*(x(6));
                                         sqrt(0.0001)*(u(1));
                                         sqrt(0.0001)*(u(2))]; % least squares format
L = node_objective_residual'*node_objective_residual;
f = Function('f', {x,u},{x_dot},{'x','u'},{'x_dot', 'L'});
dae = struct('x',x,'p',u,'ode',x_dot,'quad',L);
opts = struct('tf',Ts);
F = integrator('F', 'cvodes', dae, opts);

% define initial condition
x_init = [0; 0; 0.3; 0; 0.2; 0]';
soc_x_hat_in=x_init';

for i=1:(N_sim_full+1)
%for i=1:(1) % the last simulation is for remainder, which can be zero
	tmp_disp_str=strcat('Test number ',num2str(i));
	disp(tmp_disp_str)


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% generate random stimulus vector soc_x_hat_in. (-5<=x_hat_in <=5)
	%soc_x_hat_in=rand(1,SOC_X_HAT_IN_LENGTH)*10-5;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%save soc_x_hat_in_log
	if (TYPE_TEST==0)
		filename = strcat('../test/results/', project_name ,'/soc_x_hat_in_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/x_hat_in_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(soc_x_hat_in)
		fprintf(fid, '%2.18f,',soc_x_hat_in(j));
	end
	fprintf(fid, '\n');

	fclose(fid);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% Start Matlab timer
	tic

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% send the stimulus to the FPGA simulation model when IP design test or to FPGA evaluation borad when IP prototype, execute the algorithm and read back the results
	% reset IP
	Packet_type=1; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=1;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% send data to FPGA
	% send soc_x_hat_in
	Packet_type=3; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=soc_x_hat_in;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% start FPGA
	Packet_type=2; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=1;
	data_to_send=0;
	FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);


	% read data from FPGA
	% read fpga_soc_u_opt_out
	Packet_type=4; % 1 for reset, 2 for start, 3 for write to IP vector packet_internal_ID, 4 for read from IP vector packet_internal_ID of size packet_output_size
	packet_internal_ID=0;
	packet_output_size=SOC_U_OPT_OUT_LENGTH;
	data_to_send=0;
	[output_FPGA, time_IP] = FPGAclientMATLAB(data_to_send,Packet_type,packet_internal_ID,packet_output_size);
	fpga_soc_u_opt_out=output_FPGA;
	% Stop Matlab timer
	time_matlab=toc;
	time_communication=time_matlab-time_IP;


	%save fpga_soc_u_opt_out_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../test/results/', project_name ,'/fpga_soc_u_opt_out_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_u_opt_out_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	for j=1:length(fpga_soc_u_opt_out)
		fprintf(fid, '%2.18f,',fpga_soc_u_opt_out(j));
	end
	fprintf(fid, '\n');

	fclose(fid);
    
   
    % ode integration 
    try
        if i == (N_sim_full+1)
             % for the remainder simulation could be shorter
            opts = struct('tf',Tsim_last);
            F = integrator('F', 'cvodes', dae, opts);

        end
        u_opt = fpga_soc_u_opt_out(n_states + (1:m_inputs));
        Fk = F('x0',soc_x_hat_in','p',u_opt);
        soc_x_hat_in = (full(Fk.xf))';
        cost_simulated = full(Fk.qf); 
    catch
        save(crash_file);
        soc_x_hat_in = zeros(1, n_states);
        cost_simulated = 1e10;      
    end
    
    
    %save objective
	if (TYPE_TEST==0)
		filename = strcat('../test/results/', project_name ,'/objective.dat');
	else
		%filename = strcat('../test/results/', project_name ,'/fpga_time_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	fprintf(fid, '%2.18f, \n', cost_simulated);

	fclose(fid);


       
    
	%save fpga_time_log.dat
	if (TYPE_TEST==0)
		filename = strcat('../test/results/', project_name ,'/fpga_time_log.dat');
	else
		filename = strcat('../test/results/', project_name ,'/fpga_time_log.dat');
	end
	fid = fopen(filename, 'a+');
   
	fprintf(fid, '%2.18f, %2.18f \n',time_IP, time_communication);

	fclose(fid);


	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% compute with Matlab and save in a file simulation results
%	[matlab_u_opt_out] = foo_user(project_name,block_in, x_in_in);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%write a dummy file to tell tcl script to continue with the execution

filename = strcat('_locked');
fid = fopen(filename, 'w');
fprintf(fid, 'locked write\n');
fclose(fid);

if strcmp(TYPE_DESIGN_FLOW,'vivado')
	quit;
end

end
