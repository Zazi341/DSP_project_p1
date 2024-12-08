% Load the .mat files
data_x = load('sig_x.mat');
data_filter2 = load('filter_2.mat');

% Extract the signal and the filter
x = data_x.x;
h1 = data_filter2.xx;

% Lengths of the signal and filter
len_x = length(x);
len_h = length(h1);

% The length of the resulting convolution
len_y = len_x + len_h - 1;

% Initialize the resulting convolution arrays
y1 = zeros(1, len_y);
y_ova = zeros(1, len_y);

% Normal Convolution
% Perform the convolution manually
for i = 1:len_y
    for j = 1:len_h
        if (i-j+1) > 0 && (i-j+1) <= len_x
            y1(i) = y1(i) + x(i-j+1) * h1(j);
        end
    end
end

% OVA Convolution
% Choose the segment length N
N = 1000;

% Number of segments
num_segments = ceil(len_x / N);

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
            end
        end
    end
    
    % Add the result to the final output
    y_ova(start_idx:start_idx + N + len_h - 2) = y_ova(start_idx:start_idx + N + len_h - 2) + ym;
end

% Perform FFT on the convolved signals
Y1 = fft(y1, len_y);
Y_ova = fft(y_ova, len_y);

% Shift the FFT and calculate the magnitude
Y1_shifted = fftshift(Y1);
Y_ova_shifted = fftshift(Y_ova);

magnitudeY1 = abs(Y1_shifted);
magnitudeY_ova = abs(Y_ova_shifted);

% Normalize the magnitudes by dividing by the maximum value
magnitudeY1 = magnitudeY1 / max(magnitudeY1);
magnitudeY_ova = magnitudeY_ova / max(magnitudeY_ova);

% Frequency vector, shifted to center zero frequency
Fs = 18000; % Sample frequency
f = (-len_y/2:len_y/2-1) * (Fs / len_y);

% Plot the time domain signals
figure;
subplot(2, 1, 1);
t = (0:len_y-1) / Fs; % Time vector
plot(t, y1, '-o', 'DisplayName', 'Normal Convolution');
hold on;
plot(t, y_ova, '-x', 'DisplayName', 'OVA Convolution');
hold off;
title('time domain output of convolved signals');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Location', 'northeast');
grid on;
xlim([0, 0.005]); % Display only the first 0.01 seconds

% Plot the frequency domain signals
subplot(2, 1, 2);
plot(f, magnitudeY1, '-o', 'DisplayName', 'Normal Convolution');
hold on;
plot(f, magnitudeY_ova, '-x', 'DisplayName', 'OVA Convolution');
hold off;
title('normalized magnitude of the FFT of convolved signals with h2');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
legend('Location', 'northwest');
grid on;

% Limit the x-axis to the Nyquist frequency
xlim([-Fs/2 Fs/2]);
