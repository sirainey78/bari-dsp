%% Read mono audio file (guitar signal)
[audio, Fs] = audioread('Guitar Clean.wav');

%% Write output to audio file
audiowrite('Guitar FX_name.wav', audio, Fs);