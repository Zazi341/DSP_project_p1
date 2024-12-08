% Load the .mat file
data = load('filter_2.mat');

% Extract the signal
x = data.xx;

% Define the sample frequency
Fs = 18000; % Hz

% Perform FFT
N = length(x); % Length of the signal
X = fft(x); % Compute the FFT

% Shift the FFT and calculate the magnitude
X_shifted = fftshift(X);
magnitudeX = abs(X_shifted);

% Normalize the magnitude by dividing by the maximum value
magnitudeX = magnitudeX / max(magnitudeX);

% Calculate the frequency vector, shifted to center zero frequency
f = (-N/2:N/2-1) * (Fs / N);

% Plot the normalized magnitude of the FFT
figure;
plot(f, magnitudeX);
title('Normalized Magnitude of the FFT of the Filter no.2');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
grid on;

% Limit the x-axis to the Nyquist frequency
xlim([-Fs/2 Fs/2]);
