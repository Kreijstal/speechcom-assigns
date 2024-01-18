% So here we map edges we got from the melfreqs to a given frequencies whatever is closest to the mel frequency
function mids = computeMids(freqs, edges)
    mids = zeros(1, length(edges));

    mids(1) = freqs(1);
    mids(end) = edges(end);

    for i = 2:length(edges) - 1
        [~, idx] = min(abs(freqs - edges(i)));
        
        mids(i) = freqs(idx);
    end
end

