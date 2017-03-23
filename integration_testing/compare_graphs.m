
x_trajectory_C = zeros(n_states,N+1);
u_trajectory_C = zeros(m_inputs,N);
s_trajectory_C = zeros(n_node_slack,N);
for i=1:N
    x_trajectory_C(:,i) = all_theta_C((1:n_states) + (i-1)*n_node_theta);
    u_trajectory_C(:,i) = all_theta_C((1:m_inputs) + n_states + (i-1)*n_node_theta);
    s_trajectory_C(:,i) = all_theta_C((1:n_node_slack) + n_states + m_inputs + (i-1)*n_node_theta);
end
x_trajectory_C(:,N+1) = all_theta_C((1:n_states) + (N)*n_node_theta);

subplot(3,3,1); plot((0:N), x_trajectory(1,:),(0:N), x_trajectory_C(1,:)); title('x coordinate'); 
subplot(3,3,2); plot((0:N), x_trajectory(2,:),(0:N), x_trajectory_C(2,:)); title('x speed'); 
subplot(3,3,3); plot((0:N), x_trajectory(3,:),(0:N), x_trajectory_C(3,:)); title('z coordinate'); 
subplot(3,3,4); plot((0:N), x_trajectory(4,:),(0:N), x_trajectory_C(4,:)); title('z speed'); 
subplot(3,3,5); plot((0:N), x_trajectory(5,:),(0:N), x_trajectory_C(5,:)); title('theta'); 
subplot(3,3,6); plot((0:N), x_trajectory(6,:),(0:N), x_trajectory_C(6,:)); title('theta spped'); 
subplot(3,3,7); stairs((0:N-1), [u_trajectory(1,:)'  u_trajectory_C(1,:)']); title('x input'); 
subplot(3,3,8); stairs((0:N-1), [u_trajectory(2,:)' u_trajectory_C(2,:)']); title('z input');