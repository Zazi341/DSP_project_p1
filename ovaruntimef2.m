% Load the .mat files
data_x = load('sig_x.mat');
data_filter2 = load('filter_2.mat');

% Extract the signal and the filter
x = data_x.x;
h1 = data_filter2.xx;

% Lengths of the signal and filter
len_x = length(x);
len_h = length(h1);

% Define the range of window sizes to test
window_sizes = [100, 500, 1000, 2000, 5000, 10000];

% Initialize arrays to store the running times and number of operations
running_times = zeros(size(window_sizes));
num_multiplications = zeros(size(window_sizes));

% Loop over each window size
for idx = 1:length(window_sizes)
    % Get the current window size
    N = window_sizes(idx);
    
    % The length of the resulting convolution
    len_y = len_x + len_h - 1;

    % Number of segments
    num_segments = ceil(len_x / N);

    % Initialize the resulting convolution array
    y = zeros(1, len_y);

    % Initialize counter for multiplications
    total_multiplications = 0;

    % Measure the running time of the convolution process
    tic;
    
    % Perform the Overlap and Add method
    for m = 0:num_segments-1
        % Define the segment xm[n]
        start_idx = m * N + 1;
        end_idx = min((m + 1) * N, len_x);
        xm = zeros(1, N);
        xm(1:(end_idx - start_idx + 1)) = x(start_idx:end_idx);
        
        % Zero-padding to the segment
        xm_padded = [xm, zeros(1, len_h - 1)];
        
        % Perform FFT on the segment and filter
        X = fft(xm_padded, N + len_h - 1);
        H1 = fft(h1, N + len_h - 1);
        
        % Perform circular convolution in the frequency domain
        Y_segment = X .* H1;
        
        % Inverse FFT to get the time-domain result
        y_segment = ifft(Y_segment);
        
        % Determine the range of indices for overlap and add
        range_start = start_idx;
        range_end = start_idx + length(y_segment) - 1;
        
        % Overlap and add
        y(range_start:range_end) = y(range_start:range_end) + y_segment;
        
        % Update total multiplication counts
        total_multiplications = total_multiplications + 4 * (N + len_h - 1); % Assuming complex multiplication as 4 real multiplications
    end
    
    running_times(idx) = toc;
    num_multiplications(idx) = total_multiplications; % Total multiplications
end

% Plot the running time vs. window size
figure;
subplot(2, 1, 1);
plot(window_sizes, running_times, '-o');
title('Running Time vs. Window Size (Overlap and Add Method)');
xlabel('Window Size (N)');
ylabel('Running Time (seconds)');
grid on;

% Plot the number of multiplications vs. window size
subplot(2, 1, 2);
plot(window_sizes, num_multiplications, '-o');
title('Number of Multiplications vs. Window Size (Overlap and Add Method)');
xlabel('Window Size (N)');
ylabel('Number of Multiplications');
grid on;

% Display the number of multiplications and running times
disp('Window Sizes:');
disp(window_sizes);
disp('Running Times (seconds):');
disp(running_times);
disp('Number of Multiplications:');
disp(num_multiplications);
