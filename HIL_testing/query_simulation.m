function output = query_simulation(design)

%% generate C code  
cd ../code_generator
generate_c_code;
cd ../HIL_testing


%% copy C code into a relevant protoip project


%% run relevant protoip project (including synthesis and HIL test)


end