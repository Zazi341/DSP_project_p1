% Load the .mat files
data_x = load('sig_x.mat');
data_filter1 = load('filter_1.mat');

% Extract the signal and the filter
x = data_x.x;
h1 = data_filter1.xx;

% Lengths of the signal and filter
len_x = length(x);
len_h = length(h1);

% Define the range of window sizes to test for OVA
window_sizes = [100, 500, 1000, 2000, 5000, 10000];

% Initialize arrays to store the running times
running_times_ova = zeros(size(window_sizes));
running_times_direct = zeros(size(window_sizes));

% OVA convolution
for idx = 1:length(window_sizes)
    % Get the current window size
    N = window_sizes(idx);
    
    % The length of the resulting convolution
    len_y = len_x + len_h - 1;

    % Number of segments
    num_segments = ceil(len_x / N);

    % Initialize the resulting convolution array
    y = zeros(1, len_y);

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
    end
    
    running_times_ova(idx) = toc;
end

% Direct convolution
for idx = 1:length(window_sizes)
    % Get the current window size (this is just to use the same indices)
    N = window_sizes(idx);

    % The length of the resulting convolution
    len_y = len_x + len_h - 1;

    % Initialize the resulting convolution array
    y1 = zeros(1, len_y);

    % Measure the running time of the convolution process
    tic;

    % Perform the convolution manually
    for i = 1:len_y
        for j = 1:len_h
            if (i-j+1) > 0 && (i-j+1) <= len_x
                y1(i) = y1(i) + x(i-j+1) * h1(j);
            end
        end
    end

    running_times_direct(idx) = toc;
end

% Plot the running times
figure;
plot(window_sizes, running_times_ova, '-o', 'DisplayName', 'OVA Convolution');
hold on;
plot(window_sizes, running_times_direct, '-x', 'DisplayName', 'Direct Convolution');
hold off;

% Add titles and labels
title('Running Time of Normal Convolution vs OVA Convolution');
xlabel('Window Size');
ylabel('Running Time (seconds)');
legend('Location', 'northwest');
grid on;

% Display running times
disp('Window Sizes:');
disp(window_sizes);
disp('Running Times for OVA (seconds):');
disp(running_times_ova);
disp('Running Times for Direct (seconds):');
disp(running_times_direct);
