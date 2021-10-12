%generate the actual signal
[actual_signal,actual_signal_binary] = Random_BitGenerator(1024);
bit_error_rate = (11);
SNR = (11);
for i = 0:5:50

    disp("loop count"+i);
    noise_generated = Noise_Generator(i,1024);
    transmitted_signal = actual_signal+noise_generated;
    for j = 1:1024
        %disp("transmitted is "+transmitted_signal(j)+" actual is "+actual_signal(j))
        if(transmitted_signal(j)>=0)
            transmitted_signal(j) = 1;
        else
            transmitted_signal(j)= 0;
        end
    end
    bit_error_rate((i+5)/5) = mean(transmitted_signal~=actual_signal_binary);
    SNR((i+5)/5) = i;
end

SNR_dec = 10.^(SNR./10) ;
theory_rate = (1/2) .* erfc(sqrt(SNR_dec ./ 2));
figure(1)
semilogy (SNR, theory_rate,'r', 'linewidth', 1.5);
ylabel('BER');
xlabel('SNR (dB)')
title('BER vs SNR (dB) - Step Size: 5');
hold on
semilogy (SNR, bit_error_rate,'bx', 'linewidth', 2);
legend('Theoretical BER','Real BER');
hold off

% questions to ask why did the bit error rate go to 0 when SNR increases
% why did it stop at 10db SNR, why was the threshold 10


% look into the calculation of theory rate

