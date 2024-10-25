function compare_scheduling_strategies(lambda_high, lambda_low, mu, num_desks, sim_time)
    % Simulate both preemptive and non-preemptive scheduling strategies
    % lambda_high: arrival rate for high-priority jobs
    % lambda_low: arrival rate for low-priority jobs
    % mu: service rate
    % num_desks: number of service desks
    % sim_time: total simulation time
    
    % Non-preemptive scheduling simulation
    [waiting_times_high_non, waiting_times_low_non, queue_length_high_non, queue_length_low_non] = simulate_priority_queue(lambda_high, lambda_low, mu, num_desks, sim_time);
    
    % Preemptive scheduling simulation
    [waiting_times_high_pre, waiting_times_low_pre, queue_length_high_pre, queue_length_low_pre] = simulate_preemptive_queue(lambda_high, lambda_low, mu, num_desks, sim_time);

    % Statistical analysis for waiting times (high priority)
    avg_waiting_high_non = mean(waiting_times_high_non);
    avg_waiting_high_pre = mean(waiting_times_high_pre);
    std_waiting_high_non = std(waiting_times_high_non);
    std_waiting_high_pre = std(waiting_times_high_pre);
    
    % Statistical analysis for waiting times (low priority)
    avg_waiting_low_non = mean(waiting_times_low_non);
    avg_waiting_low_pre = mean(waiting_times_low_pre);
    std_waiting_low_non = std(waiting_times_low_non);
    std_waiting_low_pre = std(waiting_times_low_pre);
    
    % Statistical analysis for queue lengths (high priority)
    avg_queue_length_high_non = mean(queue_length_high_non);
    avg_queue_length_high_pre = mean(queue_length_high_pre);
    
    % Statistical analysis for queue lengths (low priority)
    avg_queue_length_low_non = mean(queue_length_low_non);
    avg_queue_length_low_pre = mean(queue_length_low_pre);
    
    % Display results
    disp('Statistical Comparison Between Preemptive and Non-Preemptive Scheduling:');
    disp('------------------------------------------------');
    fprintf('High-Priority Waiting Times (Non-Preemptive vs. Preemptive):\n');
    fprintf('  Avg (Non-Preemptive): %.4f, Avg (Preemptive): %.4f\n', avg_waiting_high_non, avg_waiting_high_pre);
    fprintf('  Std (Non-Preemptive): %.4f, Std (Preemptive): %.4f\n', std_waiting_high_non, std_waiting_high_pre);
    disp('------------------------------------------------');
    fprintf('Low-Priority Waiting Times (Non-Preemptive vs. Preemptive):\n');
    fprintf('  Avg (Non-Preemptive): %.4f, Avg (Preemptive): %.4f\n', avg_waiting_low_non, avg_waiting_low_pre);
    fprintf('  Std (Non-Preemptive): %.4f, Std (Preemptive): %.4f\n', std_waiting_low_non, std_waiting_low_pre);
    disp('------------------------------------------------');
    fprintf('High-Priority Queue Length (Non-Preemptive vs. Preemptive):\n');
    fprintf('  Avg Queue Length (Non-Preemptive): %.4f, Avg Queue Length (Preemptive): %.4f\n', avg_queue_length_high_non, avg_queue_length_high_pre);
    disp('------------------------------------------------');
    fprintf('Low-Priority Queue Length (Non-Preemptive vs. Preemptive):\n');
    fprintf('  Avg Queue Length (Non-Preemptive): %.4f, Avg Queue Length (Preemptive): %.4f\n', avg_queue_length_low_non, avg_queue_length_low_pre);
    
    % Visualization
    figure;
    
    % Plot for waiting times comparison
    subplot(2,1,1);
    bar([avg_waiting_high_non, avg_waiting_high_pre; avg_waiting_low_non, avg_waiting_low_pre]);
    title('Average Waiting Time Comparison (Non-Preemptive vs. Preemptive)');
    ylabel('Average Waiting Time');
    set(gca, 'xticklabel', {'High Priority', 'Low Priority'});
    legend('Non-Preemptive', 'Preemptive');
    
    % Plot for queue lengths comparison
    subplot(2,1,2);
    bar([avg_queue_length_high_non, avg_queue_length_high_pre; avg_queue_length_low_non, avg_queue_length_low_pre]);
    title('Average Queue Length Comparison (Non-Preemptive vs. Preemptive)');
    ylabel('Average Queue Length');
    set(gca, 'xticklabel', {'High Priority', 'Low Priority'});
    legend('Non-Preemptive', 'Preemptive');
    
end