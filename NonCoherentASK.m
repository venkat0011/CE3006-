% non coherent ask demodulation
clear workspace;
carrier_freq = 10000; %10kHz
sampling_freq = 16 * carrier_freq;
[actual_signal,actual_signal_binary] = Random_BitGenerator(1024);
t = 0:1/sampling_freq:1024/1000 ;
carrier_function = 5.*cos(2*pi*carrier_freq*t);
[b,a] = butter(6,0.2);
count = 0;
for bit = actual_signal_binary
    for i = 1:160
        count = count+1;
        transmitted_signal_binary(count) = bit;
    end
end
transmitted_signal_binary(count+1) = transmitted_signal_binary(count);
OOKmodulated_signal = transmitted_signal_binary .* carrier_function;
signal_power_OOK = rms(OOKmodulated_signal)^2;
index = 0;
for SNR = 0:5:50
    index = index+1;
    noise_power_OOK = signal_power_OOK/(10^(SNR/10));
    for sample = 1:20
        noise_sample_OOK = randn(1,length(OOKmodulated_signal));
        noise_sample_OOK = noise_sample_OOK - mean(noise_sample_OOK); % making the noise sample 0 mean
        noise_sample_OOK = noise_sample_OOK./sqrt(var(noise_sample_OOK)); % to make the var 1
        noise_sample_OOK = sqrt(noise_power_OOK) .* noise_sample_OOK;
        OOK_transmitted = OOKmodulated_signal+noise_sample_OOK;
        
        demodulated_NC_OOK = envelope(OOK_transmitted);
%         plot(t(1:800),demodulated_NC_OOK(1:800))
%         signal_out_NC_OOK = filtfilt(b,a,demodulated_NC_OOK);   
%         plot(t(1:800),signal_out_NC_OOK(1:800));
        count = 0;
        for i = 80:160:length(demodulated_NC_OOK)
            count = count+1;
            
            if (demodulated_NC_OOK(i)>= 5/2 )
                result_NC_OOK(count) = 1;
            else
                result_NC_OOK(count) = 0;
            end
        end
        bit_error_NC_OOK(sample) = mean(result_NC_OOK~=actual_signal_binary);
     end
    mean_bit_error_NC_OOK(index) = mean(bit_error_NC_OOK);
    theoretical_NC(index) = 0.5 * exp(-0.5*(10^(SNR/10)));
    x_axis(index) = SNR;
end

figure(1)
semilogy (x_axis, theoretical_NC,'r', 'linewidth', 1.5);
hold on
plot1 = semilogy(x_axis, mean_bit_error_NC_OOK,'r*');
hold off
ylabel('Bit Error Rate (BER)');
xlabel('SNR (dB)');
legend([plot1(1) ],{'NON Coherent OOK'})
xlim([0 20]);
title("Empirical and Theoretical BER for NON Coherrent Detection Techniques")