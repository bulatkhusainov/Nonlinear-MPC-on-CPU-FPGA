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
for heterogeneity = 1:3
    for N = 1:10
        for PAR = [1, N]

            % read time
            directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/soc_prototype/test/results/my_project0/N_',num2str(N),'_PAR_',num2str(PAR),'/');
            time_data = importdata(strcat(directory, 'fpga_time_log.dat'));
            time = 1000*str2double(time_data.textdata(1));

            % read resources
            directory = strcat('raw_data/heterogeneous_',num2str(heterogeneity),'/doc/N_',num2str(N),'_PAR_',num2str(PAR),'/');
            resource_data = importdata(strcat(directory, 'ip_prototype.dat'));
            resource = sqrt((resource_data(13)/53200)^2 + (resource_data(14)/106400)^2 + (resource_data(16)/220)^2 + (resource_data(15)/280)^2);

            % add to structure
            strcut_val.time = time;
            strcut_val.heterogeneity = heterogeneity;    
            strcut_val.resource = resource;
            strcut_val.LUT  = resource_data(13);
            strcut_val.FF   = resource_data(14);
            strcut_val.DSP  = resource_data(16);
            strcut_val.BRAM = resource_data(15);            
            strcut_val.N = N;
            strcut_val.PAR = PAR;

            all_data = [all_data strcut_val];
        end
    end
end

data_tmp = all_data(find([all_data.heterogeneity]==3)); % change the number to plot tables for other HG_

N = [data_tmp.N]';
P = [data_tmp.PAR]';
time = [data_tmp.time]';
LUT = [data_tmp.LUT]';
FF = [data_tmp.FF]';
DSP = [data_tmp.DSP]';
BRAM = [data_tmp.BRAM]';
T = table(N, P, time, LUT, FF, DSP, BRAM);

% Now use this table as input in our input struct:
input.data = T;

% Switch transposing/pivoting your table if needed:
input.transposeTable = 0;

% Switch to generate a complete LaTex document or just a table:
input.makeCompleteLatexDocument = 0;

latex = latexTable(input)
