%% Hessian approximation for one node
% approximate Hessian with Gauss newton algorithm
node_jac_objective = jacobian(node_objective_residual,node_theta);
node_hessian = 2*(node_jac_objective.'*node_jac_objective);
node_hessian_func = matlabFunction(node_hessian,'Vars', {node_theta});
% determine hessian sparsity pattern
node_hessian_pattern = ones(n_node_theta);
for i = 1:n_node_theta
    for j = 1:n_node_theta
        if isequaln(node_hessian(i,j),0)
            node_hessian_pattern(i,j) = 0;
        end
    end
end

%% Hessian approximation for terminal node
% approximate Jacobian with Gauss newton algorithm
term_jac_objective = jacobian(term_objective_residual,term_theta);
term_hessian = 2*(term_jac_objective.'*term_jac_objective);
term_hessian_func = matlabFunction(term_hessian,'Vars', {term_theta});
% determine terminal hessian sparsity pattern
term_hessian_pattern = ones(n_term_theta);
for i = 1:n_term_theta
    for j = 1:n_term_theta
        if isequaln(term_hessian(i,j),0)
            term_hessian_pattern(i,j) = 0;
        end
    end
end


%% Generate code for hessian evaluation file
cd ../../src 
fileID = fopen('hessians.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,'// this function evaluates node Hessian \n');
fprintf(fileID,strcat('void node_hessian_eval('));
fprintf(fileID,strcat(d_type,' node_hessian[n_node_theta][n_node_theta],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_node_theta
    for j = 1:i
        if node_hessian_pattern(i,j) == 1
            tmp_var = ccode(node_hessian(i,j));
            tmp_var = regexprep(tmp_var, match_expr, strcat('node_theta[',replace_expr,']'));
            tmp_var = regexprep(tmp_var, 't0 = ', '');
            fprintf(fileID,'\tnode_hessian[%d][%d] = ',i-1,j-1);   
            fprintf(fileID,tmp_var); 
            fprintf(fileID,strcat('\n'));
        end        
    end
end
fprintf(fileID,'}\n');
fprintf(fileID,'\n');  
fprintf(fileID,'// this function evaluates terminal Hessian \n');
fprintf(fileID,strcat('void term_hessian_eval('));
fprintf(fileID,strcat(d_type,' term_hessian[', 'n_term_theta',']'));
fprintf(fileID,strcat('[n_term_theta],',d_type,' term_theta[n_term_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'term_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_term_theta
    for j = 1:i
        if term_hessian_pattern(i,j) == 1
            tmp_var = ccode(term_hessian(i,j));
            tmp_var = regexprep(tmp_var, match_expr, strcat('term_theta[',replace_expr,']'));
            tmp_var = regexprep(tmp_var, 't0 = ', '');
            fprintf(fileID,'\tterm_hessian[%d][%d] = ',i-1,j-1);   
            fprintf(fileID,tmp_var); 
            fprintf(fileID,strcat('\n'));
        end        
    end
end

fprintf(fileID,strcat('}\n'));
fclose(fileID);
cd ../code_generator/hessian_code


% perform unit test
if test_enable == 1
    % test "node_hessian_eval" C function
    random_input = 100*rand(1,n_node_theta);
    cd unit_test_files
        mex node_hessian_eval.c
        mex_data = node_hessian_eval(random_input);
        mex_data = vec2mat(mex_data, n_node_theta); 
    cd .. 
    golden_data = tril(node_hessian_func(random_input'));
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:))/max(golden_data(:)) > test_tol
        error('"node_hessian_eval" C function failed the test');
    else
        disp('"node_hessian_eval" C function passed the test')
    end
    
    % test "term_hessian_eval" C function
    random_input = 100*rand(1,n_term_theta);
    cd unit_test_files
        mex term_hessian_eval.c
        mex_data = term_hessian_eval(random_input);
        mex_data = vec2mat(mex_data, n_term_theta); 
    cd .. 
    golden_data = tril(term_hessian_func(random_input'));
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"term_hessian_eval" C function failed the test');
    else
        disp('"term_hessian_eval" C function passed the test')
    end
end