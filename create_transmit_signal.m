function x = create_transmit_signal(bits, plots)
    % Load constants
    constants;
    
    % Fill variables
    if nargin < 2
        plots = false;
    end
    
    
    % Pad bits to full length
    if(length(bits) > L)
        error('Provided packet exceeds max packet size');
    end
    M = length(bits);
    bits = [bits zeros(1,L-M)];
    
    
    % Display message, pulse and pilot
    if plots
        figure(1); clf(1);
        subplot(4,1,1); hold on;
        stem(bits,'c');
        stem(bits(1:M));
        title('Bits to transmit');
        legend('Padding','Message');
        
        subplot(4,1,2);
        stem(pulse);
        title('Pulse waveform');
    end
    
    
    % Map to symbols
    % Uses BPSK (i.e. +/- 1)
    syms = 2*bits-1;
    
    
    % Expand in time and convolve with pulse sequence
    x = upsample(syms,T);
    x = conv(x,pulse);
    
    
    % Place pilot sequence at head
    x = [pilot x];
    
    if plots
        subplot(4,1,3); hold on;
        plot(x);
        plot(pilot,'c');
        title('Transmit signal');
        legend('Message','Pilot');
        
        spec = fftshift(fft(x));
        subplot(4,1,4); hold on;
        plot(linspace(-pi,pi,length(spec)),20*log10(abs(spec)+.01));
        title('Transmit spectrum');
        xlabel('\omega'); ylabel('Spectral power (dB)');
    end
end