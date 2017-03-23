% solve OCP problem using gradient, hessian, jacobian info from C 
% files using mex interfaces
clear;

% generate C code, compile mex and perform unit testing
cd ../code_generator
generate_c_code;
cd ../integration_testing


%clear the workspace and load only problem data
clear;
cd ../code_generator
problem_data;
cd ../integration_testing


% formulate and solve optimization problem
% initial condiiton
x_init = [0; 0; 0.3; 0; 0.2; 0];
%x_init = [0.5; 0];

% intial guess
all_theta = zeros(n_node_theta*N+n_term_theta,1); % optimization variables (make sure the guess is feasible)
%all_theta = 0.77*sin((1:(n_node_theta*N+n_term_theta))');
all_nu = zeros(n_states + n_node_eq*N + n_term_eq,1); % equality dual variables
%all_nu = 0.5*sin((1:(n_states + n_node_eq*N + n_term_eq))');
all_lambda = ones(N*n_bounds, 1); % inequality dual variables


%all_theta(902) = 12;
%all_nu(301) = 4;

mu = 0.001; % barrier parameter


n_z = size(all_theta,1) + size(all_nu,1); 
A = zeros(n_z,n_z);
b = zeros(n_z, 1);


% store resudal to observe algorithm convergence
r_dual_store = zeros(1,IP_iter);
r_eq_store = zeros(1,IP_iter);
r_slackness_store = zeros(1,IP_iter);
mu_store = zeros(1,IP_iter);

for ip_iter = 1:IP_iter
    %evaluate A matrix
    A( (n_states + 1):2*n_states, 1:n_states) = -eye(n_states); % initial condition
    for i = 1:N
        node_Hessian = node_hessian_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        node_Hessian = vec2mat(node_Hessian,n_node_theta);
        if (n_bounds > 0)
            % evaluate bound constraints
            node_bounds = node_bounds_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
            % calculate gwg
            node_gwg = node_gwg_eval(node_bounds, all_lambda((1:n_bounds) + (i-1)*n_bounds));
            node_gwg = diag(node_gwg);
            node_range = 1:n_states+m_inputs+n_node_slack;
            node_Hessian(node_range,node_range) = node_Hessian(node_range,node_range) + node_gwg;
        end
        
        node_jacobian = f_jac_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        node_jacobian = vec2mat(node_jacobian, n_node_theta);
        block = [node_Hessian node_jacobian'; node_jacobian zeros(size(node_jacobian,1))];
        A_index = ((1:(n_node_theta+n_node_eq)) + n_states+(i-1)*(n_node_theta+n_node_eq));
        A(A_index,A_index) = block; 

        A_index_row = (1:n_states) + n_states + (n_node_theta+n_node_eq) + (i-1)*(n_node_theta+n_node_eq);
        A_index_col = (1:n_states) + n_states + size(node_Hessian,1) + (i-1)*(n_node_theta+n_node_eq);
        A(A_index_row,A_index_col) = -eye(n_states);

    end
    % terminal hessian and jacobian
    term_hessian = term_hessian_eval(all_theta((1:n_term_theta)+(N)*(n_node_theta) ));
    term_hessian = vec2mat(term_hessian, n_term_theta);
    term_jacobian = term_f_jac_eval( all_theta((1:n_term_theta)+(N)*(n_node_theta) ) )';
    term_jacobian = vec2mat(term_jacobian, n_term_theta);
    term_block = [term_hessian term_jacobian'; term_jacobian zeros(size(term_jacobian,1))];
    A_index = (1:n_term_theta+n_term_eq) + n_states + N*(n_node_theta+n_node_eq);
    A(A_index,A_index) = term_block;
    % symmetrize the matrix
    A = tril(A);
    A = A + tril(A,-1)';

    %evaluate b
    % handle initial condition constraint (part of feasibility error)
    b(1:n_states) = -(-all_theta(1:n_states) + x_init); 
    for i = 1:N
        % process optimality error
        block_x = node_gradient_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        node_jacobian_transpose = f_jac_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        node_jacobian_transpose = vec2mat(node_jacobian_transpose, n_node_theta);
        node_jacobian_transpose = node_jacobian_transpose';
        block_x = block_x + node_jacobian_transpose*all_nu((1:n_node_eq) + n_states + (i-1)*n_node_eq);
        % negative identity
        if i == 1
            block_x(1:n_states) = block_x(1:n_states) - all_nu(1:n_states);
        else
            block_x(1:n_states)  = ...
            block_x(1:n_states) - all_nu((1:n_states) + n_states + (i-2)*n_node_eq );
        end
        block_x = - block_x;
        
        if (n_bounds > 0)
             % evaluate bound constraints
            node_bounds = node_bounds_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
            tmp_vector = mu./node_bounds;

            block_x_upper = zeros(n_node_theta, 1);
            block_x_upper(upper_bounds_indeces+1) = tmp_vector(1:n_upper_bounds);
            
            block_x_lower = zeros(n_node_theta, 1);
            block_x_lower(lower_bounds_indeces+1) = -tmp_vector(n_upper_bounds+1:n_bounds);
                       
            block_x = block_x + block_x_upper + block_x_lower;
        end
        
        

        % process feasibility error
        block_c = -f_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        block_c(1:n_states) = block_c(1:n_states) + all_theta((1:n_states)+ i*(n_node_theta) );

        size_block = n_node_theta + n_node_eq;    
        b( (1:size_block) + n_states + (i-1)*(size_block)) = [block_x; block_c];

    end
    % terminal optimality error
    block_x_term = term_gradient_eval(all_theta((1:n_term_theta)+N*(n_node_theta) ));
    term_jacobian_transpose = term_f_jac_eval(all_theta((1:n_term_theta)+N*(n_node_theta) ));
    term_jacobian_transpose = vec2mat(term_jacobian_transpose, n_term_theta);
    term_jacobian_transpose = term_jacobian_transpose';
    block_x_term = block_x_term + term_jacobian_transpose*all_nu((1:n_term_eq) + n_states + N*n_node_eq);
    block_x_term(1:n_states) = block_x_term(1:n_states) - all_nu((1:n_states) + n_states + (N-1)*n_node_eq );
    block_x_term = -block_x_term;
    % terminal feasibility error
    block_c_term = -term_f_eval( all_theta((1:n_term_theta)+N*(n_node_theta) ) );
    
    b( (1:n_term_theta+n_term_eq) + n_states + N*(n_node_theta + n_node_eq)) = [block_x_term; block_c_term];
    
    % current resudual vector (extract from b for testing purposes only)
    r_dual = zeros(size(all_theta));
    r_eq = zeros(size(all_nu));
    for i=1:N
        r_dual((1:n_node_theta) + (i-1)*n_node_theta) = b((1:n_node_theta) + n_states + (i-1)*(n_node_theta+n_node_eq));
    end
    r_dual((1:n_term_theta) + (N)*n_node_theta) = b((1:n_term_theta) + n_states + (N)*(n_node_theta+n_node_eq));
    r_eq(1:n_states) = b(1:n_states);
    for i=1:N
        r_eq((1:n_node_eq) + n_states + (i-1)*n_node_eq) = b((1:n_node_eq) + n_states + n_node_theta + (i-1)*(n_node_theta+n_node_eq));
    end
    r_eq((1:n_term_eq) + n_states + N*n_node_eq) = b((1:n_term_eq) + n_states + n_term_theta + N*(n_node_theta+n_node_eq));
    r_dual_store(ip_iter) = max(abs(r_dual));
    r_eq_store(ip_iter) = max(abs(r_eq));
    
    % calculate complementary slackness
    r_slackness = zeros(n_bounds*N,1);
    for i = 1:N
        % evaluate bound constraints
        node_bounds = node_bounds_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        r_slackness((1:n_bounds) + (i-1)*n_bounds) = node_bounds.*all_lambda((1:n_bounds) + (i-1)*n_bounds);
    end
    r_slackness_store(ip_iter) = max(abs(r_slackness));
    mu_store(ip_iter) = mu;
    
    n_iter_minres_max = 1*round(max(size(A)));
    % solve a system on linear equations
    if true
        A_single = single(A);
        M_single = sqrt(diag(sum(abs(A_single'))))^-1;
        b_single = single(b);
        d_z_single = minres(M_single*A_single*M_single,M_single*b_single,[],round(n_iter_minres_max),[],[],[]);
        %d_z_single = min_res(M_single*A_single*M_single,M_single*b_single);
        d_z = double(M_single*d_z_single);
%         M = sqrt(diag(sum(abs(A'))))^-1;
%         d_z = minres(M*A*M,M*b,[],round(n_iter_minres_max));
%         d_z = M*d_z;
    elseif false
        %d_z = min_res(A,b);
    else
        d_z = A\b;
    end

    % extract d_theta_all and d_nu_all
    d_theta_all = zeros(size(all_theta));
    d_nu_all = zeros(size(all_nu));
    for i=1:N
        d_theta_all((1:n_node_theta) + (i-1)*n_node_theta) = d_z((1:n_node_theta) + n_states + (i-1)*(n_node_theta+n_node_eq));
    end
    d_theta_all((1:n_term_theta) + (N)*n_node_theta) = d_z((1:n_term_theta) + n_states + (N)*(n_node_theta+n_node_eq));

    d_nu_all(1:n_states) = d_z(1:n_states);
    for i=1:N
        d_nu_all((1:n_node_eq) + n_states + (i-1)*n_node_eq) = d_z((1:n_node_eq) + n_states + n_node_theta + (i-1)*(n_node_theta+n_node_eq));
    end
    d_nu_all((1:n_term_eq) + n_states + N*n_node_eq) = d_z((1:n_term_eq) + n_states + n_term_theta + N*(n_node_theta+n_node_eq));
    
    % recover d_lambda_all
    if (n_bounds > 0)
        d_lambda_all = zeros(N*n_bounds, 1);
        for i = 1:N
            d_theta_local = d_theta_all((1:n_node_theta)+(i-1)*(n_node_theta) );
            tmp_vector_upper = d_theta_local(upper_bounds_indeces+1);
            tmp_vector_lower = -d_theta_local(lower_bounds_indeces+1);
            tmp_vector = [tmp_vector_upper; tmp_vector_lower];
            tmp_vector = all_lambda((1:n_bounds) + (i-1)*n_bounds).*tmp_vector;
            tmp_vector = mu*ones(n_bounds,1) + tmp_vector;
            % evaluate bound constraints
            node_bounds = node_bounds_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
            tmp_vector = tmp_vector ./ node_bounds;
            d_lambda_all((1:n_bounds) + (i-1)*n_bounds) = -all_lambda((1:n_bounds) + (i-1)*n_bounds) - tmp_vector;
        end
    end

    
    % line search (required only if bounds are present)
    alfa = 1;
    if (n_bounds > 0)
        d_g_search = zeros(N*n_bounds,1);
        g_all = zeros(N*n_bounds,1);
        for i = 1:N
            d_theta_local = d_theta_all((1:n_node_theta)+(i-1)*(n_node_theta) );
            tmp_vector_upper = d_theta_local(upper_bounds_indeces+1);
            tmp_vector_lower = -d_theta_local(lower_bounds_indeces+1);
            d_g_search((1:n_bounds) + (i-1)*n_bounds) = [tmp_vector_upper; tmp_vector_lower];
            g_all((1:n_bounds) + (i-1)*n_bounds) = node_bounds_eval(all_theta((1:n_node_theta)+(i-1)*(n_node_theta) ));
        end
        
  
        while ( max(g_all + alfa*d_g_search) > 0 || min(all_lambda + alfa*d_lambda_all) < 0)
            alfa = alfa*0.9;
        end
    end
 
    % perform step
    all_theta = alfa*d_theta_all + all_theta;
    all_nu = alfa*d_nu_all + all_nu;
    if (n_bounds > 0)
        all_lambda = alfa*d_lambda_all + all_lambda;
    end
    

        
    % update barrier 
%     if mu <= 0.001
%         mu = 0.001;
%     else
%         mu = mu*0.1;
%     end
end

% plot convergence of the algorithm
subplot(3,1,1);
plot(0:(IP_iter-1), r_dual_store);
title('optimality error');
subplot(3,1,2);
plot(0:(IP_iter-1), r_eq_store);
title('feasibility error');
subplot(3,1,3);
plot(0:(IP_iter-1), r_slackness_store,0:(IP_iter-1),mu_store, '--');
title('complementary slackness');


%extract data for plotting

x_trajectory = zeros(n_states,N+1);
u_trajectory = zeros(m_inputs,N);
s_trajectory = zeros(n_node_slack,N);
for i=1:N
    x_trajectory(:,i) = all_theta((1:n_states) + (i-1)*n_node_theta);
    u_trajectory(:,i) = all_theta((1:m_inputs) + n_states + (i-1)*n_node_theta);
    s_trajectory(:,i) = all_theta((1:n_node_slack) + n_states + m_inputs + (i-1)*n_node_theta);
end
x_trajectory(:,N+1) = all_theta((1:n_states) + (N)*n_node_theta);
if(strcmp(model,  'casadi_example'))
    figure
    plot((0:N), x_trajectory(1,:)); % first state
    hold on
    plot((0:N), x_trajectory(2,:)); % second state
    stairs((0:N-1), u_trajectory(1,:)) % first input
    %plot((0:N-1), s_trajectory(1,:)) % first slack
    legend('state 1', 'state 2','input 1');
elseif(strcmp(model,  'crane_x'))
    figure
    subplot(3,2,1); plot((0:N), x_trajectory(1,:)); title('x coordinate'); 
    subplot(3,2,2); plot((0:N), x_trajectory(2,:)); title('x speed'); 
    subplot(3,2,3); plot((0:N), x_trajectory(3,:)); title('theta'); 
    subplot(3,2,4); plot((0:N), x_trajectory(4,:)); title('theta spped'); 
    subplot(3,2,5); stairs((0:N-1), u_trajectory(1,:)); title('x input');   
elseif(strcmp(model,  'crane_xz'))
    figure
    subplot(3,3,1); plot((0:N), x_trajectory(1,:)); title('x coordinate'); 
    subplot(3,3,2); plot((0:N), x_trajectory(2,:)); title('x speed'); 
    subplot(3,3,3); plot((0:N), x_trajectory(3,:)); title('z coordinate'); 
    subplot(3,3,4); plot((0:N), x_trajectory(4,:)); title('z speed'); 
    subplot(3,3,5); plot((0:N), x_trajectory(5,:)); title('theta'); 
    subplot(3,3,6); plot((0:N), x_trajectory(6,:)); title('theta spped'); 
    subplot(3,3,7); stairs((0:N-1), u_trajectory(1,:)); title('x input'); 
    subplot(3,3,8); stairs((0:N-1), u_trajectory(2,:)); title('z input');
end


%% compile and test full C implementation
test_C;