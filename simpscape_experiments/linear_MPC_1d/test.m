clear;
load('Params_Simscape.mat');

Ts = 0.01; % this samplling time is for the crane simulation only
T = 10;

% Filter parameters (for velocity filtering)
cut_period = 0.1;
cut_freq = 2*pi/cut_period;
zeta = 0.7;
cont_filter = tf([cut_freq^2 0],[1 2*cut_freq*zeta cut_freq^2]); % continuous  TF (filter + derivative)
disc_filter = c2d(cont_filter,Ts,'tustin');
filter_numerator = cell2mat(disc_filter.num);
filter_denominator = cell2mat(disc_filter.den);

% linear model
tau_x = 1/7.5;
rope_l = 0.47;
g = 9.81;
n = 4;
m = 1;
A_c = zeros(n);
B_c = zeros(n,m);
A_c(1,2) = 1;
A_c(2,2) = -1/tau_x;
A_c(3,4) = 1;
A_c(4,2) = 1/(rope_l*tau_x);
A_c(4,3) = -g/rope_l;
B_c(2,1) = 1/tau_x;
B_c(4,1) = -1/(rope_l*tau_x);
sys_c = ss(A_c,B_c,eye(n),zeros(n,m));

% MPC parameters
N = 30;
Ts_mpc = 0.1;
Q = eye(n); Q(1,1) = 2; Q(2,2) = 1;
R = 0.1*eye(m);
sys_d = c2d(sys_c, Ts_mpc);
A = sys_d.A;
B = sys_d.B;

% generate QP matrices
Q_big = kron(eye(N), Q);
Q_big = blkdiag(Q_big, Q);
R_big = kron(eye(N), R);
A_big = [];
for i=0:N
    A_big = [A_big; A^i];
end
B_inter = zeros(size(B));
for i=0:N-1
    B_inter = [B_inter; (A^i)*B];
end
B_big = [];
for i=0:(N-1)
    shifted = circshift(B_inter,[i*n,0]);
    shifted(1:i*n, :) = zeros(i*n, m);
    B_big = [B_big shifted];
end
H = B_big'*Q_big*B_big + R_big;
h_x =  A_big'*Q_big*B_big; %h = X'*h_x;



x_init = [0.427;0.0786;-0.0630;-0.2242]; % random initial condition for OL test
h = x_init' * h_x;
u_opt = quadprog(H,h);

%plot the OL solution
u_opt = u_opt';
x_trajectory = zeros(n,N+1);
x_trajectory(:,1) = x_init;
for i = 1:N
    x_trajectory(:, i+1) = A*x_trajectory(:, i) + B*u_opt(:, i);
    %x_trajectory(:, i+1) = A*x_trajectory(:, i) ;
end


% % sys id data
% band = [0 0.05]; %  expressed in fractions of the Nyquist frequency
% id_input = 0.2*idinput(ceil(T/Ts)+1,'sine',band,[],[5,5,1]);
% id_input = [(0:Ts:T)' id_input];
% % id_input = id_input(100:301,2);
% % id_output = id_output.signals.values;
% % id_output = id_output(100:301);