function [xWin, tWin] = makeWin(x, fs, nWin, overlapRatio)
%makeWin divides the input signal in overlapping windows and stores them in
%a matrix
%
% Inputs:
%   x:              Audio data
%   fs:             Sample frequency
%   nWin:           Length of window in samples
%   overlapRatio:   Percentage of overlapping samples 


% Numbers of samples in audiodata
nSamples = length(x);

% Calculate number of overlapping samples
nOverlap = floor( overlapRatio/100 * nWin );

% Determine the number of segments and thus also the number of columns in 
% the output matrix
nCol = floor( (nSamples-nOverlap) / (nWin-nOverlap) );

colOffsets = (0:(nCol-1)) * (nWin-nOverlap);
colOffsetsMat = repmat(colOffsets,nWin,1);

rowIdx = (1:nWin)';
rowIdxMat = repmat(rowIdx,1,nCol);


xWinIdx = rowIdxMat+colOffsetsMat;

% segment x into individual columns with the proper offsets
xWin = x(xWinIdx);

% return time vector whose elements are centered in each segment
tWin = (colOffsets+(nWin/2))/fs;
end