function [output_string] = variables_declaration(varargin)

output_string = '';
data_type = 'float';


for i=1:nargin
    if strcmp(varargin(i),'2d')
        %if input is a matrix
        input_size = size(varargin{i+1});
        output_string = strcat(output_string, sprintf(strcat(data_type,32,inputname(i+1),...
        '[',num2str(input_size(1)),'][',num2str(input_size(2)),']',32,'= {\n')));
        var_name = cell2mat(varargin(i+1));
        output_string = strcat(output_string, sprintf('%2.16f,' , reshape(var_name.',[],1)),'};');
%         for k=1:input_size(1)
%             output_string = strcat(output_string, sprintf('{'));
%             for j=1:input_size(2)
%                 output_string = strcat(output_string,sprintf('%2.16f,', var_name(k,j)));
%             end
%             output_string = strcat(output_string, sprintf('},'));
%             output_string = strcat(output_string, sprintf( char(10)));
%         end
%        output_string = strcat(output_string, sprintf('}; \n'));  
        
    elseif strcmp(varargin(i),'1d')
        % if input is a vector
        input_size = size(varargin{i+1});
        var_name = cell2mat(varargin(i+1));
        output_string = strcat(output_string,sprintf(strcat(data_type,32, inputname(i+1),...
                '[',num2str(max(input_size(1),input_size(2))),']',32,'=',32,'{ ') ));
        output_string = strcat(output_string, sprintf('%2.16f,' , var_name),'};');
            
%        max_counter = max(input_size(1),input_size(2));
%         for j=1:max_counter
%             output_string = strcat(output_string,sprintf('%2.16f,', var_name(j)));
%         end
%         output_string = strcat(output_string,sprintf('}; \n'));
        
    elseif strcmp(varargin(i),'var')
        % if input is a variable
        output_string = strcat(output_string,sprintf(strcat(data_type, 32, inputname(i+1),32, '= %2.16f;\n'), varargin{i+1}));      
    elseif strcmp(varargin(i),'def')
        % if input is a define variable
        output_string = strcat(output_string,sprintf(strcat('#define', 32, inputname(i+1),32, '%d\n'), varargin{i+1}));
    end
                 
end
