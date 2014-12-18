function [INST_FFTS, INST_LABELS, NFFT, FS] = load_notes()

load('piano.mat');
load('violin.mat');
load('flute.mat');
load('trumpet.mat');
load('bass.mat');

p = size(PIANO_FFTS, 2);
v = size(VIOLIN_FFTS, 2);
f = size(FLUTE_FFTS, 2);
t = size(TRUMPET_FFTS, 2);
b = size(BASS_FFTS, 2);

INST_FFTS = [PIANO_FFTS, VIOLIN_FFTS, FLUTE_FFTS, TRUMPET_FFTS, BASS_FFTS];
INST_LABELS = [ones(p,1); 2*ones(v,1); 3*ones(f,1); 4*ones(t,1); 5*ones(b,1)];
end