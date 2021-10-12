clear;clear workspace;
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
for SNR = 0:1:50
    index = index+1;

    for sample = 1:20
        noise_power_OOK = signal_power_OOK/(10^(SNR/10));
        noise_sample_OOK = randn(1,length(OOKmodulated_signal));
        noise_sample_OOK = noise_sample_OOK - mean(noise_sample_OOK); % making the noise sample 0 mean
        noise_sample_OOK = noise_sample_OOK./sqrt(var(noise_sample_OOK)); % to make the var 1
        noise_sample_OOK = sqrt(noise_power_OOK) .* noise_sample_OOK;
        OOK_transmitted = OOKmodulated_signal+noise_sample_OOK;
        
        demodulated_OOK = OOK_transmitted .* 2 .* carrier_function;
        signal_out_OOK = filtfilt(b,a,demodulated_OOK);
  
        count = 0;
        for i = 80:160:length(signal_out_OOK)
            count = count+1;
            result(count) = signal_out_OOK(i);
        end
        result_OOK_binary = (result>25/2);
        bit_errorOOK(sample) = mean(result_OOK_binary~=actual_signal_binary);
    end
    mean_bit_errorOOK(index) = mean(bit_errorOOK);
    theoretical(index) = qfunc(sqrt(10^(SNR/10)));
    x_axis(index) = SNR;
end

figure(1)
semilogy (x_axis, theoretical,'r', 'linewidth', 1.5);
hold on
plot1 = semilogy(x_axis, mean_bit_errorOOK,'r*');
hold off
ylabel('Bit Error Rate (BER)');
xlabel('SNR (dB)');
legend([plot1(1) ],{'Coherent OOK'})
xlim([0 50]);
title("Empirical and Theoretical BER for Coherrent Detection Techniques")




