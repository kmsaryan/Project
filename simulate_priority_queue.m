function [waiting_times_high, waiting_times_low, queue_length_high, queue_length_low] = simulate_priority_queue(lambda_high, lambda_low, mu, num_desks, sim_time)
    % Initialize queues and servers
    queue_high = [];
    queue_low = [];
    servers = zeros(num_desks, 1);  % Time remaining on each server's task
    
    % Initialize performance tracking variables
    waiting_times_high = [];
    waiting_times_low = [];
    queue_length_high = [];
    queue_length_low = [];
    
    % Main simulation loop for the total simulation time
    for t = 1:sim_time
        % Simulate high-priority customer arrival
        if rand < lambda_high
            queue_high = [queue_high, t];  % Add high-priority customer to queue
            %fprintf('High-priority customer arrived at time %d\n', t);
        end
        
        % Simulate low-priority customer arrival
        if rand < lambda_low
            queue_low = [queue_low, t];  % Add low-priority customer to queue
            %fprintf('Low-priority customer arrived at time %d\n', t);
        end
        
        % Process customers with non-preemptive priority scheduling
        for i = 1:num_desks
            if servers(i) <= 0  % Server is free
                if ~isempty(queue_high)
                    % Serve high-priority customer
                    arrival_time = queue_high(1);
                    queue_high(1) = [];  % Remove from queue
                    waiting_times_high = [waiting_times_high, t - arrival_time];  % Log waiting time
                    servers(i) = exprnd(1/mu);  % Generate service time for high-priority
                    %fprintf('Serving high-priority customer who arrived at %d, current time %d\n', arrival_time, t);
                elseif ~isempty(queue_low)
                    % Serve low-priority customer only if no high-priority customer is waiting
                    arrival_time = queue_low(1);
                    queue_low(1) = [];
                    waiting_times_low = [waiting_times_low, t - arrival_time];  % Log waiting time
                    servers(i) = exprnd(1/mu);  % Generate service time for low-priority
                    %fprintf('Serving low-priority customer who arrived at %d, current time %d\n', arrival_time, t);
                end
            end
        end
        
        % Reduce service time remaining on all servers
        servers = servers - 1;
        
        % Track queue lengths over time
        queue_length_high = [queue_length_high, length(queue_high)];
        queue_length_low = [queue_length_low, length(queue_low)];
    end
end