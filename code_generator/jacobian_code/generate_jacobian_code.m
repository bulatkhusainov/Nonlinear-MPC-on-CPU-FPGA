%% Integrator constraints
% ode function
ode_func = matlabFunction(ode,'Vars', {node_theta(1:n_states+m_inputs)});
ode_jac_x = jacobian(ode,x);
ode_jac_x_func = matlabFunction(ode_jac_x,'Vars', {node_theta(1:n_states+m_inputs)});
ode_jac_u = jacobian(ode,u);
ode_jac_u_func = matlabFunction(ode_jac_u,'Vars', {node_theta(1:n_states+m_inputs)});
% continiuty constraint (without x_{k+1})
f_cont = x;
for i = 1:n_stages % iterate over integration stages
    f_cont = f_cont + Ts*(butcher_table_beta(i)*r((1:n_states)+(i-1)*n_states));
end
f_jac = jacobian(f_cont,node_theta);

% integrator stages constraints
f_intgr = sym(zeros(n_stages*n_states,1));
for i=1:n_stages
    f_intgr((1:n_states)+(i-1)*(n_states)) = -r((1:n_states)+(i-1)*(n_states));
    tmp_var = x;
    for j=1:n_stages
        tmp_var = tmp_var + Ts*butcher_table_A(i,j)*r((1:n_states)+(j-1)*(n_states));
    end
    f_intgr((1:n_states)+(i-1)*(n_states)) = f_intgr((1:n_states)+(i-1)*(n_states)) + (ode_func([tmp_var;u])).';
end
%f_intgr_jac = jacobian(f_intgr,node_theta);

% overall equality constraints
f = [f_cont; f_intgr];
f_func = matlabFunction(f,'Vars', {node_theta});
f_jac = jacobian(f, node_theta);
f_jac_func = matlabFunction(f_jac,'Vars', {node_theta});

%% Generate code for constraints and jacobians evaluations
cd ../../src 
fileID = fopen('jacobians.c','w');
fprintf(fileID,'#include "user_main_header.h"\n\n');

fprintf(fileID,strcat('// Butcher table data\n'));
fprintf(fileID,strcat(variables_declaration('2d',butcher_table_A),'\n'));
fprintf(fileID,strcat(variables_declaration('1d',butcher_table_beta),'\n\n'));

fprintf(fileID,strcat('// this function evaluates dynamics ODE\n'));
fprintf(fileID,strcat('void ode_eval('));
fprintf(fileID,strcat(d_type,' x_dot[n_states],'));
fprintf(fileID,strcat(d_type,' x_u[n_states+m_inputs])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_states
    tmp_var = ccode(ode(i));
    tmp_var = regexprep(tmp_var, match_expr, strcat('x_u[',replace_expr,']'));
    tmp_var = regexprep(tmp_var, 't0 = ', '');
    fprintf(fileID,'\tx_dot[%d] = ',i-1);   
    fprintf(fileID,tmp_var); 
    fprintf(fileID,strcat('\n'));
end
fprintf(fileID,'}\n\n');

fprintf(fileID,strcat('// this function evaluates Jacobian of ODE w.r.t. x\n'));
fprintf(fileID,strcat('void ode_jac_x_eval('));
fprintf(fileID,strcat(d_type,' ode_jac_x[n_states][n_states],'));
fprintf(fileID,strcat(d_type,' x_u[n_states+m_inputs])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
ode_jac_x = jacobian(ode,x);
for i = 1:n_states
    for j = 1:n_states
        tmp_var = ccode(ode_jac_x(i,j));
        tmp_var = regexprep(tmp_var, match_expr, strcat('x_u[',replace_expr,']'));
        tmp_var = regexprep(tmp_var, 't0 = ', '');
        fprintf(fileID,'\tode_jac_x[%d][%d] = ',i-1,j-1);   
        fprintf(fileID,tmp_var); 
        fprintf(fileID,strcat('\n'));
    end
end
fprintf(fileID,'}\n\n');

fprintf(fileID,strcat('// this function evaluates Jacobian of ODE w.r.t. u\n'));
fprintf(fileID,strcat('void ode_jac_u_eval('));
fprintf(fileID,strcat(d_type,' ode_jac_u[n_states][m_inputs],'));
fprintf(fileID,strcat(d_type,' x_u[n_states+m_inputs])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
ode_jac_u = jacobian(ode,u);
for i = 1:n_states
    for j = 1:m_inputs
        tmp_var = ccode(ode_jac_u(i,j));
        tmp_var = regexprep(tmp_var, match_expr, strcat('x_u[',replace_expr,']'));
        tmp_var = regexprep(tmp_var, 't0 = ', '');
        fprintf(fileID,'\tode_jac_u[%d][%d] = ',i-1,j-1);   
        fprintf(fileID,tmp_var); 
        fprintf(fileID,strcat('\n'));
    end
end
fprintf(fileID,'}\n\n');


fprintf(fileID,strcat('// this function evaluates equality constraints\n'));
fprintf(fileID,strcat('void f_eval('));
fprintf(fileID,strcat(d_type,' f[n_states*(n_stages+1)],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta])\n'));
fprintf(fileID,'{\n');
fprintf(fileID,'\tint i, j, k;\n');
fprintf(fileID,'\tint offset_node_theta, offset_f;\n');

fprintf(fileID,strcat('\t// trajectory continuity constraint\n'));
fprintf(fileID,'\tfor(i = 0; i < n_states; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\tf[i] = node_theta[i];\n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,'\tfor(i = 0; i < n_states; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,'\t\toffset_node_theta = n_states + m_inputs + n_node_slack + i;\n');
fprintf(fileID,'\t\tfor(j = 0; j < n_stages; j++)\n');
fprintf(fileID,'\t\t{\n');
fprintf(fileID,'\t\t\tf[i] += Ts*butcher_table_beta[j]*node_theta[offset_node_theta + j*n_states];\n');
fprintf(fileID,'\t\t}\n');
fprintf(fileID,'\t}\n\n');

fprintf(fileID,strcat('\t// integration stages constaints\n'));

fprintf(fileID,'\tfor(i = 0; i < n_stages; i++)\n');
fprintf(fileID,'\t{\n');
fprintf(fileID,strcat('\t\toffset_f = n_states + i*n_states;\n'));

fprintf(fileID,'\t\n');
fprintf(fileID,strcat('\t\t// calculate local "x_u"\n'));
fprintf(fileID,strcat('\t\t', d_type, ' local_x_u[n_states+m_inputs];','\n'));
fprintf(fileID,strcat('\t\tfor(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t{\n'));
fprintf(fileID,strcat('\t\t\tlocal_x_u[j] = node_theta[j];\n'));
fprintf(fileID,'\t\t\toffset_node_theta = n_states + m_inputs + n_node_slack+ j;\n');
fprintf(fileID,strcat('\t\t\tfor(k = 0; k < n_stages; k++)\n'));
fprintf(fileID,strcat('\t\t\t{\n'));
fprintf(fileID,strcat('\t\t\t\tlocal_x_u[j] += Ts*butcher_table_A[i][k]*node_theta[offset_node_theta+k*n_states];\n'));
fprintf(fileID,strcat('\t\t\t}\n'));
fprintf(fileID,strcat('\t\t}\n'));
fprintf(fileID,strcat('\t\tfor(j = n_states; j < n_states+m_inputs; j++)\n'));
fprintf(fileID,strcat('\t\t{\n'));
fprintf(fileID,strcat('\t\t\tlocal_x_u[j] = node_theta[j];\n'));
fprintf(fileID,strcat('\t\t}\n\n'));
fprintf(fileID,strcat('\t\t// calculate local "x_dot"\n'));
fprintf(fileID,strcat('\t\t', d_type, ' local_x_dot[n_states];','\n'));
fprintf(fileID,strcat('\t\t', 'ode_eval(local_x_dot, local_x_u);','\n\n'));
fprintf(fileID,strcat('\t\t// final result\n'));
fprintf(fileID,strcat('\t\toffset_node_theta = n_states + m_inputs + n_node_slack + i*n_states;\n'));
fprintf(fileID,strcat('\t\tfor(j = 0; j < n_states; j++)\n'));
fprintf(fileID,strcat('\t\t{\n'));
fprintf(fileID,strcat('\t\t\tf[offset_f+j] = -node_theta[offset_node_theta+j] + local_x_dot[j];\n'));
fprintf(fileID,strcat('\t\t}\n'));
fprintf(fileID,'\t}\n');
fprintf(fileID,'}\n\n');


fprintf(fileID,strcat('// this function evaluates equality constraints jacobian (without x_{k+1})\n'));
fprintf(fileID,strcat('void f_jac_eval('));
fprintf(fileID,strcat(d_type,' f_jac[n_states*(n_stages+1)][n_node_theta],'));
fprintf(fileID,strcat(d_type,' node_theta[n_node_theta])\n'));
fprintf(fileID,'{\n');
match_expr = 'node_theta(\d*)';
replace_expr = '$1-1';
for i = 1:n_states*(n_stages+1)
    for j = 1:n_node_theta
        tmp_var = ccode(f_jac(i,j));
        tmp_var = regexprep(tmp_var, match_expr, strcat('node_theta[',replace_expr,']'));
        tmp_var = regexprep(tmp_var, 't0 = ', '');
        fprintf(fileID,'\tf_jac[%d][%d] = ',i-1,j-1);   
        fprintf(fileID,tmp_var); 
        fprintf(fileID,strcat('\n'));
    end
end
fprintf(fileID,'}\n');
fclose(fileID);
cd ../code_generator/jacobian_code


%% perform unit test
if test_enable == 1
    % test "ode_eval" C function
    random_input = 5*rand(1,n_states+m_inputs);
    cd unit_test_files
        mex ode_eval.c
        mex_data = ode_eval(random_input);
    cd .. 
    golden_data = ode_func(random_input');
    mismatch = abs(golden_data - mex_data');
    if max(mismatch(:)) > test_tol
        error('"ode_eval" C function failed the test');
    else
        disp('"ode_eval" C function passed the test')
    end
   
    % test "ode_jac_x_eval" C function
    random_input = 5*rand(1,n_states+m_inputs);
    cd unit_test_files
        mex ode_jac_x_eval.c
        mex_data = ode_jac_x_eval(random_input);
        mex_data = vec2mat(mex_data, n_states); 
    cd .. 
    golden_data = ode_jac_x_func(random_input');
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"ode_jac_x_eval" C function failed the test');
    else
        disp('"ode_jac_x_eval" C function passed the test')
    end
    
    % test "ode_jac_u_eval" C function
    random_input = 5*rand(1,n_states+m_inputs);
    cd unit_test_files
        mex ode_jac_u_eval.c
        mex_data = ode_jac_u_eval(random_input);
        mex_data = vec2mat(mex_data, m_inputs); 
    cd .. 
    golden_data = ode_jac_u_func(random_input');
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"ode_jac_u_eval" C function failed the test');
    else
        disp('"ode_jac_u_eval" C function passed the test')
    end
    
    % test "f_eval" C function
    random_input = 5*rand(1,n_node_theta);
    cd unit_test_files
        mex f_eval.c 
        mex_data = f_eval(random_input);
    cd .. 
    golden_data = f_func(random_input');
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"f_eval" C function failed the test');
    else
        disp('"f_eval" C function passed the test')
    end
    
     % test "f_jac_eval" C function
    random_input = 5*rand(1,n_node_theta);
    cd unit_test_files
        mex f_jac_eval.c
        mex_data = f_jac_eval(random_input);
        mex_data = vec2mat(mex_data, n_node_theta); 
    cd .. 
    golden_data = f_jac_func(random_input');
    mismatch = abs(golden_data - mex_data);
    if max(mismatch(:)) > test_tol
        error('"f_jac_eval" C function failed the test');
    else
        disp('"f_jac_eval" C function passed the test')
    end
end
