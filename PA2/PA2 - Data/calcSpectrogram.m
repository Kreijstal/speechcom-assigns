function [y, f, tWin] = calcSpectrogram(x, fs)

% Spectrogram parameters
overlapRatio = 50;
tWin = 0.02;

% Calculate number of samples in each window
nWin = tWin*fs;
nWin = pow2(nextpow2(nWin));

% Divide the signal in windows
[xWin, tWin] = makeWin(x, fs, nWin, overlapRatio);

% Apply Hann window
h = hann(nWin);

xWinH = zeros( size(xWin) );
for i = 1:size(xWin,2)
    xWinH(:,i) = h.*xWin(:,i);
end

% Calculate spectrogram
y = fft(xWinH);
f = linspace(0, fs/2, nWin/2+1);
y = y(1:length(f),:);

% Plot spectrogram
% figure
% imagesc( tWin, f/1000, 20*log10( abs(y) ) )
% set(gca,'YDir','normal'); %flip y-axis
% ylabel('Frequency [kHz]')
% xlabel('Time [s]')

end

