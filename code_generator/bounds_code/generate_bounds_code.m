%% Generate code for bounds evaluation file
cd ../../src 
fileID = fopen('bounds.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,'// this function evaluates bounds constraints \n');
fprintf(fileID,strcat('void node_bounds_eval('));
fprintf(fileID,strcat(d_type,' node_bounds[n_bounds],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta])\n'));
fprintf(fileID,'{\n');

fprintf(fileID,strcat('\t',variables_declaration_int('1d',upper_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',lower_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',upper_bounds),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',lower_bounds),'\n\n'));

fprintf(fileID,'\tint i, j;\n\n');

fprintf(fileID,'\t//handle upper bounds\n');
fprintf(fileID,'\tfor(i = 0; i < n_upper_bounds; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tnode_bounds[i] = node_theta[upper_bounds_indeces[i]] - upper_bounds[i];\n');
fprintf(fileID,'\t}\n\n');
fprintf(fileID,'\t//handle lower bounds\n');
fprintf(fileID,'\tfor(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tnode_bounds[i] = -node_theta[lower_bounds_indeces[j]] + lower_bounds[j];\n');
fprintf(fileID,'\t}\n');

fprintf(fileID,'}\n\n');



fprintf(fileID,'// this function evaluates node gwg \n');
fprintf(fileID,strcat('void node_gwg_eval('));
fprintf(fileID,strcat(d_type,' node_gwg[n_states+m_inputs+n_node_slack],'));
fprintf(fileID,strcat(d_type,' node_bounds[n_bounds],'));
fprintf(fileID,strcat(d_type,' node_lambda[n_bounds])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t',variables_declaration_int('1d',upper_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',lower_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',upper_bounds),'\n'));
fprintf(fileID,strcat('\t',variables_declaration('1d',lower_bounds),'\n\n'));
fprintf(fileID,'\tint i;\n');
fprintf(fileID,strcat('\t',d_type,' tmp_array[n_bounds];','\n\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_bounds; i++);','\n'));
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\ttmp_array[i] = -node_lambda[i]/node_bounds[i];\n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\t//add node_gwg[] reset\n');

fprintf(fileID,'\t//handle upper bounds\n');
fprintf(fileID,'\tfor(i = 0; i < n_upper_bounds; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tnode_gwg[upper_bounds_indeces[i]] += tmp_array[i];\n');
fprintf(fileID,'\t}\n\n');
fprintf(fileID,'}\n');

fprintf(fileID,'\t//handle lower bounds\n');

fclose(fileID);
cd ../code_generator/bounds_code

if ~debug_mode == 1
    % test "node_bounds_eval" C function
    random_input = 10*rand(1,n_node_theta);
    cd unit_test_files
        mex node_bounds_eval.c
        mex_data = node_bounds_eval(random_input);
       
    cd .. 
    golden_data_upper = random_input(upper_bounds_indeces+1) - upper_bounds;
    golden_data_lower = -random_input(lower_bounds_indeces+1) + lower_bounds;
    golden_data = [golden_data_upper golden_data_lower]';
   
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"node_bounds_eval" C function failed the test');
    else
        disp('"node_bounds_eval" C function passed the test')
    end
    
end

if debug_mode == 1
end