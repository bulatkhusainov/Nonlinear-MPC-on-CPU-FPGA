%% Gradient for one node
node_objective = node_objective_residual.'*node_objective_residual;
node_gradient = gradient(node_objective, node_theta);
node_gradient_func = matlabFunction(node_gradient,'Vars', {node_theta});


%% Gradient for terminal node
term_objective = term_objective_residual.'*term_objective_residual;
term_gradient = gradient(term_objective, term_theta);
term_gradient_func = matlabFunction(term_gradient,'Vars', {term_theta});



%% Generate code for gradient evaluation file
cd ../../src 
fileID = fopen('gradient.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,'// this function evaluates node gradient \n');
fprintf(fileID,strcat('void node_gradient_eval('));
fprintf(fileID,strcat(d_type,' node_gradient[n_node_theta],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_node_theta
    tmp_var = ccode(node_gradient(i));
    tmp_var = regexprep(tmp_var, match_expr, strcat('node_theta[',replace_expr,']'));
    tmp_var = regexprep(tmp_var, 't0 = ', '');
    fprintf(fileID,'\tnode_gradient[%d] = ',i-1);   
    fprintf(fileID,tmp_var); 
    fprintf(fileID,strcat('\n'));
end
fprintf(fileID,'}\n');
fprintf(fileID,'\n');  
fprintf(fileID,'// this function evaluates terminal gradient \n');
fprintf(fileID,strcat('void term_gradient_eval('));
fprintf(fileID,strcat(d_type,' term_gradient[', 'n_term_theta','],'));
fprintf(fileID,strcat(d_type,' term_theta[n_term_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'term_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_term_theta
            tmp_var = ccode(term_gradient(i));
            tmp_var = regexprep(tmp_var, match_expr, strcat('term_theta[',replace_expr,']'));
            tmp_var = regexprep(tmp_var, 't0 = ', '');
            fprintf(fileID,'\tterm_gradient[%d] = ',i-1);   
            fprintf(fileID,tmp_var); 
            fprintf(fileID,strcat('\n'));    
end

fprintf(fileID,strcat('}\n'));
fclose(fileID);
cd ../code_generator/gradient_code


% perform unit test
if test_enable == 1
    % test "node_gradient_eval" C function
    random_input = 100*rand(1,n_node_theta);
    cd unit_test_files
        mex node_gradient_eval.c
        mex_data = node_gradient_eval(random_input);
        mex_data = vec2mat(mex_data, n_node_theta); 
    cd .. 
    golden_data = node_gradient_func(random_input');
    mismatch = abs(golden_data - mex_data');
    if max(mismatch(:)) > test_tol
        error('"node_gradient_eval" C function failed the test');
    else
        disp('"node_gradient_eval" C function passed the test')
    end
    
    % test "term_gradient_eval" C function
    random_input = 100*rand(1,n_term_theta);
    cd unit_test_files
        mex term_gradient_eval.c
        mex_data = term_gradient_eval(random_input);
        mex_data = vec2mat(mex_data, n_term_theta); 
    cd .. 
    golden_data = term_gradient_func(random_input');
    mismatch = abs(golden_data - mex_data');
    if max(mismatch(:)) > test_tol
        error('"term_gradient_eval" C function failed the test');
    else
        disp('"term_gradient_eval" C function passed the test')
    end
end