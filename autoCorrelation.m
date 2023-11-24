function r_xx = autoCorrelation(signal, maxTimeLag)
    N = length(signal);
    r_xx = zeros(1, maxTimeLag + 1);

    for tau = 0:maxTimeLag
        sum_val = sum(signal(1:N-tau) .* signal(tau+1:N));
        r_xx(tau + 1) = sum_val / N;
    end
