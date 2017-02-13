function output = query_simulation(design)

%% generate C code  
cd ../code_generator
generate_c_code;
cd ../HIL_testing

load ../code_generator/problem_data

%% copy C code into a relevant protoip project
files_to_copy = {'user_block.c', 'user_bounds.c', 'user_gradient.c', ...
                 'user_hessians.c', 'user_jacobians.c', 'user_lanczos.c', ...
                 'user_main_header.h', 'user_minres.c', 'user_mv_mult.c', ...
                 'user_mv_mult_prescaled.c', 'user_nlp_solver.c', ...
                 'user_nnz_header.h', 'user_prescaler.c', 'user_prototypes_header.h', ...
                 'user_rec_sol.c', 'user_residual.c'};
for i = files_to_copy
    current_name = i{:};
    copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_0/soc_prototype/src/');
end



%% run relevant protoip project (including synthesis and HIL test)
cd protoip_projects/heterogeneous_0;
run_protoip_project;
cd ../..;


%% calculate output data
output = [performance; cpu_time];

end