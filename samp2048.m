% Load the .mat file containing the filter
data_filter = load('filter_0.25_101.mat');
h = data_filter.h;

% Define the signal parameters
Fs = 60; % Sampling frequency in Hz
T = 1/Fs; % Sampling period
t = 0:T:(2048-1)*T; % Time vector for 2048 samples

% Define the signal r[n]
r = cos(2*pi*5*t) + cos(2*pi*10*t);

% Check the length of the filter and pad it accordingly
% If the filter is already padded to 128 by FFT, we still need to pad to 2048
if length(h) < 2048
    h_padded = [h, zeros(1, 2048 - length(h))];
else
    h_padded = h;
end

% Perform FFT on both the signal and the filter
R = fft(r, 2048); % Ensure FFT length matches the signal length
H = fft(h_padded, 2048); % Ensure FFT length matches the signal length

% Perform the convolution in the frequency domain
S = R .* H;

% Perform the inverse FFT to get the filtered signal in time domain
s = ifft(S, 2048);

% Plot the magnitude of the DFT of the output signal
figure;
f = (0:length(S)-1)*(Fs/length(S)); % Frequency vector

plot(f, abs(S));
title('Magnitude of the DFT of the Convolved Signal S[k]');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 Fs/2]); % Limit to Nyquist frequency
grid on;