function edges = melfreqs(fmin, fmax, k)
    % Convert fmin and fmax to Mel scale
    mel_min = 2595 * log10(1 + fmin / 700);
    mel_max = 2595 * log10(1 + fmax / 700);

    % Create a vector of equally spaced values in the Mel scale
    mel_edges = linspace(mel_min, mel_max, k + 2);

    % Convert the Mel values back to the linear frequency domain
    edges = 700 * (10.^(mel_edges / 2595) - 1);
end

