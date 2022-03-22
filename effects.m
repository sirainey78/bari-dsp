%% Read mono audio file (guitar signal)
[audio, Fs] = audioread('Guitar Clean.wav');

%% Input buffer of n samples
n = 64;
in_buf = zeros(1:n);

%% Output buffers of n samples
out_buf_eq = zeros(1:n);
out_buf_delay = zeros(1:n);
out_buf_chorus = zeros(1:n);

%% Resulting output
out_size = size(audio, 1);
out_eq = zeros(1:out_size);
out_delay = zeros(1:out_size);
out_chorus = zeros(1:out_size);

%% Stored inputs
% in_secs_to_store = 0.05;
% in_num_samples_to_store = ceil(in_secs_to_store * Fs);
% in_storage = zeros(1:in_num_samples_to_store);
in_storage = audio;

%% Stored outputs
% out_num_samples_to_store = 200;
% out_storage = zeros(1:out_num_samples_to_store);

%% Wet delay line storage
% delay_secs_to_store = 0.5;
% delay_num_samples_to_store = ceil(delay_secs_to_store * Fs);
% delay_storage = zeros(1:delay_num_samples_to_store);
delay_storage = zeros(1:out_size);

%% Simulate block processing of n samples
num_iterations = floor(size(audio, 1) / n); 
for i = 1:num_iterations  
    % Establish input buffer to process
    in_buf = audio((i-1)*n:i*n);
    
    % Apply effects to input buffer
    out_buf_eq = bari_eq(in_buf, in_storage, out_eq);
    out_buf_delay = bari_delay(in_buf, in_storage, out_delay, delay_storage);
    out_buf_chorus = bari_chorus(in_buf, [zeros(1:200), in_storage], n, i);
    
    % Store processed output
    out_eq((i-1)*n:i*n) = out_buf_eq;
    out_delay((i-1)*n:i*n) = out_buf_delay;
    out_chorus((i-1)*n:i*n) = out_buf_chorus;
    
end

%% Write output to audio file
audiowrite('Guitar EQ.wav', out_eq, Fs);
audiowrite('Guitar Delay.wav', out_delay, Fs);
audiowrite('Guitar Chorus.wav', out_chorus, Fs);