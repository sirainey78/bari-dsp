% This function performs the chorus effect

%% Initial setup
[audio, Fs] = audioread('Guitar Clean.wav');
pad_num = 500;
input = [zeros(1, pad_num), transpose(audio)];
audio_size = size(audio, 1);
output = zeros(1, audio_size);

% Buffer size
n = 4;


lfo_rate = 882; % --> period of 50Hz
% 8820 samples --> 0.2 seconds
A = 4410;
%10,000 blocks
lfo1 = repmat([100 300 500 700 900 1100 1300 1300 1100 900 700 500 300 100], 700);
lfo2 = 10 + lfo1;
lfo3 = 30 + lfo1;
lfo4 = 50 + lfo1;

in_buf = zeros(1, n);

for num_buffer = 1:floor(audio_size / n) 
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
    out_buf = 3 * (in_buf / 4) +  (3 * wet / 4);
    
    out_buf_start_index = n*(num_buffer-1)+1;
    out_buf_end_index = out_buf_start_index + n - 1;
    output(out_buf_start_index:out_buf_end_index) = out_buf;
end

% lpf = butter(5, 0.1*pi);
% output = conv(lpf, output);
audiowrite('Guitar Chorus.wav', output, Fs);