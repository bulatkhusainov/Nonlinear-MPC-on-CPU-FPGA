%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% icl::protoip
% Author: asuardi <https://github.com/asuardi>
% Date: November - 2014
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [v_out_out_int, sc_out_out_int] = foo_user(project_name,init_in_int, sc_in_in_int, block_in_int, out_block_in_int, v_in_in_int)


	% load project configuration parameters: input and output vectors (name, size, type, NUM_TEST, TYPE_TEST)
	load_configuration_parameters(project_name);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% compute with Matlab and save in a file simulation results v_out_out_int
	for i=1:V_OUT_OUT_LENGTH
		v_out_out_int(i)=0;
		for i_init = 1:INIT_IN_LENGTH
			v_out_out_int(i)=v_out_out_int(i) + init_in_int(i_init);
		end
		for i_sc_in = 1:SC_IN_IN_LENGTH
			v_out_out_int(i)=v_out_out_int(i) + sc_in_in_int(i_sc_in);
		end
		for i_block = 1:BLOCK_IN_LENGTH
			v_out_out_int(i)=v_out_out_int(i) + block_in_int(i_block);
		end
		for i_out_block = 1:OUT_BLOCK_IN_LENGTH
			v_out_out_int(i)=v_out_out_int(i) + out_block_in_int(i_out_block);
		end
		for i_v_in = 1:V_IN_IN_LENGTH
			v_out_out_int(i)=v_out_out_int(i) + v_in_in_int(i_v_in);
		end
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% compute with Matlab and save in a file simulation results sc_out_out_int
	for i=1:SC_OUT_OUT_LENGTH
		sc_out_out_int(i)=0;
		for i_init = 1:INIT_IN_LENGTH
			sc_out_out_int(i)=sc_out_out_int(i) + init_in_int(i_init);
		end
		for i_sc_in = 1:SC_IN_IN_LENGTH
			sc_out_out_int(i)=sc_out_out_int(i) + sc_in_in_int(i_sc_in);
		end
		for i_block = 1:BLOCK_IN_LENGTH
			sc_out_out_int(i)=sc_out_out_int(i) + block_in_int(i_block);
		end
		for i_out_block = 1:OUT_BLOCK_IN_LENGTH
			sc_out_out_int(i)=sc_out_out_int(i) + out_block_in_int(i_out_block);
		end
		for i_v_in = 1:V_IN_IN_LENGTH
			sc_out_out_int(i)=sc_out_out_int(i) + v_in_in_int(i_v_in);
		end
	end

end

