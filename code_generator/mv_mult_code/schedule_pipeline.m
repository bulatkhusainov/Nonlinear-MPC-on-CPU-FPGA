function [ indeces_sched, ii_achieved ] = schedule_pipeline( indeces, ii_required, dimension )

% unpack data
row_block = indeces.row_block;
col_block = indeces.col_block;
num_block = indeces.num_block;

% take dimensions and allocate memory
row_block_sched = zeros(size(row_block));
col_block_sched = zeros(size(row_block));
num_block_sched = zeros(size(row_block));
nnz = max(size(row_block));
nnz_per_row = zeros(1, dimension);
same_row_indeces = zeros(1,nnz);

counter = 0;
for i = 1:dimension
    index = find(row_block == (i-1));
    nnz_per_row(i) = max(size(index));
    same_row_indeces(counter + (1:max(size(index))) ) = index;
    counter = counter + max(size(index));
end

x = intvar(nnz,1);
ii = intvar(1,1);
F = [alldifferent(x), 1<=x<=nnz];
counter = 0;
for i = 1:dimension
    for j = 1:(nnz_per_row(i)-1)
        F = [F, (x(same_row_indeces(counter+j)) - x(same_row_indeces(counter+j+1))) >= 8];      
    end
    counter = counter + nnz_per_row(i);
end
ops = sdpsettings('solver','Intlinprog');
ops.verbose = 5;
ops.showprogress = 1;
%ops.intlinprog = ''
%ops = sdpsettings('solver','bnb');
optimize(F, [], ops);

% F = [F,ii <= ii_required];
% ops = sdpsettings('solver','Intlinprog');
% optimize(F, -ii+ii_required, ops);


permute_vec = int16(round(value(x)));

row_block_sched(permute_vec) = row_block;
col_block_sched(permute_vec) = col_block;
num_block_sched(permute_vec) = num_block;
indeces_sched.row_block_sched = row_block_sched;
indeces_sched.col_block_sched = col_block_sched;
indeces_sched.num_block_sched = num_block_sched;

ii_achieved = round(value(ii));
end

