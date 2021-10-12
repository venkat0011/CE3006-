clear all; clear workspace;
carrier_freq = 10000; %10kHz
sampling_freq = 16 * carrier_freq;
[actual_signal,actual_signal_binary] = Random_BitGenerator(1024);
t = 0:1/sampling_freq:1024/1000 ;
carrier_function = 5.*cos(2*pi*carrier_freq*t);
carrier_function0 = 5.*cos(pi*carrier_freq*t);
[b,a] = butter(6,0.2);
count = 0;
for bit = actual_signal
    for i = 1:160
        count = count+1;
        transmitted_signal(count) = bit;
    end
end
transmitted_signal(count+1) = transmitted_signal(count);
BFSK_Modulated1 = carrier_function .* (transmitted_signal == 1);
BFSK_Modulated0 = carrier_function0 .* (transmitted_signal == -1);
BFSK_modualted = BFSK_Modulated1 + BFSK_Modulated0;
signal_power_BFSK = rms(BFSK_modualted)^2;
index = 0;
for SNR = 0:1:50
index = index+1;
    for sample = 1:20
        noise_power_BFSK = signal_power_BFSK/(10^(SNR/10));
        noise_sample_BFSK = randn(1,length(BFSK_modualted));
        noise_sample_BFSK = noise_sample_BFSK - mean(noise_sample_BFSK); % making the noise sample 0 mean
        noise_sample_BFSK = noise_sample_BFSK./sqrt(var(noise_sample_BFSK)); % to make the var 1
        noise_sample_BFSK = sqrt(noise_power_BFSK) .* noise_sample_BFSK;
        
        BFSK_transmitted = BFSK_modualted+noise_sample_BFSK;
        BFSK_demod1 = BFSK_transmitted .* 2.* carrier_function;
        BFSK1_filter = filtfilt(b,a,BFSK_demod1);
        
        BFSK_demod0 = BFSK_transmitted .*2 .* carrier_function0;
        BFSK0_filter = filtfilt(b,a,BFSK_demod0);
        
        BFSK_demod = BFSK_demod1 -BFSK_demod0 ;
        count = 0;
        % sampling
        for i = 80:160:length(BFSK_demod)
            count = count+1;
            result(count) = BFSK_demod(i);
        end
        result_BFSK = (result>0);
        bit_errorBFSK(sample) = mean(result_BFSK~=actual_signal_binary);
    end
    meanBiterrorBFSK(index) = mean(bit_errorBFSK);
    theoreticalBFSK(index) = qfunc(sqrt(10^(SNR/10)));
    x_axis(index) = SNR;
end
% 

figure(1)
semilogy (x_axis, theoreticalBFSK,'r', 'linewidth', 1.5);
hold on
plot1 = semilogy(x_axis, meanBiterrorBFSK,'r*');
hold off
ylabel('Bit Error Rate (BER)');
xlabel('SNR (dB)');
legend([plot1(1) ],{'BFSK'})
xlim([0 50]);
title("Empirical and Theoretical BER for Coherrent Detection Techniques")