% This function performs the chorus effect
% Output is a buffer of size n that holds the processed input

% audio has 614016 samples
n = 64;
i = 1;

[audio, Fs] = audioread('Guitar Clean.wav');
pad_num = 5000;
input = [zeros(1, pad_num), transpose(audio)];

output = zeros(1, 614016);
total_copies = 20;
multiplier = 100;
copy_delays = randi(pad_num, 1, total_copies);

lfo_rate = 882; % --> period of 50Hz
% 8820 samples --> 0.2 seconds
A = 4410;
%10,000 blocks
lfo1 = repmat([100 300 500 700 900 1100 1300 1300 1100 900 700 500 300 100], 700);
lfo2 = 10 + lfo1;
lfo3 = 30 + lfo1;
lfo4 = 50 + lfo1;

in_buf = zeros(1, n);

for num_buffer = 1:floor(614016 / 64) 
    in_buf_start_index = pad_num + (num_buffer-1)*n+1;
    in_buf_end_index = in_buf_start_index + n - 1;
    in_buf = input(in_buf_start_index:in_buf_end_index);
    
    num_delays1 = lfo1(num_buffer);
    num_delays2 = lfo2(num_buffer);
    num_delays3 = lfo3(num_buffer);
    num_delays4 = lfo4(num_buffer);
    
    start_index1 = pad_num + (n*(num_buffer-1)) - num_delays1 + 1;
    end_index1 = start_index1 + n - 1;
    start_index2 = pad_num + (n*(num_buffer-1)) - num_delays2 + 1;
    end_index2 = start_index2 + n - 1;
    start_index3 = pad_num + (n*(num_buffer-1)) - num_delays3 + 1;
    end_index3 = start_index3 + n - 1;
    start_index4 = pad_num + (n*(num_buffer-1)) - num_delays4 + 1;
    end_index4 = start_index4 + n - 1;
    wet = (input(start_index1:end_index1) / 4) + (input(start_index2:end_index2) / 4) + (input(start_index3:end_index3) / 4) + (input(start_index4:end_index4) / 4);
    out_buf = (in_buf / 2) +  (wet / 2);
    %out_buf = wet;
    
    out_buf_start_index = n*(num_buffer-1)+1;
    out_buf_end_index = out_buf_start_index + n - 1;
    output(out_buf_start_index:out_buf_end_index) = out_buf;
end

% for delayed_copy_num = 1:total_copies
%     start_index = pad_num + (n*(i-1)) - copy_delays(delayed_copy_num) + 1;
%     end_index = start_index + n - 1;
%     output = output + (input(start_index:end_index) / total_copies); 
% end

audiowrite('Guitar Chorus.wav', output, Fs);