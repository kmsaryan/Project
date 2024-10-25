function [waiting_times, queue_lengths] = simulate_preemptive_queue(lambda, mu, num_desks, sim_time, priority_levels)
    % Initialize queues and service time for different priority levels
    queue_lengths = zeros(sim_time, priority_levels);
    waiting_times = zeros(sim_time, priority_levels);
    
    % Initialize variables to track server availability and customers being served
    servers_busy = zeros(1, num_desks);    % Tracks if a server is busy (1) or idle (0)
    current_jobs = zeros(1, num_desks);    % Tracks which customer is being served by each server
    priority_of_jobs = zeros(1, num_desks); % Tracks the priority level of the customer being served
    
    % Main simulation loop
    for t = 1:sim_time
        % Randomly generate new arrivals based on lambda for each priority level
        for p = 1:priority_levels
            if rand < lambda(p)
                queue_lengths(t, p) = queue_lengths(max(t-1,1), p) + 1;
                %fprintf('Priority %d customer arrived at time %d\n', p, t);
            else
                queue_lengths(t, p) = queue_lengths(max(t-1,1), p);
            end
        end

        % Process jobs in the queue, giving priority to higher-priority customers
        for desk = 1:num_desks
            if servers_busy(desk) <= 0  % If the desk is free
                for p = 1:priority_levels
                    if queue_lengths(t, p) > 0  % If there are jobs in the priority level p
                        servers_busy(desk) = exprnd(1/mu(p)); % Assign server to new job
                        priority_of_jobs(desk) = p;  % Record the priority of the job being served
                        queue_lengths(t, p) = queue_lengths(t, p) - 1;  % Decrease the queue
                        %fprintf('Serving priority %d customer at desk %d, current time %d\n', p, desk, t);
                        break;
                    end
                end
            else
                servers_busy(desk) = servers_busy(desk) - 1;  % Decrement the service time
                if servers_busy(desk) <= 0  % If the job is done
                    servers_busy(desk) = 0;  % Free up the desk
                end
            end
        end
        
        % Handle preemption: Check if a higher-priority job arrives and interrupts the lower-priority jobs
        for desk = 1:num_desks
            for p = 1:priority_of_jobs(desk)-1  % Check if higher priority jobs exist
                if queue_lengths(t, p) > 0
                    % Preempt the lower-priority job and serve the higher-priority job
                    queue_lengths(t, priority_of_jobs(desk)) = queue_lengths(t, priority_of_jobs(desk)) + 1;  % Add the preempted job back to the queue
                    servers_busy(desk) = exprnd(1/mu(p)); % Start serving the high-priority job
                    priority_of_jobs(desk) = p;  % Update the job priority
                    queue_lengths(t, p) = queue_lengths(t, p) - 1;  % Decrease the high-priority queue
                    %fprintf('Preempting lower-priority job at desk %d for priority %d job, current time %d\n', desk, p, t);
                    break;
                end
            end
        end
        
        % Record waiting times for each priority level
        for p = 1:priority_levels
            waiting_times(t, p) = queue_lengths(t, p);  % Update waiting times from queue length
        end
    end
end