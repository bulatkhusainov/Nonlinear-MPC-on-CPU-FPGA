%% Generate nnz header file
cd ../src 
file_name = strcat('user_nnz_header','.h');
fileID = fopen(file_name,'w');
fprintf(fileID, strcat('#ifndef ',' NNZ_HEADER\n'));
fprintf(fileID, strcat('#define ',' NNZ_HEADER\n\n'));


fprintf(fileID, '//nnz for nodes \n');
fprintf(fileID, '#define nnz_block %d   \n',nnz_block);
fprintf(fileID, '#define nnz_block_tril %d   \n',nnz_block_tril);
fprintf(fileID, '#define nnz_node_hessian_tril %d   \n',nnz_node_hessian_tril);
fprintf(fileID, '#define nnz_f_jac %d   \n',nnz_f_jac);
fprintf(fileID, '#define nnz_gwg %d   \n\n',nnz_gwg);

fprintf(fileID, '//nnz for terminal node \n');
fprintf(fileID, '#define nnz_term_block %d   \n',nnz_term_block);
fprintf(fileID, '#define nnz_term_block_tril %d   \n',nnz_term_block_tril);
fprintf(fileID, '#define nnz_term_hessian_tril %d   \n',nnz_term_hessian_tril);
fprintf(fileID, '#define nnz_term_f_jac %d   \n\n',nnz_term_f_jac);


fprintf(fileID, '#endif');
fclose(fileID);
cd ../code_generator