%clear;
load('Params_Simscape.mat');

Ts_hw = 0.01; % this samplling time is for actuators PI controllers only
%Ts = 0.1; % this sampling time is for mpc controller
T = 12;

% Filter parameters (for velocity filtering)
cut_period = 0.1;
cut_freq = 2*pi/cut_period;
zeta = 0.7;
cont_filter = tf([cut_freq^2 0],[1 2*cut_freq*zeta cut_freq^2]); % continuous  TF (filter + derivative)
disc_filter = c2d(cont_filter,Ts_hw,'tustin');
filter_numerator = cell2mat(disc_filter.num);
filter_denominator = cell2mat(disc_filter.den);


% % sys id data
% band = [0 0.05]; %  expressed in fractions of the Nyquist frequency
% id_input = 0.2*idinput(ceil(T/Ts_hw)+1,'sine',band,[],[5,5,1]);
% id_input = [(0:Ts_hw:T)' id_input];
% % id_input = id_input(100:301,2);
% % id_output = id_output.signals.values;
% % id_output = id_output(100:301);