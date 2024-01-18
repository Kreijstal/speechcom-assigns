function [out] = zeroCrossing(x)
%zeroCrossing returns an array of the size of the inputarray
%ones in the output mark zero crossings
%usage: zerocrossings = zero_crossing(speechsignal)

% Initialize the output variable
out = zeros(size(x,1),1);
nSamples = size(x,1);

% Start with the second value in x
for i=2:nSamples
      
    % Check if the current value is greater/equal zero and the preceeding 
    % below zero or if the current value is below zero and the preceeding
    % above/equal zero
    if (x(i)>=0 && x(i-1)<0) || (x(i)<0 && x(i-1)>=0)
        out(i) = 1; % one marks a zero crossing
    else
        out(i) = 0;
    end
    
end
        