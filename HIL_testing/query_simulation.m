function output = query_simulation(design)

%% generate C code  
cd ../code_generator
generate_c_code;
cd ../HIL_testing

load ../code_generator/problem_data

%% copy C code into a relevant protoip project
if heterogeneity == 0 % pure software realization
    files_to_copy = {'user_block.c', 'user_bounds.c', 'user_gradient.c', ...
                     'user_hessians.c', 'user_jacobians.c', 'user_lanczos.c', ...
                     'user_main_header.h', 'user_minres.c', 'user_mv_mult.c', ...
                     'user_mv_mult_prescaled.c', 'user_nlp_solver.c', ...
                     'user_nnz_header.h', 'user_prescaler.c', 'user_prototypes_header.h', ...
                     'user_rec_sol.c', 'user_residual.c', 'user_structure_header.h', 'test_HIL.m'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_0/soc_prototype/src/');
    end
elseif heterogeneity == 1  % accelerate mat-vec on HW
    files_to_copy = {'user_block.c', 'user_bounds.c', 'user_gradient.c', ...
                     'user_hessians.c', 'user_jacobians.c', 'user_lanczos.c', ...
                     'user_main_header.h', 'user_minres.c', 'user_nlp_solver.c', ...
                     'user_nnz_header.h', 'user_prescaler.c', 'user_prototypes_header.h', ...
                     'user_rec_sol.c', 'user_residual.c', 'user_structure_header.h', 'test_HIL.m'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_1/soc_prototype/src/');
    end
    files_to_copy = {'user_main_header.h', 'user_nnz_header.h', 'user_prototypes_header.h', ...
                     'user_structure_header.h'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_1/ip_design/src/');
    end
    files_to_copy = {'user_mv_mult_prescaled_HW.c'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),strcat('protoip_projects/heterogeneous_1/ip_design/src/',current_name,'pp'));
    end

elseif heterogeneity == 2  % accelerate lanczos kernel on HW
    files_to_copy = {'user_block.c', 'user_bounds.c', 'user_gradient.c', ...
                     'user_hessians.c', 'user_jacobians.c', ...
                     'user_main_header.h', 'user_minres.c', 'user_nlp_solver.c', ...
                     'user_nnz_header.h', 'user_prescaler.c', 'user_prototypes_header.h', ...
                     'user_rec_sol.c', 'user_residual.c', 'user_structure_header.h', 'test_HIL.m'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_2/soc_prototype/src/');
    end
    
    files_to_copy = {'user_main_header.h', 'user_nnz_header.h', 'user_prototypes_header.h', ...
                     'user_structure_header.h'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_2/ip_design/src/');
    end
    files_to_copy = {'user_mv_mult_prescaled_HW.c','user_lanczos_HW.c'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),strcat('protoip_projects/heterogeneous_2/ip_design/src/',current_name,'pp'));
    end
    
elseif heterogeneity == 3  % accelerate MINRES on HW
     files_to_copy = {'user_block.c', 'user_bounds.c', 'user_gradient.c', ...
                     'user_hessians.c', 'user_jacobians.c', ...
                     'user_main_header.h', 'user_nlp_solver.c', ...
                     'user_nnz_header.h', 'user_prescaler.c', 'user_prototypes_header.h', ...
                     'user_rec_sol.c', 'user_residual.c', 'user_structure_header.h','test_HIL.m'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_3/soc_prototype/src/');
    end
    
    files_to_copy = {'user_main_header.h', 'user_nnz_header.h', 'user_prototypes_header.h', ...
                     'user_structure_header.h'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),'protoip_projects/heterogeneous_3/ip_design/src/');
    end
    
    files_to_copy = {'user_mv_mult_prescaled_HW.c','user_lanczos_HW.c','user_minres_HW.c'};
    for i = files_to_copy
        current_name = i{:};
        copyfile(strcat('../src/',current_name),strcat('protoip_projects/heterogeneous_3/ip_design/src/',current_name,'pp'));
    end
    
    
end


%% run relevant protoip project (including synthesis and HIL test)
protoip_dir = strcat('protoip_projects/heterogeneous_', num2str(heterogeneity));
cd(protoip_dir);
run_protoip_project;
cd ../..;


% %% calculate output data
% output = [performance; cpu_time];
output = 1;
end