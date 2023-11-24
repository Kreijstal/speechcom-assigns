clc;
clear all;
close all;   

[y, fs] = audioread("./13ZZ637A.wav"); % fs is samples per second

nSamples = length(y);
x = linspace(0, nSamples/fs, nSamples);
figure;
plot(x, y);
xlabel('Time in [s]');
ylabel('Amplitude of Signal');

zero_crossings_array = ZeroCrossing(y);

samples_10ms = round(fs * 0.01); % Number of samples in 10ms
zeroCr_10ms = zeros(length(y), 1);

# calculating the zero crossings in the last 10ms from the current sample
for j = 1:nSamples
    if j < samples_10ms
        startIdx = 1;
        stopIdx = j;
    else
        startIdx = j - samples_10ms + 1;
        stopIdx = j;
    end
    zeroCr_10ms(j) = sum(zero_crossings_array(startIdx:stopIdx));
end

figure;
subplot(2, 1, 1);
plot(x, y);
xlabel('Time in [s]');
ylabel('Amplitude of Signal');

subplot(2, 1, 2);
plot(x, zeroCr_10ms);
xlabel('Time in [s]');
ylabel('Zero Crossings in last 10ms');



%% 2.1
% defining the threshold values

upperThreshold = 50;
lowerThreshold = 25;

  
figure;
hold off;
plot(x, zeroCr_10ms); % assuming zeroCr_10ms is the zero-crossing rate
hold on;
x_range = xlim; % Get the current x-axis limits % The constant value for the y-axis
plot(x_range, [upperThreshold upperThreshold], 'r', 'LineWidth', 1); 
plot(x_range, [lowerThreshold lowerThreshold], 'g', 'LineWidth', 1); 
xlabel('Time [s]');
ylabel('Number of zero crossings');



% Define cell arrays to hold the voiced and unvoiced segments
voicedSegments = {};
unvoicedSegments = {};

% Determine if we start with a voiced or unvoiced segment
#isInitialVoiced = isVoiced = zeroCr_10ms(1) > upperThreshold;
# it will be always unvoiced at the beginning, because the first value has no previous value to compare with
#defiening the transition indices
transitionIndices = [];

% Loop through the zero crossing rate vector to find transitions
for idx = 2:length(zeroCr_10ms)
    % Check for transition
    if isVoiced && zeroCr_10ms(idx) > upperThreshold
        % Transition from voiced to unvoiced
        transitionIndices = [transitionIndices, idx];
        isVoiced = false; % We are now in an unvoiced segment
    elseif ~isVoiced && zeroCr_10ms(idx) < lowerThreshold
        % Transition from unvoiced to voiced
        transitionIndices = [transitionIndices, idx];
        isVoiced = true; % We are now in a voiced segment
    end
end
%plotting the transition indices

% Loop through each pair of transition indices to plot rectangles
for i = 1:2:length(transitionIndices)-1
    % Start and end of the segment
    startIndex = transitionIndices(i);
    endIndex = transitionIndices(i+1);

    % Coordinates for the rectangle: [x1, y1, width, height]
    x_rect = [x(startIndex), x(startIndex), x(endIndex), x(endIndex)];
    y_rect = [min(ylim), max(ylim), max(ylim), min(ylim)];
    
    % Plot the rectangle using 'patch' with a purple color and some transparency
    patch(x_rect, y_rect, 'm', 'EdgeColor', 'none', 'FaceAlpha', 0.2);
end

% Assume signal starts with an unvoiced segment
isVoiced = false;
segmentStart = 1; % Start of the first segment

% Process the transitions to extract segments
for i = 1:length(transitionIndices)
    segmentEnd = transitionIndices(i); % End of the current segment
    if isVoiced
        % The current segment is voiced
        voicedSegments{end+1} = y(segmentStart:segmentEnd);
    else
        % The current segment is unvoiced
        unvoicedSegments{end+1} = y(segmentStart:segmentEnd);
    end
    isVoiced = ~isVoiced; % Toggle between voiced and unvoiced
    segmentStart = segmentEnd + 1; % Start of the next segment
end

% Check for the last segment after the last transition
if segmentStart <= nSamples
    if isVoiced
        voicedSegments{end+1} = y(segmentStart:end);
    else
        unvoicedSegments{end+1} = y(segmentStart:end);
    end
end

% Concatenate all voiced segments into one vector
concatenatedVoiced = [];
for i = 1:length(voicedSegments)
    concatenatedVoiced = [concatenatedVoiced; voicedSegments{i}];
end

% Play the concatenated voiced segments
sound(concatenatedVoiced, fs);
% Concatenate all voiced segments into one vector
concatenatedUnVoiced = [];
for i = 1:length(unvoicedSegments)
    concatenatedUnVoiced = [concatenatedUnVoiced; unvoicedSegments{i}];
end

% Play the concatenated voiced segments
sound(concatenatedUnVoiced, fs);
