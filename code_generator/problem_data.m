%% this part is problem dependent
% define integrator Butcher table
if exist('design','var') && any(strcmp('Integrator',fieldnames(design)))
    if design.Integrator == 1
        butcher_table_A = [0]; % Euler integrator
        butcher_table_beta =  [1];
    elseif design.Integrator == 2
        butcher_table_A = [ 0 0; 0.5 0.5]; % Trapezoidal integrator
        butcher_table_beta =  [0.5; 0.5];
    elseif design.Integrator == 3
        butcher_table_A = [0 0 0; 5/24 1/3 -1/24; 1/6 2/3 1/6]; % Simpson integrator
        butcher_table_beta =  [1/6; 2/3; 1/6];
    end
else
    %butcher_table_A = [0]; % Euler integrator
    %butcher_table_beta =  [1];
    butcher_table_A = [ 0 0; 0.5 0.5]; % Trapezoidal integrator
    butcher_table_beta =  [0.5; 0.5];
    %butcher_table_A = [0 0 0; 5/24 1/3 -1/24; 1/6 2/3 1/6]; % Simpson integrator
    %butcher_table_beta =  [1/6; 2/3; 1/6];   
end;

if exist('design','var') && any(strcmp('heterogeneity',fieldnames(design))); heterogeneity = design.heterogeneity; else heterogeneity = 3; end;
x_init = [0.5;0];
Tsim = 1;
MINRES_prescaled = 1;
d_type = 'float';
IP_iter = 20;
MINRES_iter = '1.5*n_linear';
PAR = 5;
if exist('design','var') && any(strcmp('N',fieldnames(design))); N = design.N; else N = 5; end;
if exist('design','var') && any(strcmp('Ts',fieldnames(design))); Ts = design.Ts; else Ts = 0.1; end;

%model = 'casadi_example';
%model = 'crane_x';
model = 'crane_xz';
if(strcmp(model,  'casadi_example'))
    % model-dependent part (simple two-state system from casadi example)
    n_stages = size(butcher_table_A,1); % number of integrator stages per node
    n_states = 2;
    m_inputs = 1;
    n_node_slack = 1;
    n_node_slack_eq = 1;
    n_term_slack = 1;
    n_term_eq = 1;
    n_node_theta = n_states + m_inputs + n_node_slack + n_stages*n_states;
    n_term_theta = n_states + n_term_slack;
    n_node_eq = n_states*(n_stages+1) + n_node_slack_eq;
    node_theta = sym('node_theta',[n_node_theta 1]);
    x = node_theta(1:n_states);
    u = node_theta(n_states+1:n_states+m_inputs);
    s = node_theta(n_states+m_inputs+1:n_states+m_inputs+n_node_slack);
    r = node_theta(n_states+m_inputs+n_node_slack+1: n_states+m_inputs+n_node_slack+n_stages*n_states); % integrator intermediate steps
    term_theta = sym('term_theta',[n_term_theta 1]);
    term_x = term_theta(1:n_states);
    term_s = term_theta(n_states+1:n_states+n_term_slack);
    % define objective (function of x,u,s)
    node_objective_residual = sqrt(Ts)*[ sqrt(1)*((x(1))); 
                                         sqrt(1)*(x(2)); 
                                         sqrt(0.001)*(s(1));]; % least squares format
    term_objective_residual = [sqrt(1)*(term_x(1)); 
                               sqrt(1)*(term_x(2))]; % least squares format
    % define ode (function of x,u)
    ode(1) = (1-x(2)^2)*x(1) - x(2) + u(1);
    ode(2) = x(1);
    % define equality constraints with slack variables (function of x,u,s)
    %f_slack = [];
    f_slack = sym(zeros(n_node_slack_eq,1));
    f_slack(1) = u(1)- s(1) ;
    %term_f = [];
    term_f = sym(zeros(n_term_eq,1));
    term_f(1) = term_x(1) - term_s(1);
    % define bounds on x,u,s
    % bound indeces [x' u' s']'
    upper_bounds_indeces = [3]-1; % in C format
    lower_bounds_indeces = [3]-1; % in C format
    upper_bounds = [ 0.5];
    lower_bounds = [ -0.5];
    n_upper_bounds = max(size(upper_bounds_indeces));
    n_lower_bounds = max(size(lower_bounds_indeces));
    n_bounds = n_upper_bounds + n_lower_bounds;
elseif(strcmp(model,  'crane_x'))
    % model-dependent part (crane_x)
    % parameters
    tau_x = 1/7.75;
    tau_z = 1/7.75;
    g = 9.81;
    z_length = 0.5;
    % dimensions
    n_stages = size(butcher_table_A,1); % number of integrator stages per node
    n_states = 4;
    m_inputs = 1;
    n_node_slack = 1;
    n_node_slack_eq = 1;
    n_term_slack = 1;
    n_term_eq = 1;
    n_node_theta = n_states + m_inputs + n_node_slack + n_stages*n_states;
    n_term_theta = n_states + n_term_slack;
    n_node_eq = n_states*(n_stages+1) + n_node_slack_eq;
    node_theta = sym('node_theta',[n_node_theta 1]);
    x = node_theta(1:n_states);
    u = node_theta(n_states+1:n_states+m_inputs);
    s = node_theta(n_states+m_inputs+1:n_states+m_inputs+n_node_slack);
    r = node_theta(n_states+m_inputs+n_node_slack+1: n_states+m_inputs+n_node_slack+n_stages*n_states); % integrator intermediate steps
    term_theta = sym('term_theta',[n_term_theta 1]);
    term_x = term_theta(1:n_states);
    term_s = term_theta(n_states+1:n_states+n_term_slack);
    
    % give meaningful names to states and inputs
    x_coord     = x(1);
    x_speed     = x(2);
    theta_angle = x(3);
    theta_speed = x(4);
    input_x     = u(1);
    
    % define objective (function of x,u,s)
    node_objective_residual = sqrt(Ts)*[ sqrt(1)*(x(1)); 
                                         sqrt(0)*(x(2));
                                         sqrt(10)*(x(3));
                                         sqrt(1)*(x(4));
                                         sqrt(0.001)*(u(1))]; % least squares format
    term_objective_residual = [sqrt(1)*(term_x(1));
                               sqrt(0)*(term_x(2));
                               sqrt(10)*(term_x(3));
                               sqrt(1)*(term_x(4))]; % least squares format
    % define ode (function of x,u)
    ode(1) = x_speed;
    ode(2) = -(1/tau_x)*x_speed + (1/tau_x)*input_x;
    ode(3) = theta_speed;
    ode(4) = (-1/z_length)*( (-x_speed/(tau_x) + input_x/tau_x)*cos(theta_angle) + g*sin(theta_angle) );
    % define equality constraints with slack variables (function of x,u,s)
    %f_slack = [];
    f_slack = sym(zeros(n_node_slack_eq,1));
    f_slack(1) = u(1)- s(1) ;
    %term_f = [];
    term_f = sym(zeros(n_term_eq,1));
    term_f(1) = term_x(1) - term_s(1);
    % define bounds on x,u,s
    % bound indeces [x' u' s']'
    upper_bounds_indeces = [5]-1; % in C format
    lower_bounds_indeces = [5]-1; % in C format
    upper_bounds = [ 0.4];
    lower_bounds = [ -0.4];
    n_upper_bounds = max(size(upper_bounds_indeces));
    n_lower_bounds = max(size(lower_bounds_indeces));
    n_bounds = n_upper_bounds + n_lower_bounds;
    
elseif(strcmp(model,  'crane_xz'))
    % model-dependent part (crane_x)
    % parameters
    tau_x = 1/7.75;
    tau_z = 1/15;
    g = 9.81;
    % dimensions
    n_stages = size(butcher_table_A,1); % number of integrator stages per node
    n_states = 6;
    m_inputs = 2;
    n_node_slack = 1;
    n_node_slack_eq = 1;
    n_term_slack = 1;
    n_term_eq = 1;
    n_node_theta = n_states + m_inputs + n_node_slack + n_stages*n_states;
    n_term_theta = n_states + n_term_slack;
    n_node_eq = n_states*(n_stages+1) + n_node_slack_eq;
    node_theta = sym('node_theta',[n_node_theta 1]);
    x = node_theta(1:n_states);
    u = node_theta(n_states+1:n_states+m_inputs);
    s = node_theta(n_states+m_inputs+1:n_states+m_inputs+n_node_slack);
    r = node_theta(n_states+m_inputs+n_node_slack+1: n_states+m_inputs+n_node_slack+n_stages*n_states); % integrator intermediate steps
    term_theta = sym('term_theta',[n_term_theta 1]);
    term_x = term_theta(1:n_states);
    term_s = term_theta(n_states+1:n_states+n_term_slack);
    
    % give meaningful names to states and inputs
    x_coord     = x(1);
    x_speed     = x(2);
    z_coord     = x(3);
    z_speed     = x(4);
    theta_angle = x(5);
    theta_speed = x(6);
    
    input_x     = u(1);
    input_z     = u(2);
    
    % define objective (function of x,u,s)
    node_objective_residual = sqrt(Ts)*[ sqrt(10)*(x(1)); 
                                         sqrt(0.001)*(x(2));
                                         sqrt(10)*(x(3));
                                         sqrt(0.001)*(x(4));
                                         sqrt(10)*(x(5));
                                         sqrt(0.001)*(x(6));
                                         sqrt(0.0001)*(u(1));
                                         sqrt(0.0001)*(u(2))]; % least squares format
    term_objective_residual = [sqrt(10)*(term_x(1));
                               sqrt(0.001)*(term_x(2));
                               sqrt(10)*(term_x(3));
                               sqrt(0.001)*(term_x(4));
                               sqrt(10)*(term_x(5));
                               sqrt(0.001)*(term_x(6))]; % least squares format
    % define ode (function of x,u)
    ode(1) = x_speed;
    ode(2) = -(1/tau_x)*x_speed + (1/tau_x)*input_x;
    ode(3) = z_speed;
    ode(4) = -(1/tau_z)*z_speed + (1/tau_z)*input_z;
    ode(5) = theta_speed;
    ode(6) = (-1/(0.5 + z_coord))*( (-x_speed/(tau_x) + input_x/tau_x)*cos(theta_angle) + g*sin(theta_angle) + 2*z_speed*theta_speed);
    % define equality constraints with slack variables (function of x,u,s)
    %f_slack = [];
    f_slack = sym(zeros(n_node_slack_eq,1));
    f_slack(1) = u(1)- s(1) ;
    %term_f = [];
    term_f = sym(zeros(n_term_eq,1));
    term_f(1) = term_x(1) - term_s(1);
    % define bounds on x,u,s
    % bound indeces [x' u' s']'
    upper_bounds_indeces = [7,8]-1; % in C format
    lower_bounds_indeces = [7,8]-1; % in C format
    upper_bounds = [ 0.04, 0.04];
    lower_bounds = [ -0.04, -0.04];
    n_upper_bounds = max(size(upper_bounds_indeces));
    n_lower_bounds = max(size(lower_bounds_indeces));
    n_bounds = n_upper_bounds + n_lower_bounds;   
end

% optimization problem dimensions
n_all_theta = n_node_theta*N + n_term_theta;
n_all_nu = n_node_eq*N + n_term_eq+n_states;
n_all_lambda = n_bounds*N;
n_linear = n_all_theta+n_all_nu;

% simulation data (calculate the required number of calculations)
N_sim_full = floor(Tsim/Ts);
Tsim_last = Tsim - N_sim_full*Ts;

% parallelization/pipelining data
part_size = ceil(N/PAR);
PAR = floor(N/part_size);
rem_partition = N - PAR*part_size;
ii_required = 2;

% save the workspace
save problem_data

