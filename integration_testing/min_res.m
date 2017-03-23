function x_current = min_res(A,b)
  %  given
%     A = rand(10,10); A = A+A';
%     b = rand(10,1);
%     x0 = rand(10,1);

    %A = sparse(A);

    %initialisation

    x_current = single(zeros(size(b))); %solution guess

    v_prev =  single(zeros(size(b))); %initial Lanczos vectors
    v_current = b;% - A*x_current;

    beta_current = single(sqrt(v_current'*v_current)) ;

    nu_current = beta_current;

    gamma_prev = single(1);
    gamma_current = single(1);

    sigma_prev = single(0);
    sigma_current = single(0);

    omega_prev = single(0);
    omega_pprev = single(0);

    i = 0;
   
    %Q = [v_current/beta_current]; %orthonormal matrix - basis for Krylov subspace

    %while(i < size(A,1)+1)
    while( norm(nu_current)> 1e-6 && i < round(0.6*max(size(A)))       )
    %for i = 1:round(0.5*max(size(A))) 
    %for i = 1:5


    %calculate Lanczos Vectors
    v_current = v_current/beta_current;
    A_mult_v_current = A*v_current;
    alfa_current = v_current'*A_mult_v_current;
    v_new = A_mult_v_current - alfa_current*v_current - beta_current*v_prev;
    beta_new = sqrt(v_new'*v_new);

    %Q = [Q v_new/beta_new]; % update orthonormal matrix

    %calculate QR factors
    delta = gamma_current*alfa_current - gamma_prev*sigma_current*beta_current;
    ro_1 = sqrt(delta^2 + beta_new^2);
    ro_2 = sigma_current*alfa_current + gamma_prev*gamma_current*beta_current;
    ro_3 = sigma_prev*beta_current;

    %calculate Givens rotation
    gamma_new = delta/ro_1;
    sigma_new = beta_new/ro_1;

    %update solution
    omega_current = (v_current - ro_3*omega_pprev - ro_2*omega_prev)/ro_1;
    x_new = x_current + gamma_new*nu_current*omega_current;
    nu_new = -sigma_new*nu_current;

    %update variables
    x_current = x_new;

    v_prev = v_current;
    v_current = v_new;
    beta_current = beta_new;

    nu_current = nu_new;

    gamma_prev = gamma_current;
    gamma_current = gamma_new;

    sigma_prev = sigma_current;
    sigma_current = sigma_new;

    omega_pprev = omega_prev;
    omega_prev = omega_current;

    i = i + 1;
    
  
    

    end
end


