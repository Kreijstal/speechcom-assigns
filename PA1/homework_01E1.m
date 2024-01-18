clear; clc; close all

% Load the audio file
[speech, fs] = audioread('PA1/speech1.wav');
addpath('./PA1/');

% Convert maxTimeLag from milliseconds to samples
maxTimeLag_ms = 50; % 50 milliseconds
maxTimeLag_samples = floor(maxTimeLag_ms * fs / 1000);

% Compute the Autocorrelation Function
r_xx = autoCorrelation(speech, maxTimeLag_samples);

% Create the time vector for the x-axis in seconds
time_vector = linspace(0, maxTimeLag_ms / 1000, maxTimeLag_samples + 1);

% Plot the Autocorrelation Function
figure;
plot(time_vector, r_xx);
xlabel('Time Shift (\tau) in seconds');
ylabel('Autocorrelation (r_{xx})');
title('Autocorrelation Function of the Speech Signal');

% Clone r_xx
r_xx_clone = transpose(r_xx);

% Find zero crossings
zero_crossings = zeroCrossing(r_xx_clone);

% Identify the first zero crossing
first_zero_crossing_idx = find(zero_crossings, 1);

% Processing after finding the first zero crossing
% (e.g., setting values before this index to zero in r_xx_clone)
r_xx_clone(1:first_zero_crossing_idx) = 0;

for i = first_zero_crossing_idx + 1 : length(r_xx_clone) - 1
    if r_xx_clone(i) > r_xx_clone(i-1) && r_xx_clone(i) > r_xx_clone(i+1)
        % Found the first peak
        first_peak_idx = i;
        break;
    end
end

% Now compute the fundamental frequency
time_lag_at_peak = first_peak_idx / fs;  % Convert index to time using sampling rate
fundamental_frequency = 1 / time_lag_at_peak;

% Display the fundamental frequency
fprintf('Fundamental Frequency: %f Hz\n', fundamental_frequency);