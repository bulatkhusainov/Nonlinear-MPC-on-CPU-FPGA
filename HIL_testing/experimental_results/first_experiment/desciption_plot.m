%% formulation 
% model
% ode(1) = (1-x(2)^2)*x(1) - x(2) + u(1);
% ode(2) = 0.02*x(1);
% cost function (least squares format) 
% node_objective_residual = sqrt(Ts)*[ sqrt(0.01)*((x(1))); 
%                                      sqrt(50)*(x(2)); 
%                                      sqrt(0.0001)*(s(1));]; % least squares format
% term_objective_residual = [sqrt(0.01)*(term_x(1)); 
%                            sqrt(50)*(term_x(2))]; % least squares format
% constraints
% +/- 10 bounds on inputs
% Real-time feasibility constraints are not taken into account

%% full design exploration
% design exploration was performed with the following grid
% Ts = linspace(0.5,5,30);
% N = 1:10
% Integator: Euler, Trapezoidal, Simpson
load('full_exploration_data.mat');

%% MOO with NOMAD
% 1. firstly tried optimizing N, Ts with a fixed integrator (euler,
% trapezoidal, simpson), with a budget of 200 evaluations per problem
% 2. Optimizaed all three parameters simulataneously (N, Ts, Integrator)
% with a budget of 300 evaluations.
load('moo_nomad.mat');


%% plot the results
% compare separate design optimizaiton vs joint
% loglog( fval_euler(1,:),fval_euler(2,:),'-o',fval_trapezoidal(1,:),fval_trapezoidal(2,:),'-o', fval_simpson(1,:),fval_simpson(2,:),'-o',fval_overal(1,:),fval_overal(2,:),'-o');
% %loglog( fval_euler(1,:),fval_euler(2,:),'-o',fval_trapezoidal(1,:),fval_trapezoidal(2,:),'-o', fval_simpson(1,:),fval_simpson(2,:),'-o');
% legend('Euler', 'Trapezoidal', 'Simpson', 'Combined');
% xlabel('Performance'); ylabel('CPU time');

% compare full design exploration vs optimization based approach
loglog( f_val_exploration(1,:),f_val_exploration(2,:),'o', fval_overal(1,:),fval_overal(2,:),'-o');
xlabel('Performance'); ylabel('CPU time');
axis([0,0.03,0,0.5]);