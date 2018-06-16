

% for N = 1:10
%     for HG = 1:3
%         [ output ] = wrapper_query_simulation( [0.1; N; 2; HG; 1]);
%     end
% end
% 
% for N = 1:10
%     for HG = 1:3
%         [ output ] = wrapper_query_simulation( [0.1; N; 2; HG; N]);
%     end
% end

for N = 1:10
        [ output ] = wrapper_query_simulation( [0.1; N; 2; 0; 1]);
end


for PAR = 2:5 % PAR = 1 and 10 is explored above
    for HG = 1:3
        [ output ] = wrapper_query_simulation( [0.1; 10; 2; HG; PAR]);
    end
end

