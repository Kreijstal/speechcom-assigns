% -------------------------------------------------------------------------
%
%       Speech Communication - PROGRAMMING ASSIGNMENT II - Template
%       Date: 16.12.2019
% 
% -------------------------------------------------------------------------

%% Prepare
clear; clc; close all;
addpath('../');
%% Read wave file
audiofile = '13ZZ637A.wav';
[x, fs] = audioread(audiofile);

%% Compute spectrogram
[spec, freqs, tWin] = calcSpectrogram(x, fs);

%% Plot spectrogram of audiofile
figure
imagesc(tWin, freqs, 20*log10(abs(spec)));
set(gca,'YDir', 'normal')
xlabel('Time [s]')
ylabel('Frequency [Hz]')
colorbar
title(['Spectrogram of "',audiofile '"'])

%% Fill in your solution here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% E1 Computation of equally spaced points on the mel-scale
fmin = min(freqs);
fmax = max(freqs);

k = 24;
% ... call the function melfreqs
edges = melfreqs(fmin, fmax, k);

% E2 Computation of the mids of the triangular filters

% ... call the function computeMids
mids = computeMids(freqs, edges);

% E3 Computation of the mel-filter bank

% ... call the function computeFilter
H = computeFilter(mids, freqs);

% Remove dummy rows (first and last)
H = H(2:end-1, :);

% Plot all k triangular filters over the frequency into one figure
figure
for t = 1:size(H, 1)
    plot(freqs, H(t, :));
    hold on;
end
hold off;

xlabel('Frequency [Hz]');
ylabel('Amplitude');
title(['mel-filter bank for "',audiofile '"']);

% E4 Computation of the mel-filtered spectrum

% ... call the function melFilter
melSpec = melFilter(spec, H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot of the mel-filtered spectrum
mids = mids(:); % make sure mids is a column vector for y-tick labeling
figure
imagesc(tWin, [], melSpec);
set(gca,'YDir', 'normal')
set(gca,'ytick',3:3:length(mids));
set(gca,'yticklabel',num2str(mids(3:3:length(mids)),'%0.0f'));
xlabel('Time [s]')
ylabel('Frequency [Hz]')
colorbar
title(['mel-filtered Spectrogram of "',audiofile '"'])

%% Speaker recognition model
% Uses 3 files from different speakers for training a prediction model, 
% then the model predicts the speakers of 3 test files.

% load the speech data from AN4 database (3 speakers with each 2 two files)
load speech

% ---- 1. Calculate MFCCs of training files  ------------------------------
numcep = 13; % number of ceptral coefficients to use as features for the prediction model

spec1 = calcSpectrogram(x1, fs);
melSpec1 = melFilter(spec1, H);
mfcc1 = cdct(log10(melSpec1), numcep); % calculate ceptrum coefficents from the mel-filtered spectrum

spec2 = calcSpectrogram(x2, fs);
melSpec2 = melFilter(spec2, H);
mfcc2 = cdct(log10(melSpec2), numcep);

spec3 = calcSpectrogram(x3, fs);
melSpec3 = melFilter(spec3, H);
mfcc3 = cdct(log10(melSpec3), numcep);

% ---- 2. Train the recognition GMM model ---------------------------------
nGMM = 2;  % num of GMM classes
options = statset('MaxIter', 500);
GMModel1 = fitgmdist(mfcc1', nGMM, 'RegularizationValue', 0.01, 'Options', options);
GMModel2 = fitgmdist(mfcc2', nGMM, 'RegularizationValue', 0.01, 'Options', options);
GMModel3 = fitgmdist(mfcc3', nGMM, 'RegularizationValue', 0.01, 'Options', options);

% ---- 3. Calculate MFCCs of test files -----------------------------------
spec1_test = calcSpectrogram(x1_test, fs);
melSpec1_test = melFilter(spec1_test, H);
mfc1_test = cdct(log10(melSpec1_test), numcep);

spec2_test = calcSpectrogram(x2_test, fs);
melSpec2_test = melFilter(spec2_test, H);
mfc2_test = cdct(log10(melSpec2_test), numcep);

spec3_test = calcSpectrogram(x3_test, fs);
melSpec3_test = melFilter(spec3_test, H);
mfc3_test = cdct(log10(melSpec3_test), numcep);

% ---- 4. Get prediction results ------------------------------------------
fprintf('--- Test the GMM speaker recognition model ---\n\n')
p1 = [pdf(GMModel1, mfc1_test'), pdf(GMModel2, mfc1_test'), pdf(GMModel3, mfc1_test')]; 
[~, cIdx1] = max(p1,[],2); 
fprintf('Speaker 1 detected as: Speaker %i\n', mode(cIdx1)) % the speaker who was detected for most windows is used as result

p2 = [pdf(GMModel1, mfc2_test'), pdf(GMModel2, mfc2_test'), pdf(GMModel3, mfc2_test')]; 
[~, cIdx2] = max(p2,[],2); 
fprintf('Speaker 2 detected as: Speaker %i\n', mode(cIdx2))

p3 = [pdf(GMModel1, mfc3_test'), pdf(GMModel2, mfc3_test'), pdf(GMModel3, mfc3_test')]; 
[~, cIdx3] = max(p3,[],2); 
fprintf('Speaker 3 detected as: Speaker %i\n\n', mode(cIdx3))

% you may listen to the speech files to check if you can distinguish the
% different speakers
% sound(x1, fs)

