[Notes, Labels, NFFT, FS] = load_notes();
% [y, ~] = audioread('soundfiles/p_easy.aiff');
% [y, ~] = audioread('soundfiles/Bartok.aiff', [1+FS*16.5, 1+FS*30]);
% [y, ~] = audioread('soundfiles/Rose_Flute_Trumpet.aiff', [1+FS*0.5, 1+FS*12]);
% [y, ~] = audioread('soundfiles/test_two_instruments.aif');
[y, ~] = audioread('soundfiles/pB4vF5.wav');
y = y(:,1);

% plot( (1:length(y))/FS, y);
% O = audioplayer(y, FS);
% play(O);

% NMF
HOP = NFFT/4;
[S, ~, ~] = stft(y, NFFT, HOP, NFFT, FS);
%spectrogram(y, NFFT, NFFT-HOP, NFFT, FS, 'yaxis');
% [W,H] = nmf_mult(abs(Notes(1:NFFT/2+1,:)), ones(size(Notes,2),size(S,2)), abs(S));
[W,H] = nmf_ALS(abs(Notes(1:NFFT/2+1,:)), ones(size(Notes,2),size(S,2)), abs(S));
%  addpath('nmfv1_4');
% [W,H,~,~,~] = sparsenmfnnls(abs(S), abs(Notes(1:NFFT/2+1,:)));
% save('WH.mat', 'W', 'H', 'S', 'HOP', 'FS', 'NFFT', 'Labels', 'Notes', 'y');