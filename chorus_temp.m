% This function performs the chorus effect

%% Initial setup
[audio, Fs] = audioread('Guitar Clean.wav');
pad_num = 5000;
input = [zeros(1, pad_num), transpose(audio)];
audio_size = size(audio, 1);
output = zeros(1, audio_size);

lfo_rate = 882; % --> period of 50Hz
% 8820 samples --> 0.2 seconds
A = 4410;
%10,000 blocks
max = 4410;
n = 1:max;
lfo1 = round(600*cos(2*pi*n/1764) + 600);
lfo2 = 10 + lfo1;
lfo3 = 30 + lfo1;
lfo4 = 50 + lfo1;

for num_buffer = 1:floor(audio_size) 
    in_buf = input(pad_num+num_buffer);
    
        num_delays1 = lfo1(mod(num_buffer, max)+1);
        num_delays2 = lfo2(mod(num_buffer, max)+1);
        num_delays3 = lfo3(mod(num_buffer, max)+1);
        num_delays4 = lfo4(mod(num_buffer, max)+1);
    
    start_index1 = pad_num + (num_buffer) - num_delays1 + 1;
    start_index2 = pad_num + (num_buffer) - num_delays2 + 1;
    start_index3 = pad_num + (num_buffer) - num_delays3 + 1;
    start_index4 = pad_num + (num_buffer) - num_delays4 + 1;
    wet = (input(start_index1) / 4) + (input(start_index2) / 4) + (input(start_index3) / 4) + (input(start_index4) / 4);
    out_buf = 3 * (wet / 4) +  (3 * in_buf / 4);
    output(num_buffer) = out_buf;
end

% lpf = butter(5, 0.1*pi);
% output = conv(lpf, output);
audiowrite('Guitar Chorus.wav', output, Fs);