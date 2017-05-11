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
        directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/soc_prototype/test/results/my_project0/PAR_',num2str(PAR),'/');
        time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
        time = 1000*str2double(time_data.textdata(1));

        % read resources
        directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/doc/PAR_',num2str(PAR),'/');
        resource_data = importdata(strcat(directory, 'ip_prototype.dat'));
        resource = (resource_data(13)/53200)^2 + (resource_data(14)/106400)^2 + (resource_data(16)/220)^2 + (resource_data(15)/280)^2;

        % add to structure
        strcut_val.time = time;
        strcut_val.resource = resource;

        all_data = [all_data strcut_val];
    end
end

% read the only software implementation
directory = strcat('raw_data/heterogeneous_',num2str(0),'/soc_prototype/test/results/my_project0/');
time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
time = str2double(time_data.textdata(1));
resource = 0;
strcut_val.time = 1000*time;
strcut_val.resource = resource;
all_data = [all_data strcut_val];



% plot the results
semilogy([all_data(:).resource],[all_data(:).time], 'ok','MarkerSize', 10);
set(gca,'FontSize',18)
xlabel('Resource usage','FontSize', 18);
ylabel('Algorithm execution time, ms', 'FontSize', 18);
my_leg.FontSize = 18;
grid on
%print('performacne_vs_resource_usage','-deps');

