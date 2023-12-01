clear; clc; close all

[speech, fs] = audioread('PA1/speech1.wav');
addpath('./PA1/');

% nWin is 50ms in samples
nWin = 0.05 * fs;

[xWin, tWin] = makeWin(speech, fs, nWin, 8/10);

% for every window
f0=[];
zcr=[];
e=[];
p=[];


% We need to create a better findPeak function, this one detects peaks that are in the negative area, our purpose is to find the peak index
% that is in the positive area, for this we should try the following:
% zc is an array with zero crossing 0 for no zero crossing 1 for zero crossing, for each range of zero crossings, 
% find the max value in that range if it is positive, proceed to find first peak 
% if it is negative, find the next zero crossing and repeat the process
function peakIndex = findPeak(r, zc)
    % Find the indices of all zero crossings
    zcIndices = find(zc);

    % Initialize peakIndex to an empty array
    peakIndex = [];

    % Iterate through each zero crossing
    for idx = 1:length(zcIndices)
        % Start searching from the current zero crossing index
        startIdx = zcIndices(idx);

        % Check if there's a next zero crossing; if not, end at the length of r
        if idx < length(zcIndices)
            endIdx = zcIndices(idx + 1) - 1;
        else
            endIdx = length(r);
        end

        % Find the maximum value in the current range
        [maxVal, maxIdx] = max(r(startIdx:endIdx));

        % Check if the maximum value is positive and if the peak is not at the edges
        if maxVal > 0 && (startIdx + maxIdx - 1 > 1) && (startIdx + maxIdx - 1 < length(r))
            % Check if the identified max is a peak
            if r(startIdx + maxIdx - 1) > r(startIdx + maxIdx - 2) && r(startIdx + maxIdx - 1) > r(startIdx + maxIdx)
                peakIndex = startIdx + maxIdx - 1;
                break;
            end
        end
    end

    % Return empty if no peak is found
    if isempty(peakIndex)
        peakIndex = NaN;
    end
end



%loop all columns of xWin
for i = 1:size(xWin, 2)
    xWinI=xWin(:,i);
    %compute autocorrelation
    r_xx = autoCorrelation(xWinI, nWin);

    %normalize autocorrelecation
    r_xx_norm = r_xx / r_xx(1);
    %find the energy of the signal
    E= sum(xWinI.^2);
    %we calculate the zero crossing rate, we use zeroCrossing.m
    %zcra = zeroCrossing(xWinI);
    zcra = zeroCrossing(transpose(r_xx_norm));

    %we then calculate the fundamental frequency (the function is defined
    %at the end of this script)
    peak = findPeak(r_xx,zcra);
    %f_0_norm = findPeak(r_xx_norm,zcra_norm);

    %f_00 = findF0(r_xx,zcra,fs);

    %we add the zeros
    zc = mean(zcra);

    %we calculate it's periodicity of the signal window
    p_0 = r_xx_norm(peak);

    %set a theshhold matrix for all features
    thresh = [0.1, 0.1, 0.1];

    isVoiced = [E > thresh(1), zc > thresh(2), p_0 > thresh(3)];
    %if it's voiced then we add f_0 to f0 vector otherwise nan
    
    if isVoiced
        f0 = [f0, peak/fs];
    else
        f0 = [f0, nan];
    end
    %we add the zero crossing rate to the zcr vector
    zcr = [zcr, zc];
    %we add the energy to the energy vector
    e = [e, E];
    %we add the periodicity to the periodicity vector
    p = [p, p_0];

end

% Create the time vector for the x-axis in seconds
t = linspace(0, length(speech)/fs, length(speech));
x=speech;
figure(2)
clf
ax(1) = subplot(3,1,1);
plot(t, x)
grid on; box on;
ylabel('Amplitude')
xlabel('Time [s]')
title('Speech')
ax(2) = subplot(3,1,2);
hold on
plot(tWin, p)
plot(tWin, e)
plot(tWin, zcr)
grid on; box on;
xlabel('Time [s]')
title('Features')
legend('Periodicity', 'Energy', 'Zero Crossing Rate')
ax(3) = subplot(3,1,3);
plot(tWin, f0, 'k')
grid on; box on;
ylabel('Frequency [Hz]')
xlabel('Time [s]')
title('Pitch-Contour')
linkaxes(ax, 'x')


