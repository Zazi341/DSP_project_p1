% Load the .mat files
data_x = load('sig_x.mat');
data_filter1 = load('filter_1.mat');

% Extract the signal and the filter
x = data_x.x;
h1 = data_filter1.xx;

% Lengths of the signal and filter
len_x = length(x);
len_h = length(h1);

% The length of the resulting convolution
len_y = len_x + len_h - 1;

% Initialize the resulting convolution array
y1 = zeros(1, len_y);

% Initialize the counter for the number of multiplications
num_multiplications_direct = 0;

% Measure the running time of the convolution process
tic;

% Perform the convolution manually
for i = 1:len_y
    for j = 1:len_h
        if (i-j+1) > 0 && (i-j+1) <= len_x
            y1(i) = y1(i) + x(i-j+1) * h1(j);
            num_multiplications_direct = num_multiplications_direct + 1;
        end
    end
end

elapsed_time_direct = toc;

% Perform FFT on the original signal, filter, and convolved signal
X = fft(x, len_y);
H1 = fft(h1, len_y);
Y1 = fft(y1, len_y);

% Shift the FFT and calculate the magnitude
X_shifted = fftshift(X);
H1_shifted = fftshift(H1);
Y1_shifted = fftshift(Y1);

magnitudeX = abs(X_shifted);
magnitudeH1 = abs(H1_shifted);
magnitudeY1 = abs(Y1_shifted);

% Normalize the magnitudes by dividing by the maximum value
magnitudeX = magnitudeX / max(magnitudeX);
magnitudeH1 = magnitudeH1 / max(magnitudeH1);
magnitudeY1 = magnitudeY1 / max(magnitudeY1);

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
title('Normalized Magnitude of the FFT of the Filter h1[n]');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

% Magnitude of the FFT of the convolved signal
subplot(3, 1, 3);
plot(f, magnitudeY1);
title('Normalized Magnitude of the FFT of the Convolved Signal y1[n]');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

% Limit the x-axis to the Nyquist frequency
xlim([-Fs/2 Fs/2]);

% Display the number of multiplications and the elapsed time for the direct method
disp(['Number of multiplications for direct convolution: ', num2str(num_multiplications_direct)]);
disp(['Elapsed time for direct convolution: ', num2str(elapsed_time_direct), ' seconds']);
