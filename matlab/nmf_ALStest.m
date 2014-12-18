% load('spectrograms/piano.mat')
%Winit = PIANO_SPECGRAMS;

audioFile = '\\engin-labs.m.storage.umich.edu\wegienka\windat.V2\Documents\MATLAB\EECS 445\Piano.mf.A1.aiff';


[y, FStest] = audioread(audioFile);
y = y(:,1);
player = audioplayer(y, FStest);
play(player);

HOP = NFFT;
[S, F, T] = spectrogram(y, NFFT, NFFT-HOP, NFFT, FS, 'yaxis');
S = abs(S(1:end-1, :));
% spectrogram(y, NFFT, NFFT-HOP, NFFT, FS, 'yaxis');

% Initialize spectral dictionary basis vectors
% A is m x n
% k < min(m, n)
% W is m x k
% H is k x n
A = S;
[m,n] = size(A);
k = 2;

Winit = rand(m,k); %SPECGRAMS;
Hinit = rand(k,n); 

[W,H] = nmf_ALS(Winit, Hinit, S);

% Perform NMF using MATLAB built-in function for comparison
opt = statset('Maxiter',200,'Display','iter');
[Wm,Hm] = nnmf(A,k,'w0',Winit,'h0',Hinit,'alg','als');

% Check error
error = norm(A - W*H)
error_m = norm(A - Wm*Hm)
