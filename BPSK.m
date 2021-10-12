clear all; clear workspace;
% for bpsk mod and demodulation
carrier_freq = 10000; %10kHz
sampling_freq = 16 * carrier_freq;
[actual_signal,actual_signal_binary] = Random_BitGenerator(1024);
t = 0:1/sampling_freq:1024/1000 ;
carrier_function = 5.*cos(2*pi*carrier_freq*t);
[b,a] = butter(6,0.2);
count = 0;
for bit = actual_signal
    for i = 1:160
        count = count+1;
        transmitted_signal(count) = bit;
    end
end
transmitted_signal(count+1) = transmitted_signal(count);
BPSKmodulated_signal = transmitted_signal .* carrier_function;
signal_power_BPSK = rms(BPSKmodulated_signal)^2;
index = 0;
for SNR = 0:0.5:50
    index = index+1;
    noise_power_BPSK = signal_power_BPSK/(10^(SNR/10));
    noise_sample_BPSK = randn(1,length(BPSKmodulated_signal));
    noise_sample_BPSK = noise_sample_BPSK - mean(noise_sample_BPSK); % making the noise sample 0 mean
    noise_sample_BPSK = noise_sample_BPSK./sqrt(var(noise_sample_BPSK)); % to make the var 1
    noise_sample_BPSK = sqrt(noise_power_BPSK) .* noise_sample_BPSK;
    BPSK_transmitted = BPSKmodulated_signal+noise_sample_BPSK;

    demodulated_BPSK = BPSK_transmitted .* 2 .* carrier_function;
    signal_out_BPSK = filtfilt(b,a,demodulated_BPSK);
    plot(t(1:800),signal_out_BPSK(1:800));
    count = 0;
    for i = 80:160:length(signal_out_BPSK)
        count = count+1;
        if (signal_out_BPSK(i)>=0)
            result_BPSK(count) = 1;
        else
            result_BPSK(count) = 0;
        end
    end
    bit_error_BPSK(index) = mean(result_BPSK~=actual_signal_binary);
    theoretical_BPSK(index) = qfunc(sqrt(2*(10^(SNR/10))));
    x_axis(index) = SNR;
end

figure(1)

semilogy (x_axis, theoretical_BPSK,'b', 'linewidth', 1.5);
hold on
plot2 = semilogy(x_axis, bit_error_BPSK, 'b*');
hold off
ylabel('Bit Error Rate (BER)');
xlabel('SNR (dB)');
xlim([0 15]);
title("Empirical and Theoretical BER for Coherrent Detection Techniques")
