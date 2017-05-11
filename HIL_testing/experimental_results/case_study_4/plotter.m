% for N = 1:10
%     for PAR = [1, N]
%         wrapper_query_simulation([0.1; N; 2; 1; PAR])        
%     end
% end
% 
% for N = 1:10
%     for PAR = [1, N]
%         wrapper_query_simulation([0.1; N; 2; 2; PAR])        
%     end
% end
% 
% for N = 1:10
%     for PAR = [1, N]
%         wrapper_query_simulation([0.1; N; 2; 3; PAR])        
%     end
% end

PAR_range = [1 2 3 4 5 10];
all_data = [];

% read heterogeneous implementations
for N = 1:10
    for PAR = [1, N]

        % read time
        directory = strcat('raw_data/heterogeneous_',num2str(3),'/soc_prototype/test/results/my_project0/N_',num2str(N),'_PAR_',num2str(PAR),'/');
        time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
        time = 1000*str2double(time_data.textdata(1));

        % read resources
        directory = strcat('raw_data/heterogeneous_',num2str(3),'/doc/N_',num2str(N),'_PAR_',num2str(PAR),'/');
        resource_data = importdata(strcat(directory, 'ip_prototype.dat'));
        resource = sqrt((resource_data(13)/53200)^2 + (resource_data(14)/106400)^2 + (resource_data(16)/220)^2 + (resource_data(15)/280)^2);
               
        % add to structure
        strcut_val.time = time;
        strcut_val.resource = resource;
        strcut_val.N = N;
        strcut_val.PAR = PAR;

        all_data = [all_data strcut_val];
    end
end

% % read the only software implementation
% directory = strcat('raw_data/heterogeneous_',num2str(0),'/soc_prototype/test/results/my_project0/');
% time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
% time = str2double(time_data.textdata(1));
% resource = 0;
% strcut_val.time = 1000*time;
% strcut_val.resource = resource;
% strcut_val.heterogeneity = 0;
% all_data = [all_data strcut_val];



% plot the results
PAR_1 =  all_data(find([all_data.PAR]==1));
plot([PAR_1(:).N],[PAR_1(:).resource], 'xk','MarkerSize', 16);
hold on
PAR_N =  all_data(find([all_data.PAR] > 1));
plot([PAR_N(:).N],[PAR_N(:).resource], 'or','MarkerSize', 16);
hold off

%xlim([-0.01 0.3]);
%ylim([10 10^4.5]);

LEG = legend({'$P = 1$', '$P = N$' }, 'Interpreter','latex','Location', 'NorthWest');
set(LEG,'FontSize',18);

set(gca,'FontSize',18)
xlabel({'Horizon length, $N$'},'Interpreter','latex','FontSize', 18);
ylabel({'FPGA resource usage'}, 'Interpreter','latex', 'FontSize', 18);

grid on
print('resource_scaling_horizon','-deps');