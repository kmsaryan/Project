clc;
clear;
% Parameters
lambda_high = 0.2 ;  % High priority arrival rate
lambda_low = 0.8; % Low priority arrival rate 
mu = 0.15;        % Service rate
num_desks = 3;    % Number of servers (desks)
sim_time = 150;  % Total simulation time
disp('Parameters considered')
disp(['High priority arrival rate: ',num2str(lambda_high)])
disp(['Low priority arrival rate: ',num2str(lambda_low)])
disp(['Service rate: ' ,num2str(num_desks)])
disp(['Total simulation time: ',num2str(sim_time)])
% Run non-preemptive simulation
fprintf('\n Running Non-Preemptive Queue Simulation...\n');
[waiting_times_high_np, waiting_times_low_np, queue_length_high_np, queue_length_low_np] = ...
    simulate_priority_queue(lambda_high, lambda_low, mu, num_desks, sim_time);
% Calculate and display results for non-preemptive system
avg_waiting_time_high_np = mean(waiting_times_high_np);
avg_waiting_time_low_np = mean(waiting_times_low_np);
avg_queue_length_high_np = mean(queue_length_high_np);
avg_queue_length_low_np = mean(queue_length_low_np);

disp('Non-Preemptive System Results');
disp(['Avg Waiting Time (High Priority): ', num2str(avg_waiting_time_high_np)]);
disp(['Avg Waiting Time (Low Priority): ', num2str(avg_waiting_time_low_np)]);
disp(['Avg Queue Length (High Priority): ', num2str(avg_queue_length_high_np)]);
disp(['Avg Queue Length (Low Priority): ', num2str(avg_queue_length_low_np)]);

%Preemptive Queue Simulation
fprintf('\n Running Preemptive Queue Simulation...\n');
lambda = [lambda_high, lambda_low];  % Arrival rates for each priority level
mu_levels = [mu, mu];                % Same service rate for both priority levels
priority_levels = 2;                 % Number of priority levels (high and low)

[waiting_times_p, queue_lengths_p] = simulate_preemptive_queue(lambda, mu_levels, num_desks, sim_time, priority_levels);

% Calculate average waiting time and queue length for preemptive system
avg_waiting_time_high_p = mean(waiting_times_p(:, 1));
avg_waiting_time_low_p = mean(waiting_times_p(:, 2));
avg_queue_length_high_p = mean(queue_lengths_p(:, 1));
avg_queue_length_low_p = mean(queue_lengths_p(:, 2));

disp('Preemptive System Results');
disp(['Avg Waiting Time (High Priority): ', num2str(avg_waiting_time_high_p)]);
disp(['Avg Waiting Time (Low Priority): ', num2str(avg_waiting_time_low_p)]);
disp(['Avg Queue Length (High Priority): ', num2str(avg_queue_length_high_p)]);
disp(['Avg Queue Length (Low Priority): ', num2str(avg_queue_length_low_p)]);

%  Plot Results for Visualization 
figure;
% High priority queue lengths comparison
subplot(2,1,1);
plot(1:sim_time, queue_length_high_np, 'r', 1:sim_time, queue_lengths_p(:,1), 'b');
legend('Non-Preemptive High', 'Preemptive High');
title('Queue Length Over Time: High Priority');
xlabel('Time');
ylabel('Queue Length');

% Low priority queue lengths comparison
subplot(2,1,2);
plot(1:sim_time, queue_length_low_np, 'r', 1:sim_time, queue_lengths_p(:,2), 'b');
legend('Non-Preemptive Low', 'Preemptive Low');
title('Queue Length Over Time: Low Priority');
xlabel('Time');
ylabel('Queue Length');