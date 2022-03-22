function [ output ] = bari_chorus( in_buf, in_storage, n, i )
% This function performs the chorus effect
% Output is a buffer of size n that holds the processed input

[audio, Fs] = audioread('Guitar Clean.wav');
audio = [zeros(1:200), audio];

output = zeros(1, n);
total_copies = 10;
copy_delays = [10 20 30 40 50 60 70 80 90];

for delayed_copy_num = 1:total_copies
    start_index = 200 + (n*i) - copy_delays(delayed_copy_num);
    end_index = start_index + n;
    output = output + (audio(start_index:end_index) / total_copies); 
end

end