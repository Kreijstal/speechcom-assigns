function h = hann( M )

alpha = 0.5;
beta = -0.5;
k = 1:M;

h = alpha + beta * cos( k * 2*pi / M );
h = h';

end

