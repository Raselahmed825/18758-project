%
% constants.m
%    Defines the set of constants to be used for the comm system
%

% Constants defined by the radio
Fs = 2e6;     % transmit rate of USRP in Hz
maxL = 10000; % max samples in output signal


% Transmit constants
T = 4;  % samples per symbol
B = 3;  % bits per symbol
L = 3036; % packet size in bits

% Coding constants
coded = true; % enable
R = 2;        % coded bits per data bit
interleaveA = 132; interleaveB = R*23; % Factors of interleaving

if ~coded, R=1; end;


% Hamming pulse for modulation. Normalize to unit energy
pulse = hamming(T)';
pulse = pulse/norm(pulse);


% De Bruijn sequence of order 5 for timing sequence
% Using a BPSK modulation 
pilotBits = [0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, ...
             0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1];

pilotT = 20;
pilotPulse = ones(1,pilotT/2); pilotPulse = pilotPulse/norm(pilotPulse);

pilot = upsample(2*pilotBits-1,pilotT);
pilot = conv(pilot,pilotPulse);


% Channel constants for simulation
SNR = 10; % dB
Ex = 1; % expected symbol energy
sigN = Ex / 10.^(SNR/10); % noise variance

maxdelay = 500; % max delay before transmit in samples
atten = [40 60]; % factor of attenuation during transmit