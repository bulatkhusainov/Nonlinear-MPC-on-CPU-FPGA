% opts = nomadset('display_degree',2,'bb_output_type','obj obj');
% 
% 
% 
% % set options
% opts.bb_input_type = '[R I I]';
% opts.multi_overall_bb_eval = 200;
% 
% % test with Trapezodiadal
% %x = [Ts; N; Integrator]
% lb = [0.5;   1;   2];
% ub = [  5;  10;   2];
% x0 = [  2;   5;   2];
% [x_trapezoidal,fval_trapezoidal,~,~] = nomad(@wrapper_query_simulation,x0,lb,ub,opts);
% save trapizoidal_results
% 
% % test with Simpson
% % x = [Ts; N; Integrator]
% lb = [0.5;  1;   3];
% ub = [  5; 10;   3];
% x0 = [ 2;  5;  3];
% [x_simpson,fval_simpson,~,~] = nomad(@wrapper_query_simulation,x0,lb,ub,opts);
% save simpson_results
% 
% 
% % test with Euler
% %x = [Ts; N; Integrator]
% lb = [0.5;   1;   1];
% ub = [  5;  10;   1];
% x0 = [ 0.5;  5;   1];
% [x_euler,fval_euler,~,~] = nomad(@wrapper_query_simulation,x0,lb,ub,opts);
% save euler_results
% 
% % test with flexible choice of integrator
% % x = [Ts; N; Integrator]
% opts.multi_overall_bb_eval = 300;
% lb = [0.5;  1;   1];
% ub = [  5; 10;   3];
% x0 = [ 0.5;  5;  2];
% [x_overal,fval_overal,~,~] = nomad(@wrapper_query_simulation,x0,lb,ub,opts);
% save second_experiment


% plot results
loglog( fval_euler(1,:),fval_euler(2,:),'-o',fval_trapezoidal(1,:),fval_trapezoidal(2,:),'-o', fval_simpson(1,:),fval_simpson(2,:),'-o',fval_overal(1,:),fval_overal(2,:),'-o');
%loglog( fval_euler(1,:),fval_euler(2,:),'-o',fval_trapezoidal(1,:),fval_trapezoidal(2,:),'-o', fval_simpson(1,:),fval_simpson(2,:),'-o');
legend('Euler', 'Trapezoidal', 'Simpson', 'Combined');
%set(gcf,'linewidth',1);
xlabel('Performance'); ylabel('CPU time');