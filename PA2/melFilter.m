function melSpec = melFilter(spec, H)
    % Matrix multiplication between the triangular filter H and the absolute values of the spectrum spec
    melSpec = H * abs(spec);
end