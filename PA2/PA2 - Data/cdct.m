function cc = cdct(x, M)
%CDCT calculates the discrete cosine transform - type 2, in order calculate
%a cepstrum with M number of coefficients.

nWins = size(x,2); % number of windows
N = size(x,1); % length of each window signal

% M can't be greater than N
M = min(M,N);

cc = zeros(M,N); % allocate output vector
for iRow = 1:nWins
    for k=1:M
        
        % DCT - Type II formula 
        cc(k,iRow) = sqrt(2/N) * ...
            sum(   x(:,iRow)' .* cos( pi/(2*N) * (2*(1:N)-1) * (k-1) )   );
        
    end
end

end