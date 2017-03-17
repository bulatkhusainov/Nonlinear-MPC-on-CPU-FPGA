%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [y_out_out_int] = foo_user(project_name,minres_data_in_int, block_in_int, out_block_in_int, x_in_in_int)


	% load project configuration parameters: input and output vectors (name, size, type, NUM_TEST, TYPE_TEST)
	load_configuration_parameters(project_name);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% compute with Matlab and save in a file simulation results y_out_out_int
	for i=1:Y_OUT_OUT_LENGTH
		y_out_out_int(i)=0;
		for i_minres_data = 1:MINRES_DATA_IN_LENGTH
			y_out_out_int(i)=y_out_out_int(i) + minres_data_in_int(i_minres_data);
		end
		for i_block = 1:BLOCK_IN_LENGTH
			y_out_out_int(i)=y_out_out_int(i) + block_in_int(i_block);
		end
		for i_out_block = 1:OUT_BLOCK_IN_LENGTH
			y_out_out_int(i)=y_out_out_int(i) + out_block_in_int(i_out_block);
		end
		for i_x_in = 1:X_IN_IN_LENGTH
			y_out_out_int(i)=y_out_out_int(i) + x_in_in_int(i_x_in);
		end
	end

end

