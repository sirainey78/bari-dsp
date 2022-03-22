% This function performs the chorus effect

%% Initial setup
[audio, Fs] = audioread('Chorus Example.wav');
audio_size = size(audio, 1);
input = transpose(audio);
output = zeros(1, audio_size);

% Buffer size
n = 64;

%% User parameters
bass = 1;
mid = 1;
treble = 1;

bass_gain = (bass - 5) * 3;
mid_gain = (mid - 5) * 3;
treble_gain = (treble - 5) * 3;

%% Filter definitions
[B_bass, A_bass] = shelving(-15, 200, 48000, sqrt(2), 'Bass_Shelf');
[B_mid, A_mid] = shelving(-15, 1000, 48000, 1.5, 'Mid_Peak');
[B_treble, A_treble] = shelving(-15, 5000, 48000, sqrt(2), 'Treble_Shelf');

[B_b, A_b] = shelving(15, 200, 48000, sqrt(2), 'Bass_Shelf');
[B_m, A_m] = shelving(15, 1000, 48000, 1.5, 'Mid_Peak');
[B_t, A_t] = shelving(15, 5000, 48000, sqrt(2), 'Treble_Shelf');

% For plotting:
w = linspace(0,pi);
h1 = freqz(B_bass, A_bass, w);
h2 = freqz(B_treble, A_treble, w);
h3 = freqz(B_mid, A_mid, w);

h4 = freqz(B_b, A_b, w);
h5 = freqz(B_t, A_t, w);
h6 = freqz(B_m, A_m, w);

subplot(3, 2, 1);
plot(24000*w/pi,20*log10(abs(h1)), '-r')
line([200 200],[-15 15])
line([1000 1000],[-5 5])
line([5000 5000],[-5 5])
xlim([0 20000])
ylim([-25 25])
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('-15dB Low-Shelf (Bass = 1, Mid, Treble = 5)')
grid on

subplot(3, 2, 2);
plot(24000*w/pi,20*log10(abs(h4)), '-r')
line([200 200],[-15 15])
line([1000 1000],[-5 5])
line([5000 5000],[-5 5])
xlim([0 20000])
ylim([-25 25])
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('+15dB Low-Shelf (Bass = 10, Mid, Treble = 5)')
grid on

subplot(3, 2, 3);
plot(24000*w/pi,20*log10(abs(h3)), '-r')
line([200 200],[-5 5])
line([1000 1000],[-15 15])
line([5000 5000],[-5 5])
xlim([0 20000])
ylim([-25 25])
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('-15dB Mid-Peak (Mid = 1, Bass, Treble = 5)')
grid on

subplot(3, 2, 4);
plot(24000*w/pi,20*log10(abs(h6)), '-r')
line([200 200],[-5 5])
line([1000 1000],[-15 15])
line([5000 5000],[-5 5])
xlim([0 20000])
ylim([-25 25])
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('+15dB Mid-Peak (Mid = 10, Bass, Treble = 5)')
grid on

subplot(3, 2, 5);
plot(24000*w/pi,20*log10(abs(h2)), '-r')
line([200 200],[-5 5])
line([1000 1000],[-5 5])
line([5000 5000],[-15 15])
xlim([0 20000])
ylim([-25 25])
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('-15dB High-Shelf (Treble = 1, Bass, Mid = 5)')
grid on

subplot(3, 2, 6);
plot(24000*w/pi,20*log10(abs(h5)), '-r')
line([200 200],[-5 5])
line([1000 1000],[-5 5])
line([5000 5000],[-15 15])
xlim([0 20000])
ylim([-25 25])
xlabel('Frequency (Hz)')
ylabel('Gain (dB)')
title('+15dB High-Shelf (Treble = 10, Bass, Mid = 5)')
grid on

%% Apply filters
% output = filter(B_bass, A_bass, input);
% output = filter(B_mid, A_mid, output);
% output = filter(B_treble, A_treble, output);

% output1 = filter(B_bass, A_bass, input);
% output2 = filter(B_mid, A_mid, input);
% output3 = filter(B_treble, A_treble, input);
% output = output1 + output2 + output3;

in_buf = zeros(1, n);
out_buf = zeros(1, n);
out_buf_b = zeros(1, 3);
out_buf_m = zeros(1, 3);
out_buf_t = zeros(1, 3);

for num_buffer = 2:floor(audio_size / n) 
    
    %Set input buffer from input
    start_index = (num_buffer - 1) * n + 1;
    end_index = start_index + n - 1;
    in_buf = input(start_index:end_index);
    
    for i = 1:n
        out_buf_b(1) = out_buf_b(2);
        out_buf_b(2) = out_buf_b(3);
        out_buf_m(1) = out_buf_m(2);
        out_buf_m(2) = out_buf_m(3);
        out_buf_t(1) = out_buf_t(2);
        out_buf_t(2) = out_buf_t(3);

        out_buf_b(3) = -1 * A_bass(2) * out_buf_b(2) - A_bass(3) * out_buf_b(1);
        out_buf_b(3) = out_buf_b(3) + B_bass(1) * input(i + start_index) + B_bass(2) * input(i + start_index - 1) + B_bass(3) * input(i + start_index - 2);
        out_buf_b(3) = out_buf_b(3) / A_bass(1);
        
        out_buf_m(3) = -1 * A_mid(2) * out_buf_m(2) - A_mid(3) * out_buf_m(1);
        out_buf_m(3) = out_buf_m(3) + B_mid(1) * out_buf_b(3) + B_mid(2) * out_buf_b(2) + B_mid(3) * out_buf_b(1);
        out_buf_m(3) = out_buf_m(3) / A_mid(1);
        
        out_buf_t(3) = -1 * A_treble(2) * out_buf_t(2) - A_treble(3) * out_buf_t(1);
        out_buf_t(3) = out_buf_t(3) + B_treble(1) * out_buf_m(3) + B_treble(2) * out_buf_m(2) + B_treble(3) * out_buf_m(1);  
        out_buf_t(3) = out_buf_t(3) / A_treble(1);
        
        out_buf(i) = out_buf_t(3);
    end
    
    %Write output buffer to output
    out_buf_start_index = n * (num_buffer - 1) + 1;
    out_buf_end_index = out_buf_start_index + n - 1;
    output(out_buf_start_index:out_buf_end_index) = out_buf(1:n);
    
end

%% Output file writing
audiowrite('Guitar EQ.wav', 1.0 * output, Fs);
