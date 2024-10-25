function prob = P_k(lbd, mu, k, num_desks)
    % Function to calculate the probability of more than k jobs in the system (M/M/m system)
    % lambda: arrival rate
    % mu: service rate per server
    % k: queue size thresholds
    % num_desks: number of servers (desks)

    rho = lbd / (num_desks * mu);  % Utilization of the system (normalized for multiple servers)
    
    if rho >= 1
        error('System is unstable. Arrival rate must be less than total service rate.');
    end

    % Approximation for the probability that the number of jobs exceeds k (simplified for M/M/m)
    prob = (rho.^k / factorial(num_desks)) * ((num_desks * rho) / (1 - rho));  % Simplified
end
