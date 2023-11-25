[speech, fs] = audioread('PA1/speech1.wav');
addpath('./PA1/');

% nWin is 50ms in samples
nWin = 0.05 * fs;

[xWin, tWin] = makeWin(speech, fs, nWin, 8/10);

% for every window
f0=[]
zcr=[]
e=[]
p=[]
%loop all columns of xWin
for i = 1:size(xWin, 2)
    xWinI=xWin(:,i);
    %compute autocorrelation
    r_xx = autoCorrelation(xWinI, nWin);

    %normalize autocorrelecation
    r_xx_norm = r_xx / r_xx(1);
    %find the energy of the signal
    E= sum(xWinI.^2);
    %we calculate the zero crossing rate, we use zeroCrossing.m
    zcra = zeroCrossing(xWinI);

    %we then calculate the fundamental frequency
    f_0 = findF0(r_xx_norm,zcra,fs);

    %we add the zeros
    zc = sum(zcra);

    %we calculate it's periodicity of the signal window
    p_0 = 1/f_0;

    %set a theshhold matrix for all features
    thresh = [0.1,0.1,0.1];

    isVoiced = [E > thresh(1), zc > thresh(2), p > thresh(3)];
    %if it's voiced then we add f_0 to f0 vector otherwise nan
    
    if isVoiced
        f0 = [f0, f_0];
    else
        f0 = [f0, nan];
    end
    %we add the zero crossing rate to the zcr vector
    zcr = [zcr, zc];
    %we add the energy to the energy vector
    e = [e, E];
    %we add the periodicity to the periodicity vector
    p = [p, p_0];

end

% Create the time vector for the x-axis in seconds
t = linspace(0, length(speech)/fs, length(speech));
x=speech;
figure(2)
clf
ax(1) = subplot(3,1,1);
plot(t, x)
grid on; box on;
ax(2) = subplot(3,1,2);
hold on
plot(tWin, p)
plot(tWin, e)
plot(tWin, zcr)
grid on; box on;
ax(3) = subplot(3,1,3);
plot(tWin, f0, 'k')
grid on; box on;
linkaxes(ax, 'x')


function f0=findF0(r,zc,fs)
    % find first zero crossing
    zc = find(zc,1);
    % from this index find the first peak
    for i = zc:length(r)
        if r(i) > r(i-1) && r(i) > r(i+1)
            peak = i;
            break;
        end
    end
    % calculate the fundamental frequency
    f0 = fs / peak;
end
