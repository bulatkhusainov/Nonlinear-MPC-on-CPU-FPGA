
%% Generate code for bounds evaluation file
cd ../../src 
fileID = fopen('user_bounds.c','w');
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
fprintf(fileID,strcat('\t',variables_declaration_int('1d',lower_bounds_indeces),'\n\n'));
fprintf(fileID,'\tint i, j;\n');
fprintf(fileID,strcat('\t',d_type,' tmp_array[n_bounds];','\n\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_bounds; i++)','\n'));
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\ttmp_array[i] = -node_lambda[i]/node_bounds[i];\n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\t//reset node_gwg[] \n');
fprintf(fileID,'\tfor(i = 0; i < n_states+m_inputs+n_node_slack; i++) \n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tnode_gwg[i] = 0; \n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\t//handle upper bounds\n');
fprintf(fileID,'\tfor(i = 0; i < n_upper_bounds; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tnode_gwg[upper_bounds_indeces[i]] += tmp_array[i];\n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\t//handle lower bounds\n');
fprintf(fileID,'\tfor(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tnode_gwg[lower_bounds_indeces[j]] += tmp_array[i];\n');
fprintf(fileID,'\t}\n\n');
fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/bounds_code

if test_enable == 1 && n_bounds > 0
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
    
    % test "node_gwg_eval" C function
    random_bounds = 10*rand(1,n_bounds);
    random_lambda = 10*rand(1,n_bounds);
    cd unit_test_files
        mex node_gwg_eval.c
        mex_data = node_gwg_eval(random_bounds,random_lambda);  
    cd .. 
    tmp_array = -random_lambda./random_bounds;
    golden_data_upper = zeros(n_states+m_inputs+n_node_slack,1);
    golden_data_upper(upper_bounds_indeces+1) = tmp_array(1:n_upper_bounds);
    golden_data_lower = zeros(n_states+m_inputs+n_node_slack,1);
    golden_data_lower(lower_bounds_indeces+1) = tmp_array(n_upper_bounds+1:n_bounds);
    golden_data = golden_data_upper + golden_data_lower;
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"node_gwg_eval" C function failed the test');
    else
        disp('"node_gwg_eval" C function passed the test')
    end
    
end