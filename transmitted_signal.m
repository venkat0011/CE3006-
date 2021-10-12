function [transmitted_signal] = transmitted_signal(SNR)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[actual_signal,~] = Random_BitGenerator;
noise_generated = Noise_Generator(SNR);
transmitted_signal = actual_signal+noise_generated;
    for j = 1:1024
        %disp("transmitted is "+transmitted_signal(j)+" actual is "+actual_signal(j))
        if(transmitted_signal(j)>=0)
            transmitted_signal(j) = 1;
        else
            transmitted_signal(j)= 0;
        end
    end
end

