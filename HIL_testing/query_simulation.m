function output = query_simulation(design)

%% generate C code  
cd ../code_generator
generate_c_code;
cd ../HIL_testing

load ../code_generator/problem_data

%% copy C code into a relevant protoip project
copyfile('../src/user*','protoip_projects/heterogeneous_0/soc_prototype/src/');


%% run relevant protoip project (including synthesis and HIL test)
cd protoip_projects/heterogeneous_0;
run_protoip_project;
cd ../..;


%% calculate output data
output = [performance; cpu_time];

end