%% run simulations
% for PAR=1:10
%     wrapper_query_simulation([0.1; 10; 2; 1; PAR]);
% end
% for PAR=1:10
%     wrapper_query_simulation([0.1; 10; 2; 2; PAR]);
% end
% for PAR=1:10
%     wrapper_query_simulation([0.1; 10; 2; 3; PAR]);
% end
% 

%% read data

PAR_range = [1 2 3 4 5 10];
all_data = [];

% read heterogeneous implementations
for heterogeneity = [1 2 3]
    for PAR = PAR_range

        % read time
        directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/soc_prototype/test/results/my_project0/N_10_PAR_',num2str(PAR),'/');
        time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
        time = 1000*str2double(time_data.textdata(1));

        % read resources
        directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/doc/N_10_PAR_',num2str(PAR),'/');
        resource_data = importdata(strcat(directory, 'ip_prototype.dat'));
        resource = sqrt((resource_data(13)/53200)^2 + (resource_data(14)/106400)^2 + (resource_data(16)/220)^2 + (resource_data(15)/280)^2);

        % add to structure
        strcut_val.time = time;
        strcut_val.resource = resource;
        strcut_val.heterogeneity = heterogeneity;

        all_data = [all_data strcut_val];
    end
end

% read the only software implementation
directory = strcat('raw_data/heterogeneous_',num2str(0),'/soc_prototype/test/results/my_project0/N_10_PAR_1/');
time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
time = str2double(time_data.textdata(1));
resource = 0;
strcut_val.time = 1000*time;
strcut_val.resource = resource;
strcut_val.heterogeneity = 0;
all_data = [all_data strcut_val];



% plot the results
HG0 =  all_data(find([all_data.heterogeneity]==0));
semilogy([HG0(:).resource],[HG0(:).time], 'ok','MarkerSize', 16);
hold on
HG1 =  all_data(find([all_data.heterogeneity]==1));
semilogy([HG1(:).resource],[HG1(:).time], 'xr','MarkerSize', 16);
hold on
HG2 =  all_data(find([all_data.heterogeneity]==2));
semilogy([HG2(:).resource],[HG2(:).time], '*b','MarkerSize', 16);
hold on
HG3 =  all_data(find([all_data.heterogeneity]==3));
semilogy([HG3(:).resource],[HG3(:).time], 'dm','MarkerSize', 16);
hold off
xlim([-0.02 0.6]);
ylim([10 10^4.5]);

LEG = legend({'SW','HG$_1$','HG$_2$','HG$_3$' }, 'Interpreter','latex');
set(LEG,'FontSize',18);

set(gca,'FontSize',18)
xlabel('FPGA Resource usage','FontSize', 18);
ylabel('Algorithm execution time, ms', 'FontSize', 18);

grid on

% put text on the plot
tmp_vector = [[HG1(:).resource]; [HG1(:).time] ];
x1 = tmp_vector(1,1) ;
y1 = tmp_vector(2,1)+1300; 
text(x1,y1,'$\swarrow ^{P = 1}$','FontSize', 24,'Interpreter','latex');
x1 = tmp_vector(1,6) ;
y1 = tmp_vector(2,6)+1300; 
text(x1,y1,'$\swarrow ^{P = N = 10}$','FontSize', 24,'Interpreter','latex');

tmp_vector = [[HG2(:).resource]; [HG2(:).time] ];
x1 = tmp_vector(1,1)-0.11 ;
y1 = tmp_vector(2,1)-300; 
text(x1,y1,'$_{P = 1} \nearrow$','FontSize', 24,'Interpreter','latex');
x1 = tmp_vector(1,6)-0.16 ;
y1 = tmp_vector(2,6)-300; 
text(x1,y1,'$_{P = N = 10} \nearrow$','FontSize', 24,'Interpreter','latex');

tmp_vector = [[HG3(:).resource]; [HG3(:).time] ];
x1 = tmp_vector(1,1)-0.11 ;
y1 = tmp_vector(2,1)-70; 
text(x1,y1,'$_{P = 1} \nearrow$','FontSize', 24,'Interpreter','latex');
x1 = tmp_vector(1,6)-0.16 ;
y1 = tmp_vector(2,6)-40; 
text(x1,y1,'$_{P = N = 10} \nearrow$','FontSize', 24,'Interpreter','latex');

print('time_vs_resource_usage','-deps');
print('time_vs_resource_usage','-dpng');

