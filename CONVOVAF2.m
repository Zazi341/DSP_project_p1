% Load the .mat files
data_x = load('sig_x.mat');
data_filter1 = load('filter_1.mat');

% Extract the signal and the filter
x = data_x.x;
h1 = data_filter1.xx;

% Lengths of the signal and filter
len_x = length(x);
len_h = length(h1);

% Choose the segment length N
N = 1000;
Fs=18000;
% The length of the resulting convolution
len_y = len_x + len_h - 1;

% Number of segments
num_segments = ceil(len_x / N);

% Initialize the resulting convolution array
y = zeros(1, len_y);

% Measure the running time of the convolution process
tic;

% Initialize the counter for the number of multiplications
num_multiplications = 0;

% Perform the Overlap and Add method
for m = 0:num_segments-1
    % Define the segment xm[n]
    start_idx = m * N + 1;
    end_idx = min((m + 1) * N, len_x);
    xm = zeros(1, N);
    xm(1:(end_idx - start_idx + 1)) = x(start_idx:end_idx);
    
    % Perform the convolution for the segment
    ym = zeros(1, N + len_h - 1);
    for i = 1:(N + len_h - 1)
        for j = 1:len_h
            if (i-j+1) > 0 && (i-j+1) <= N
                ym(i) = ym(i) + xm(i-j+1) * h1(j);
                num_multiplications = num_multiplications + 1;
            end
        end
    end
    
    % Add the result to the final output
    y(start_idx:start_idx + N + len_h - 2) = y(start_idx:start_idx + N + len_h - 2) + ym;
end

elapsed_time = toc;

% Display the elapsed time and the number of multiplications
disp(['Elapsed time for Overlap and Add convolution: ', num2str(elapsed_time), ' seconds']);
disp(['Number of multiplications performed: ', num2str(num_multiplications)]);

% Perform FFT on the original signal, filter, and convolved signal
X = fft(x, len_y);
H1 = fft(h1, len_y);
Y = fft(y, len_y);

% Shift the FFT and calculate the magnitude
X_shifted = fftshift(X);
H1_shifted = fftshift(H1);
Y_shifted = fftshift(Y);

magnitudeX = abs(X_shifted);
magnitudeH1 = abs(H1_shifted);
magnitudeY = abs(Y_shifted);

% Normalize the magnitudes by dividing by the maximum value
magnitudeX = magnitudeX / max(magnitudeX);
magnitudeH1 = magnitudeH1 / max(magnitudeH1);
magnitudeY = magnitudeY / max(magnitudeY);

% Frequency vector, shifted to center zero frequency
f = (-len_y/2:len_y/2-1) * (Fs / len_y);

% Plot the normalized magnitude of the FFTs
figure;

% Magnitude of the FFT of the original signal
subplot(3, 1, 1);
plot(f, magnitudeX);
title('Normalized Magnitude of the FFT of the Original Signal x[n]');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

% Magnitude of the FFT of the filter
subplot(3, 1, 2);
plot(f, magnitudeH1);
title('Normalized Magnitude of the FFT of the Filter h2[n]');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

% Magnitude of the FFT of the convolved signal
subplot(3, 1, 3);
plot(f, magnitudeY);
title('Normalized Magnitude of the FFT of the Convolved Signal y[n]');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

% Limit the x-axis to the Nyquist frequency
xlim([-Fs/2 Fs/2]);
