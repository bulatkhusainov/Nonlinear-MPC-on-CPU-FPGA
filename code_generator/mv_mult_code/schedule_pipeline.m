function [ indeces_sched, distance_achieved ] = schedule_pipeline( indeces, dimension )

% unpack data
row_block = indeces.row_block;
col_block = indeces.col_block;
num_block = indeces.num_block;

% take dimensions and allocate memory
nnz_matrix = max(size(row_block));
indeces_square = zeros(dimension);
for i = 1:dimension
    index = find(row_block == (i-1));
    indeces_square(i, 1:max(size(index))) = index;
end
% sort indeces_square according to the number of nz elements
[~,I] = sort(sum(indeces_square~=0,2), 'descend');
indeces_square = indeces_square(I,:);
nnz_per_row = sum(indeces_square~=0,2);
max_nnz_row = max(nnz_per_row);
step = ceil(nnz_matrix/max_nnz_row);
distance_achieved = step - 1;

% check whether this matrix can be scheduled
n_max_nnz_row = max(size(find(nnz_per_row == max_nnz_row)));
if ~((step*(max_nnz_row-1) + n_max_nnz_row - 1) < nnz_matrix)
    error('This matrix cannot be scheduled! Try adding more nonzeros to the row with max number of nonzeros.')
end

% allocate memory for the solution
permute_vec = zeros(nnz_matrix,1);
% put the largest group into the solution vector
pointer = 1;
for i = 1:max(nnz_per_row)
    permute_vec(pointer) = indeces_square(1,i);
    pointer = pointer + step;
end

% full the solution with the remaing groups
nnz_per_row_left = nnz_per_row;
current_group = 2;
pointer = 1;
while true
    if(~permute_vec(pointer)) % if the current slot is free
        if(nnz_per_row_left(current_group))
            permute_vec(pointer) = indeces_square(current_group, nnz_per_row_left(current_group));
            nnz_per_row_left(current_group) = nnz_per_row_left(current_group) - 1;
            pointer = pointer + step;
            if pointer > nnz_matrix; pointer = 1; end;
        else
            if current_group == 39
            end
            current_group = current_group + 1;
            if current_group > dimension; break; end;
        end
    else
        pointer = pointer + 1;
        if pointer > nnz_matrix; pointer = 1; end;
    end
    if ~max(nnz_per_row_left(2:end))
        break;
    end
end

indeces_sched.row_block_sched = row_block(permute_vec);
indeces_sched.col_block_sched = col_block(permute_vec);
indeces_sched.num_block_sched = num_block(permute_vec);

end


% x = intvar(nnz,1);
% ii = intvar(1,1);
% F = [alldifferent(x), 1<=x<=nnz];
% counter = 0;
% for i = 1:dimension
% %     for j = 1:(nnz_per_row(i)-1)
% %         F = [F, (x(same_row_indeces(counter+j)) - x(same_row_indeces(counter+j+1))) >= 1];      
% %     end
% %     counter = counter + nnz_per_row(i);
%     if(nnz_per_row(i) > 1) % if the is only one nn element in a row it can be scheduled to any queue number
%         combos = int16(combntns(1:nnz_per_row(i),2));
%         for j = 1:size(combos,1)
%             F = [F, abs(x(same_row_indeces(counter+combos(j,1))) - x(same_row_indeces(counter+combos(j,2)))) >= 8];  
%         end
%     end
%     counter = counter + nnz_per_row(i);
%     
% end
% ops = sdpsettings('solver','Intlinprog');
% ops.verbose = 5;
% ops.showprogress = 1;
% %ops.intlinprog = ''
% %ops = sdpsettings('solver','bnb');
% optimize(F, [], ops);
% 
% % F = [F,ii <= ii_required];
% % ops = sdpsettings('solver','Intlinprog');
% % optimize(F, -ii+ii_required, ops);
% 
% 
% permute_vec = int16(round(value(x)));
