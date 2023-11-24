function zero_crossings =  ZeroCrossing(signal)
    zero_crossings = zeros(length(signal), 1);  % Initialize an array of zeros
    for i = 1:length(signal) - 1
        if (signal(i) < 0 && signal(i + 1) > 0) || (signal(i) > 0 && signal(i + 1) < 0)
            zero_crossings(i) = 1;
        end
    end
end