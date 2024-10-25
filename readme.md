
# Simulation of Priority Queues

```matlab
function [waiting_times_high, waiting_times_low, queue_length_high, queue_length_low] = simulate_priority_queue(lambda_high, lambda_low, mu, num_desks, sim_time)
```

---

## Key Variables

- `queue_high` and `queue_low`: Represent the queues for high-priority and low-priority customers, respectively.
- `servers`: An array representing the status of each server (number of desks), where the value indicates the remaining service time for the customer being served.
- `waiting_times_high` and `waiting_times_low`: Arrays that track the waiting times for high- and low-priority customers.
- `queue_length_high` and `queue_length_low`: Arrays that track the queue length for high- and low-priority customers at each time step.

---

### **Simulation Flow:**

#### **1. Main Simulation Loop (Line 13)**

```matlab
for t = 1:sim_time
```

The main loop iterates over every time unit from 1 to `sim_time`. This means the simulation proceeds one unit of time at a time, updating the state of the system (customer arrivals, server usage, queue lengths) in each step.

---

#### **2. High-Priority Customer Arrival (Lines 15-17)**

```matlab
if rand < lambda_high
    queue_high = [queue_high, t];  % Add high-priority customer to queue
end
```

- This block simulates the arrival of a high-priority customer.
- A random number between 0 and 1 (`rand`) is generated, and if it's less than `lambda_high`, a high-priority customer arrives.
- The arrival time `t` is recorded in the `queue_high` array, representing the time this customer entered the queue.

---

#### **3. Low-Priority Customer Arrival (Lines 20-22)**

```matlab
if rand < lambda_low
    queue_low = [queue_low, t];  % Add low-priority customer to queue
end
```

- Similar to the high-priority customer, a low-priority customer arrives if a randomly generated number is less than `lambda_low`.
- The arrival time is recorded in the `queue_low` array.

---

#### **4. Processing Customers with Non-Preemptive Scheduling (Lines 25-39)**

This section checks if a server (desk) is free and assigns customers from the queue to that server.

#### **Step-by-step breakdown of Preemptive Scheduling:**

**4.1 Checking if Servers are Free (Line 26):**

```matlab
for i = 1:num_desks
    if servers(i) <= 0  % Server is free
```

- The simulation loops through all servers (`num_desks`), checking if a server is free.
- If `servers(i)` is `0` or less, the server is free (i.e., not currently serving any customer).

---

**4.2 Serving High-Priority Customers First (Lines 28-31):**

```matlab
if ~isempty(queue_high)
    arrival_time = queue_high(1);
    queue_high(1) = [];  % Remove from queue
    waiting_times_high = [waiting_times_high, t - arrival_time];
    servers(i) = exprnd(1/mu);  % Generate service time for high-priority
end
```

- If there are any high-priority customers waiting in `queue_high`, the first one (i.e., the one who has been waiting the longest) is selected.
- The waiting time for this customer is calculated as the difference between the current time (`t`) and the arrival time (`arrival_time`), and this value is added to `waiting_times_high`.
- The customer is removed from the queue.
- A service time for this customer is generated using the exponential distribution (`exprnd(1/mu)`), and the server is now considered busy for this time period.

---

**4.3 Serving Low-Priority Customers if No High-Priority Customers (Lines 33-38):**

```matlab
elseif ~isempty(queue_low)
    arrival_time = queue_low(1);
    queue_low(1) = [];
    waiting_times_low = [waiting_times_low, t - arrival_time];
    servers(i) = exprnd(1/mu);  % Generate service time for low-priority
end
```

- If there are no high-priority customers waiting, the function checks if any low-priority customers are in the queue (`queue_low`).
- The same logic applies as for the high-priority customers: the first customer is selected, waiting time is calculated, and the customer is removed from the queue.
- The server's service time is generated, and the server is considered busy for the duration of this service.

---

#### **5. Reducing Service Time on All Servers (Line 41)**

```matlab
servers = servers - 1;
```

- After processing the customers, the simulation reduces the remaining service time on all servers by 1 (since one unit of time has passed).
- If a server's remaining time reaches 0, it becomes available for the next customer in the next time step.

---

#### **6. Tracking Queue Lengths (Lines 44-45)**

```matlab
queue_length_high = [queue_length_high, length(queue_high)];
queue_length_low = [queue_length_low, length(queue_low)];
```

- At the end of each time step, the function records the lengths of the high-priority and low-priority queues and stores them in `queue_length_high` and `queue_length_low`, respectively.
- This allows for tracking how the queues grow or shrink over time, providing data on the congestion levels in the system.

---

### **Summary of Non-Preemptive Scheduling:**

- The function simulates the arrivals of both high- and low-priority customers at each time step.
- It assigns customers to available servers, always prioritizing high-priority customers first (non-preemptively).
- The function logs both the waiting times and queue lengths throughout the simulation, allowing us to analyze the system’s behavior, specifically how it handles different priorities and the service dynamics.

The function completes when the simulation reaches the total simulation time (`sim_time`), and it returns arrays containing waiting times and queue lengths for both priority levels.

1.

```matlab
function [waiting_times, queue_lengths] = simulate_preemptive_queue(lambda, mu, num_desks, sim_time, priority_levels)
```

---

### Key Variables 2

- **`queue_lengths`**: A matrix where each row corresponds to the queue lengths for each priority level at a specific time `t`.
- **`waiting_times`**: A matrix where each row contains the waiting times for each priority level at time `t`.
- **`servers_busy`**: An array that tracks how long each server (or desk) will be busy serving a customer.
- **`current_jobs`**: An array tracking which customer (from which priority level) each server is currently serving.
- **`priority_of_jobs`**: An array that stores the priority level of the job being served on each server.

---

### **Main Simulation Loop (Line 12)**

```matlab
for t = 1:sim_time
```

- The main loop runs through every time unit from `1` to `sim_time`, simulating the system's behavior at each time step.
- At each time step, the function handles customer arrivals, processes jobs based on priority, and updates the status of the servers.

---

### **1. Customer Arrivals (Lines 14-19)**

```matlab
for p = 1:priority_levels
    if rand < lambda(p)
        queue_lengths(t, p) = queue_lengths(max(t-1,1), p) + 1;
    else
        queue_lengths(t, p) = queue_lengths(max(t-1,1), p);
    end
end
```

- For each priority level `p` (from 1 to `priority_levels`), a random number between 0 and 1 is generated using `rand()`.
- If this random number is less than `lambda(p)` (the arrival rate for priority `p`), a customer arrives at that priority level, and the corresponding queue length is incremented by 1.
- If no customer arrives, the queue length remains the same as the previous time step (`queue_lengths(max(t-1,1), p)`).
- **Note:** `max(t-1,1)` ensures that for `t = 1`, the queue length reference is safe and valid.

---

### **2. Serving Jobs Based on Priority (Lines 22-31)**

In this section, the servers process jobs from the queue, starting with the highest-priority customers.

#### **Step-by-step breakdown of Non-Preemptive Scheduling:**

**2.1 Checking for Free Servers (Line 22):**

```matlab
for desk = 1:num_desks
    if servers_busy(desk) <= 0  % If the desk is free
```

- The function loops through all servers (`num_desks`) to check if any server is free (i.e., if `servers_busy(desk)` is `0` or less).

---

**2.2 Assigning High-Priority Jobs to Free Servers (Lines 24-30):**

```matlab
for p = 1:priority_levels
    if queue_lengths(t, p) > 0  % If there are jobs in the priority level p
        servers_busy(desk) = exprnd(1/mu(p)); % Assign server to new job
        priority_of_jobs(desk) = p;  % Record the priority of the job being served
        queue_lengths(t, p) = queue_lengths(t, p) - 1;  % Decrease the queue
        break;
    end
end
```

- For each priority level (`p`), the function checks if there are any jobs waiting in the queue for that priority (`queue_lengths(t, p) > 0`).
- If there are jobs, the server is assigned to a job from that priority level.
  - The server is assigned a service time drawn from an exponential distribution based on the service rate `mu(p)` for priority level `p`.
  - The `priority_of_jobs(desk)` array is updated to record the priority level of the job being served by the server.
  - The corresponding queue length is decremented, as the customer is now being served.
- The loop breaks after assigning a job to the server, as only one job can be assigned to a server at a time.

---

### **3. Reducing Service Time on Servers (Line 32)**

```matlab
else
    servers_busy(desk) = servers_busy(desk) - 1;  % Decrement the service time
    if servers_busy(desk) <= 0  % If the job is done
        servers_busy(desk) = 0;  % Free up the desk
    end
end
```

- If a server is currently busy (`servers_busy(desk) > 0`), the function decrements the remaining service time for that server by 1 (since one unit of time has passed).
- If the service time reaches 0 or below, the server is freed up to handle a new job in the next time step.

---

### **4. Preemption Handling (Lines 35-43)**

This section checks if a higher-priority job arrives, which can preempt a lower-priority job currently being served.

#### **Step-by-step breakdown:**

**4.1 Checking for Higher-Priority Jobs (Line 35):**

```matlab
for desk = 1:num_desks
    for p = 1:priority_of_jobs(desk)-1  % Check if higher priority jobs exist
```

- For each server, the function checks if any higher-priority jobs are waiting in the queue by looping through priority levels lower than the current job's priority (`priority_of_jobs(desk)-1`).

---

**4.2 Preempting the Lower-Priority Job (Lines 37-42):**

```matlab
if queue_lengths(t, p) > 0
    queue_lengths(t, priority_of_jobs(desk)) = queue_lengths(t, priority_of_jobs(desk)) + 1;  % Add the preempted job back to the queue
    servers_busy(desk) = exprnd(1/mu(p)); % Start serving the high-priority job
    priority_of_jobs(desk) = p;  % Update the job priority
    queue_lengths(t, p) = queue_lengths(t, p) - 1;  % Decrease the high-priority queue
    break;
end
```

- If there are higher-priority jobs waiting in the queue (`queue_lengths(t, p) > 0`), the lower-priority job currently being served is preempted.
  - The preempted job is placed back into its corresponding queue (`queue_lengths(t, priority_of_jobs(desk))` is incremented).
  - The server is assigned to the higher-priority job instead, with a new service time generated based on the service rate `mu(p)` for that priority level.
  - The priority of the job being served on this server is updated (`priority_of_jobs(desk) = p`).
  - The higher-priority queue is decremented as the customer is now being served.
- The loop breaks after preempting the lower-priority job, as only one job can be served at a time.

---

### **5. Recording Waiting Times (Lines 45-47)**

```matlab
for p = 1:priority_levels
    waiting_times(t, p) = queue_lengths(t, p);  % Update waiting times from queue length
end
```

- At the end of each time step, the function records the waiting times for each priority level. The waiting time for each priority level is represented by the length of the queue at that time step.

---

### **Summary:**

- The function simulates arrivals for multiple priority levels and processes jobs using a **preemptive priority** scheduling model.
- At each time step, new customers may arrive, servers process jobs based on the highest priority, and jobs may be preempted if a higher-priority job arrives while a lower-priority job is being served.
- The waiting times and queue lengths for each priority level are recorded throughout the simulation, providing data to analyze the system's performance under preemptive scheduling.

At the end of the simulation, the function returns the `waiting_times` and `queue_lengths` matrices, which capture the system's behavior over time for each priority level.
