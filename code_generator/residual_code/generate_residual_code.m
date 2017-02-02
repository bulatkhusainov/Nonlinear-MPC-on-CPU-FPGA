
%% Generate code for residual evaluation file (without handling identity)
cd ../../src 
fileID = fopen('residual.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,'// functions prototypes \n');
fprintf(fileID,'void node_gradient_eval(float node_gradient[n_node_theta],float node_theta[n_node_theta]); \n');
fprintf(fileID,'void f_eval(float f[n_node_eq],float node_theta[n_node_theta]); \n');
fprintf(fileID,'void term_gradient_eval(float term_gradient[n_term_theta],float term_theta[n_term_theta]); \n');
fprintf(fileID,'void term_f_eval(float term_f[n_term_eq],float term_theta[n_term_theta]); \n\n');

% node residual
fprintf(fileID,'// this function evaluates node residual \n');
fprintf(fileID,strcat('void node_residual_eval('));
fprintf(fileID,strcat(d_type,' residual[n_node_theta+n_node_eq],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta],'));
fprintf(fileID,strcat(d_type,' node_nu[n_node_eq],'));
fprintf(fileID,strcat(d_type,' node_mu_over_g[n_bounds],'));
fprintf(fileID,strcat(d_type,' node_jac_2d[n_node_eq][n_node_theta],'));
fprintf(fileID,strcat(d_type,' mu)\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int', ' i,j;','\n'));
fprintf(fileID,strcat('\t',d_type, ' tmp_array[n_node_theta];','\n\n'));

fprintf(fileID,strcat('\t','// bounds indices\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',upper_bounds_indeces),'\n'));
fprintf(fileID,strcat('\t',variables_declaration_int('1d',lower_bounds_indeces),'\n\n'));


fprintf(fileID,strcat('\t','// evaluate gradient\n'));
fprintf(fileID,strcat('\t','node_gradient_eval(tmp_array, node_theta); \n\n'));

fprintf(fileID,strcat('\t','// multiply jacobian transpose by nu\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_node_eq; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_node_theta; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','tmp_array[j] += node_jac_2d[i][j]*node_nu[i];\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// handle bounds\n'));
fprintf(fileID,strcat('\t',d_type, ' tmp_upper[n_node_theta], tmp_lower[n_node_theta];','\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_node_theta; i++)\n'));
fprintf(fileID,strcat('\t\t','tmp_upper[i] = 0;\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_node_theta; i++)\n'));
fprintf(fileID,strcat('\t\t','tmp_lower[i] = 0;\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_upper_bounds; i++)\n'));
fprintf(fileID,strcat('\t\t','tmp_upper[upper_bounds_indeces[i]] = node_mu_over_g[i];\n'));
fprintf(fileID,strcat('\t','for(i = n_upper_bounds, j = 0; i < n_bounds; i++, j++)\n'));
fprintf(fileID,strcat('\t\t','tmp_lower[lower_bounds_indeces[j]] = -node_mu_over_g[i];\n\n'));

fprintf(fileID,strcat('\t','// optimality error residual\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_node_theta; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','residual[i] = -tmp_array[i] + tmp_upper[i] + tmp_lower[i];\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// feasibility error residual\n'));
fprintf(fileID,strcat('\t','f_eval(&residual[n_node_theta], node_theta);\n'));
fprintf(fileID,strcat('\t','for(i = n_node_theta; i < n_node_theta+n_node_eq; i++)\n'));
fprintf(fileID,strcat('\t\t','residual[i] = -residual[i];\n'));

fprintf(fileID,'}\n');


% term residual
fprintf(fileID,'// this function evaluates terminal residual \n');
fprintf(fileID,strcat('void term_residual_eval('));
fprintf(fileID,strcat(d_type,' term_residual[n_term_theta+n_term_eq],'));
fprintf(fileID,strcat(d_type,' term_theta[n_term_theta],'));
fprintf(fileID,strcat(d_type,' term_nu[n_term_eq],'));
fprintf(fileID,strcat(d_type,' term_jac_2d[n_term_eq][n_term_theta])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,strcat('\t','int', ' i,j;','\n'));
fprintf(fileID,strcat('\t',d_type, ' tmp_array[n_term_theta];','\n\n'));

fprintf(fileID,strcat('\t','// evaluate terminal gradient\n'));
fprintf(fileID,strcat('\t','term_gradient_eval(tmp_array, term_theta); \n\n'));

fprintf(fileID,strcat('\t','// multiply jacobian transpose by nu\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_term_eq; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','for(j = 0; j < n_term_theta; j++)\n'));
fprintf(fileID,strcat('\t\t','{\n'));
fprintf(fileID,strcat('\t\t\t','tmp_array[j] += term_jac_2d[i][j]*term_nu[i];\n'));
fprintf(fileID,strcat('\t\t','}\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// optimality error residual\n'));
fprintf(fileID,strcat('\t','for(i = 0; i < n_term_theta; i++)\n'));
fprintf(fileID,strcat('\t','{\n'));
fprintf(fileID,strcat('\t\t','term_residual[i] = -tmp_array[i];\n'));
fprintf(fileID,strcat('\t','}\n\n'));

fprintf(fileID,strcat('\t','// feasibility error residual\n'));
fprintf(fileID,strcat('\t','term_f_eval(&term_residual[n_term_theta], term_theta);\n'));
fprintf(fileID,strcat('\t','for(i = n_term_theta; i < n_term_theta+n_term_eq; i++)\n'));
fprintf(fileID,strcat('\t\t','term_residual[i] = -term_residual[i];\n'));


fprintf(fileID,'}\n');

fclose(fileID);
cd ../code_generator/residual_code


if test_enable == 1
    % test "node_residual_eval" C function
    random_node_theta = 10*rand(n_node_theta,1);
    random_node_nu = 10*rand(n_node_eq,1);
    random_node_mu_over_g = 10*rand(n_bounds,1);
    random_jac_2d = 10*rand(n_node_eq*n_node_theta,1);
    random_mu = 10*rand();
    
    cd unit_test_files
        mex node_residual_eval.c ../../../src/gradient.c ../../../src/jacobians.c
        [mex_data] = node_residual_eval(random_node_theta,random_node_nu,random_node_mu_over_g,random_jac_2d,random_mu);
    cd ..
    % construct block manually to build golden output    
    block_x = node_gradient_eval(random_node_theta);
    random_jac_2d_transpose = vec2mat(random_jac_2d, n_node_theta);
    random_jac_2d_transpose = random_jac_2d_transpose';
    block_x = block_x + random_jac_2d_transpose*random_node_nu;
    block_x = - block_x;
    block_x_upper = zeros(n_node_theta, 1);
    block_x_upper(upper_bounds_indeces+1) = random_node_mu_over_g(1:n_upper_bounds);
    block_x_lower = zeros(n_node_theta, 1);
    block_x_lower(lower_bounds_indeces+1) = -random_node_mu_over_g(n_upper_bounds+1:n_bounds);
    block_x = block_x + block_x_upper + block_x_lower;
    block_c = -f_eval(random_node_theta);
    block_golden = [block_x; block_c];
    
    
    mismatch = mex_data - block_golden;
    if max(abs(mismatch(:)))/max(abs(block_golden(:))) > test_tol
        error('"node_residual_eval" C function failed the test');
    else
        disp('"node_residual_eval" C function passed the test')
    end
    
    % test "term_residual_eval" C function
    random_term_theta = 10*rand(n_term_theta,1);
    random_term_nu = 10*rand(n_term_eq,1);
    random_term_jac_2d = 10*rand(n_term_eq*n_term_theta,1);
    
    cd unit_test_files
        mex term_residual_eval.c ../../../src/gradient.c ../../../src/jacobians.c
        [mex_data] = term_residual_eval(random_term_theta,random_term_nu,random_term_jac_2d);
    cd ..
    % construct block manually to build golden output    
    block_x = term_gradient_eval(random_term_theta);
    random_term_jac_2d_transpose = vec2mat(random_term_jac_2d, n_term_theta);
    random_term_jac_2d_transpose = random_term_jac_2d_transpose';
    block_x = block_x + random_term_jac_2d*random_term_nu;
    block_x = - block_x;
    block_c = -term_f_eval(random_term_theta);
    block_golden = [block_x; block_c];
    
    
    mismatch = mex_data - block_golden;
    if max(abs(mismatch(:))) > test_tol
        error('"term_residual_eval" C function failed the test');
    else
        disp('"term_residual_eval" C function passed the test')
    end
end