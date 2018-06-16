%% read data
all_data = [];
heterogeneity = 3;

% read heterogeneous implementations
for N = 1:10
    for PAR = [1 N] % PAR = [1] for heterogeneity == 0

        % read time
        directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/soc_prototype/test/results/my_project0/N_',num2str(N),'_PAR_',num2str(PAR),'/');
        time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
        time = 1000*str2double(time_data.textdata(1));
        
        if heterogeneity > 0 
            % read resources
            directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/doc/N_',num2str(N),'_PAR_',num2str(PAR),'/');
            resource_data = importdata(strcat(directory, 'ip_prototype.dat'));
            resource = sqrt((resource_data(13)/53200)^2 + (resource_data(14)/106400)^2 + (resource_data(16)/220)^2 + (resource_data(15)/280)^2);
        end
        
        % add to structure
        strcut_val.time = time;
        
        if heterogeneity > 0 
            strcut_val.lut = resource_data(13);
            strcut_val.ff = resource_data(14);
            strcut_val.dsp = resource_data(16);
            strcut_val.bram = resource_data(15);
            strcut_val.resource = resource;
            strcut_val.heterogeneity = heterogeneity;
        end
            
        all_data = [all_data strcut_val];
    end
end
