function [ output ] = wrapper_query_simulation( x )


% structure that defines design parameters
design.Ts = x(1);
design.N = x(2);
design.Integrator = x(3);
design.heterogeneity = x(4);
design.PAR = x(5);

output = query_simulation(design);

end

