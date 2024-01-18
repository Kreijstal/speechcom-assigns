function H = computeFilter(mids, freqs)
    k = length(mids) - 2;
    H = zeros(k, length(freqs));

    for t = 2:k+1
        for f = 1:length(freqs)
            if freqs(f) < mids(t - 1)
                H(t - 1, f) = 0;
            elseif freqs(f) < mids(t)
                H(t - 1, f) = 2 * (freqs(f) - mids(t - 1)) / ((mids(t + 1) - mids(t - 1)) * (mids(t) - mids(t - 1)));
            elseif freqs(f) <= mids(t + 1)
                H(t - 1, f) = 2 * (mids(t + 1) - freqs(f)) / ((mids(t + 1) - mids(t - 1)) * (mids(t + 1) - mids(t)));
            else
                H(t - 1, f) = 0;
            end
        end
    end
end

