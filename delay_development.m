% This function performs the delay effect

%% Initial setup
[audio, Fs] = audioread('Chorus Example.wav');
input = transpose(audio);
audio_size = size(audio, 1);
output = zeros(1, audio_size);

% Buffer size
n = 64;

%% User parameters
% Time until you hear the echo'd signal
delay_time = 0.3;

% Value between 0 and 1 that determines the echo's decay rate
delay_feedback_gain = 0.35;

% How much of the output you want to be the delayed signal
delay_wet_mix = 0.45;

%% Loop setup

% The dry mix is the original input
delay_dry_mix = 1 - delay_wet_mix;

% How many wet delay samples we need to store: multiple of n
delay_line_size = n * ceil(delay_time * Fs / n);

% Initialize the wet delay line
delay_line = zeros(1, delay_line_size);

% Initialize the input buffer of size n
in_buf = zeros(1, n);

% The index we start writing to in the wet delay line
initial_offset = delay_line_size - n;

% Processing loop
for num_buffer = 1:floor(audio_size / n) 
    
    % Set input buffer from input
    in_buf_start_index = (num_buffer - 1) * n + 1;
    in_buf_end_index = in_buf_start_index + n - 1;
    in_buf = input(in_buf_start_index:in_buf_end_index);
    
    % Get relevant wet delay line samples
    wet_start_index = mod((initial_offset + (num_buffer - 1) * n + 1), delay_line_size);
    wet_end_index = wet_start_index + n - 1;
    wet = delay_line(wet_start_index:wet_end_index);
    
    % Output is a linear comb. of the input and wet delay line based on
    % user-chosen rates
    out_buf = (delay_dry_mix * in_buf) +  (delay_wet_mix * wet);
    
    % Write output buffer to output
    out_buf_start_index = n * (num_buffer - 1) + 1;
    out_buf_end_index = out_buf_start_index + n - 1;
    output(out_buf_start_index:out_buf_end_index) = out_buf;
    
    % Update delay lines
    delay_line(wet_start_index:wet_end_index) = delay_feedback_gain * (wet + in_buf);
end

%% Output file writing
audiowrite('Guitar Delay.wav', output, Fs);