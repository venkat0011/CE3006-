% This function is to randomly generate the signal that has 10 bits
function [ random_bits,random_bits_binary] = Random_BitGenerator(number_of_bits) 
% First step is to create 1024 smaples of 0 and 1 
rng('default')
random_bits = 0 + (1-0+1)*rand(1,number_of_bits);
random_bits = floor(random_bits);
random_bits_binary = random_bits;
% convert 1 to +1 and 0 to -1
for i = 1:number_of_bits
    if(random_bits(i)==0)
        random_bits(i) = -1;
    end
        
end



