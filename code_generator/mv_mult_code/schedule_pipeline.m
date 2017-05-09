function [ indeces_sched, distance_achieved,  n_NOPs] = schedule_pipeline( indeces, dimension )

%distance required
distance_required = 13;

% unpack data
row_block_NOP = indeces.row_block;
col_block_NOP = indeces.col_block;
num_block_NOP = indeces.num_block;

row_block = row_block_NOP(2:end);
col_block = col_block_NOP(2:end);
num_block = num_block_NOP(2:end);

% take dimensions and allocate memory
nnz_matrix = max(size(row_block)); % number of "true" nonzeros, excluding one artificial zero
indeces_square = zeros(dimension);
for i = 1:dimension
    index = find(row_block == (i-1));
    if ~isempty(index)
        indeces_square(i, 1:max(size(index))) = index;
    end
end
% sort indeces_square according to the number of nz elements
[~,I] = sort(sum(indeces_square~=0,2), 'descend');
indeces_square = indeces_square(I,:);
nnz_per_row = sum(indeces_square~=0,2);
max_nnz_row = max(nnz_per_row);
number_max_nnz_row = max(size(find(nnz_per_row==max_nnz_row)));
n_NOPs = 1;
while(floor((n_NOPs + nnz_matrix-number_max_nnz_row)/(max_nnz_row-1)) < distance_required)
    n_NOPs = n_NOPs + 1;
end
distance_achieved = floor((n_NOPs + nnz_matrix-number_max_nnz_row)/(max_nnz_row-1));
remainder_slot_size = (n_NOPs + nnz_matrix-number_max_nnz_row) - distance_achieved*(max_nnz_row-1);

step_small = distance_achieved;
step_large = distance_achieved + 1;
n_steps_large = remainder_slot_size;
n_steps_small = max_nnz_row -1 - n_steps_large;
steps_vector = [step_large*ones(n_steps_large,1); step_small*ones(n_steps_small,1)];

% allocate memory for the solution
permute_vec = zeros(n_NOPs + nnz_matrix,1);

% put the row with max number of elements into the solution vector
pointer = 1;
for i = 1:max_nnz_row
    for j = (1:number_max_nnz_row)
        permute_vec(pointer+j-1) = indeces_square(j,i);
    end
    if i < max_nnz_row
        pointer = pointer + steps_vector(i);
    end
end

indeces_square_no_max_rows = indeces_square(number_max_nnz_row+1:end,:);
tmp_mat = indeces_square_no_max_rows';
indeces_no_max_rows = tmp_mat(:);
indeces_no_max_rows(indeces_no_max_rows==0) = [];

% put remaining vectors into schedule
current_pointer = 1;
for i = 1:max(size(indeces_no_max_rows))
    % walk until 0 is found
    while(permute_vec(current_pointer) ~= 0)
        current_pointer = current_pointer + 1;
    end
    permute_vec(current_pointer) = indeces_no_max_rows(i);
    current_pointer = current_pointer + 1;
     % walk until non 0 is found
    while(permute_vec(current_pointer) == 0)
        current_pointer = current_pointer + 1;
    end
    if(current_pointer > (n_NOPs + nnz_matrix-number_max_nnz_row))
        current_pointer = 1;
    end
end

% write solution to output vectors
row_block_sched(logical(permute_vec)) = row_block(permute_vec(permute_vec~=0));
col_block_sched(logical(permute_vec)) = col_block(permute_vec(permute_vec~=0));
num_block_sched(logical(permute_vec)) = num_block(permute_vec(permute_vec~=0));


% replace all gaps with -1 to enable testing
row_block_sched(permute_vec==0) = -1;
col_block_sched(permute_vec==0) = -1;
num_block_sched(permute_vec==0) = -1;

% check if the solution is correct
for i=1:dimension
    indeces_same_row = find(row_block_sched == (i-1) );
    for j = 1:(max(size(indeces_same_row))-1)
        if( abs(indeces_same_row(j) - indeces_same_row(j+1)) <  distance_achieved)
            error('Error: scheduling algorithm failed!');
        end
    end
end

% replace all gaps with NOP entry
row_block_sched(permute_vec==0) = row_block_NOP(1);
col_block_sched(permute_vec==0) = col_block_NOP(1);
num_block_sched(permute_vec==0) = num_block_NOP(1);

% write solution to output vectors
indeces_sched.row_block_sched = row_block_sched;
indeces_sched.col_block_sched = col_block_sched;
indeces_sched.num_block_sched = num_block_sched;
end

%% solution with NOPs (for unknown reason di not work on FPGA)
%distance required
% distance_required = 10;
% 
% % unpack data
% row_block_NOP = indeces.row_block;
% col_block_NOP = indeces.col_block;
% num_block_NOP = indeces.num_block;
% 
% row_block = row_block_NOP(2:end);
% col_block = col_block_NOP(2:end);
% num_block = num_block_NOP(2:end);
% 
% % take dimensions and allocate memory
% nnz_matrix = max(size(row_block)); % number of "true" nonzeros, excluding one artificial zero
% indeces_square = zeros(dimension);
% for i = 1:dimension
%     index = find(row_block == (i-1));
%     if ~isempty(index)
%         indeces_square(i, 1:max(size(index))) = index;
%     end
% end
% % sort indeces_square according to the number of nz elements
% [~,I] = sort(sum(indeces_square~=0,2), 'descend');
% indeces_square = indeces_square(I,:);
% nnz_per_row = sum(indeces_square~=0,2);
% max_nnz_row = max(nnz_per_row);
% number_max_nnz_row = max(size(find(nnz_per_row==max_nnz_row)));
% n_NOPs = 1;
% while(floor((n_NOPs + nnz_matrix-number_max_nnz_row)/(max_nnz_row-1)) < distance_required)
%     n_NOPs = n_NOPs + 1;
% end
% distance_achieved = floor((n_NOPs + nnz_matrix-number_max_nnz_row)/(max_nnz_row-1));
% remainder_slot_size = (n_NOPs + nnz_matrix-number_max_nnz_row) - distance_achieved*(max_nnz_row-1);
% 
% step_small = distance_achieved;
% step_large = distance_achieved + 1;
% n_steps_large = remainder_slot_size;
% n_steps_small = max_nnz_row -1 - n_steps_large;
% steps_vector = [step_large*ones(n_steps_large,1); step_small*ones(n_steps_small,1)];
% 
% % allocate memory for the solution
% permute_vec = zeros(n_NOPs + nnz_matrix,1);
% 
% % put the row with max number of elements into the solution vector
% pointer = 1;
% for i = 1:max_nnz_row
%     for j = (1:number_max_nnz_row)
%         permute_vec(pointer+j-1) = indeces_square(j,i);
%     end
%     if i < max_nnz_row
%         pointer = pointer + steps_vector(i);
%     end
% end
% 
% indeces_square_no_max_rows = indeces_square(number_max_nnz_row+1:end,:);
% tmp_mat = indeces_square_no_max_rows';
% indeces_no_max_rows = tmp_mat(:);
% indeces_no_max_rows(indeces_no_max_rows==0) = [];
% 
% % put remaining vectors into schedule
% current_pointer = 1;
% for i = 1:max(size(indeces_no_max_rows))
%     % walk until 0 is found
%     while(permute_vec(current_pointer) ~= 0)
%         current_pointer = current_pointer + 1;
%     end
%     permute_vec(current_pointer) = indeces_no_max_rows(i);
%     current_pointer = current_pointer + 1;
%      % walk until non 0 is found
%     while(permute_vec(current_pointer) == 0)
%         current_pointer = current_pointer + 1;
%     end
%     if(current_pointer > (n_NOPs + nnz_matrix-number_max_nnz_row))
%         current_pointer = 1;
%     end
% end
% 
% % write solution to output vectors
% row_block_sched(logical(permute_vec)) = row_block(permute_vec(permute_vec~=0));
% col_block_sched(logical(permute_vec)) = col_block(permute_vec(permute_vec~=0));
% num_block_sched(logical(permute_vec)) = num_block(permute_vec(permute_vec~=0));
% 
% 
% % replace all gaps with -1 to enable testing
% row_block_sched(permute_vec==0) = -1;
% col_block_sched(permute_vec==0) = -1;
% num_block_sched(permute_vec==0) = -1;
% 
% % check if the solution is correct
% for i=1:dimension
%     indeces_same_row = find(row_block_sched == (i-1) );
%     for j = 1:(max(size(indeces_same_row))-1)
%         if( abs(indeces_same_row(j) - indeces_same_row(j+1)) <  distance_achieved)
%             error('Error: scheduling algorithm failed!');
%         end
%     end
% end
% 
% % replace all gaps with NOP entry
% row_block_sched(permute_vec==0) = row_block_NOP(1);
% col_block_sched(permute_vec==0) = col_block_NOP(1);
% num_block_sched(permute_vec==0) = num_block_NOP(1);
% 
% % write solution to output vectors
% indeces_sched.row_block_sched = row_block_sched;
% indeces_sched.col_block_sched = col_block_sched;
% indeces_sched.num_block_sched = num_block_sched;

%% first custom solution
% % unpack data
% row_block = indeces.row_block;
% col_block = indeces.col_block;
% num_block = indeces.num_block;
% 
% % take dimensions and allocate memory
% nnz_matrix = max(size(row_block));
% indeces_square = zeros(dimension);
% for i = 1:dimension
%     index = find(row_block == (i-1));
%     indeces_square(i, 1:max(size(index))) = index;
% end
% % sort indeces_square according to the number of nz elements
% [~,I] = sort(sum(indeces_square~=0,2), 'descend');
% indeces_square = indeces_square(I,:);
% nnz_per_row = sum(indeces_square~=0,2);
% max_nnz_row = max(nnz_per_row);
% step = ceil(nnz_matrix/max_nnz_row);
% distance_achieved = step - 1;
% 
% % check whether this matrix can be scheduled
% n_max_nnz_row = max(size(find(nnz_per_row == max_nnz_row)));
% if ~((step*(max_nnz_row-1) + n_max_nnz_row - 1) < nnz_matrix)
%     error('This matrix cannot be scheduled! Try adding more nonzeros to the row with max number of nonzeros.')
% end
% 
% % allocate memory for the solution
% permute_vec = zeros(nnz_matrix,1);
% % put the largest group into the solution vector
% pointer = 1;
% for i = 1:max(nnz_per_row)
%     permute_vec(pointer) = indeces_square(1,i);
%     pointer = pointer + step;
% end
% 
% % full the solution with the remaing groups
% nnz_per_row_left = nnz_per_row;
% current_group = 2;
% pointer = 1;
% while true
%     if(~permute_vec(pointer)) % if the current slot is free
%         if(nnz_per_row_left(current_group))
%             permute_vec(pointer) = indeces_square(current_group, nnz_per_row_left(current_group));
%             nnz_per_row_left(current_group) = nnz_per_row_left(current_group) - 1;
%             pointer = pointer + step;
%             if pointer > nnz_matrix; pointer = 1; end;
%         else
%             if current_group == 39
%             end
%             current_group = current_group + 1;
%             if current_group > dimension; break; end;
%         end
%     else
%         pointer = pointer + 1;
%         if pointer > nnz_matrix; pointer = 1; end;
%     end
%     if ~max(nnz_per_row_left(2:end))
%         break;
%     end
% end
% 
% indeces_sched.row_block_sched = row_block(permute_vec);
% indeces_sched.col_block_sched = col_block(permute_vec);
% indeces_sched.num_block_sched = num_block(permute_vec);


%% optimization based solution
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
