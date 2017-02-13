%% Generate structure header file
cd ../src 
file_name = strcat('user_structure_header','.h');
fileID = fopen(file_name,'w');
fprintf(fileID, strcat('#ifndef ',' STRUCT_HEADER\n'));
fprintf(fileID, strcat('#define ',' STRUCT_HEADER\n\n'));

fprintf(fileID, strcat('typedef struct part_vector_tag { \n'));
fprintf(fileID, strcat('\t',d_type,' vec0 = [n_states]; \n'));
fprintf(fileID, strcat('\t',d_type,' vec = [PAR][part_size*(n_node_theta+n_node_eq)]; \n'));
if rem_partition ~= 0
fprintf(fileID, strcat('\t',d_type,' vec_rem = [rem_partition*(n_node_theta+n_node_eq)]; \n'));
end
fprintf(fileID, strcat('\t',d_type,' vec_term = [n_term_theta+n_term_eq]; \n'));
fprintf(fileID, strcat('} part_vector; \n\n'));

fprintf(fileID, strcat('typedef struct part_matrix_tag { \n'));
fprintf(fileID, strcat('\t',d_type,' mat = [PAR][part_size*nnz_block_tril)]; \n'));
if rem_partition ~= 0
fprintf(fileID, strcat('\t',d_type,' mat_rem = [rem_partition*nnz_block_tril]; \n'));
end
fprintf(fileID, strcat('\t',d_type,' mat_term = nnz_term_block_tril; \n'));
fprintf(fileID, strcat('} part_matrix; \n\n'));

fprintf(fileID, '#endif');
fclose(fileID);
cd ../code_generator