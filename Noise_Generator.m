function [noise_sample] = Noise_Generator(SNR,number_of_bits)

% this function only generates the noise sample based on the SNR given
% one of the parameter should be regarding the SNR in db
% based on the SNR power we need to find the appropriate noise power
% after finding the noise power we need to generate the samples from that
% noise power
% 

% generat 1024 nosie samples
noise_sample = randn(1,number_of_bits);
noise_sample = noise_sample - mean(noise_sample); % making the noise sample 0 mean
noise_sample = noise_sample./sqrt(var(noise_sample)); % to make the var 1 

% finding the noise var needed
noise_var = 1/(10^(SNR/10)) ;
disp("noise_var "+noise_var);
%disp(noise_var)
noise_sample = sqrt(noise_var).*noise_sample; % making the var of the noise sample be SNR
disp("Noise power is "+noise_var+" Noise var is "+var(noise_sample));
%disp(var(noise_sample));
%disp(mean(noise_sample));

% SNRdb = 20; %Given SNRdb
% variance = 1/(10^(SNRdb/10)); 
% W = sqrt(variance).*randn(1,1024); %Gaussian white noise W\
% disp("var " + var(W));
% disp("mean "+mean(W));
end

