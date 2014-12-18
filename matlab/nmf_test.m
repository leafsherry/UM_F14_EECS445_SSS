[Notes, Labels, NFFT, FS] = load_notes();

%% Piano Only
% [y, ~] = audioread('soundfiles/p_easy.aiff');
% [y, ~] = audioread('soundfiles/p_med.aiff', FS*[20, 35]);
% [y, ~] = audioread('soundfiles/p_hard.aiff');

%% Piano & Violin
% [y, ~] = audioread('soundfiles/Bartok_PV.aiff', FS*[16.5, 36.5]);
% [y, ~] = audioread('soundfiles/piano_violin_15s.mp3');
% [y, ~] = audioread('soundfiles/Chopin_Nocture_PV.aiff', FS*[16.5, 36.5]);
% [y, ~] = audioread('soundfiles/Love_Story_PV.aiff', FS*[16.5, 36.5]);
% [y, ~] = audioread('soundfiles/Rain_Crain_PV.aiff', FS*[35, 50]);
% [y, ~] = audioread('soundfiles/Silent_Night_PV.aiff', FS*[35, 50]);

%% Violin Only
% [y, ~] = audioread('soundfiles/violin_track_sample.aifc', FS*[30, 45]);

%% Flute & Trumpet
% [y, ~] = audioread('soundfiles/Rose_Flute_Trumpet.aiff', FS*[0.5, 12]);

%% Flute Only
% [y, ~] = audioread('soundfiles/flute_solo.mp3', FS*[0.5, 12]);

%% Bass & Piano
% [y, ~] = audioread('soundfiles/bass_piano.aiff', FS*[15 27]);
% [y, ~] = audioread('soundfiles/Jazz_PB.aiff', FS*[15 27]);
%[y, ~] = audioread('soundfiles/Third_Person_PB.aiff', FS*[15 27]);

%% Bass Only
% [y, ~] = audioread('soundfiles/bass_1.aiff', FS*[15 27]);
% [y, ~] = audioread('soundfiles/bass_2.aiff', FS*[15 27]);

%% Trumpet & Piano
 [y, ~] = audioread('soundfiles/trumpet/Christmas_PT.aiff', FS*[16.5, 36.5]);
% [y, ~] = audioread('soundfiles/Moondance_PT.aiff', FS*[30, 50]);

%% Flute & Piano
% [y, ~] = audioread('soundfiles/Csardas_FP.aiff', FS*[20, 35]);

%% Separation 
%------------------------------
y = y(:,1);
HOP = NFFT/4;
[S, ~, ~] = stft(y, NFFT, HOP, NFFT, FS);
[W,H] = nmf_mult(abs(Notes(1:NFFT/2+1,:)), ones(size(Notes,2),size(S,2)), abs(S));
%-----------------------------


%% Reconstruction
%-------------------------------------
O = audioplayer(y, FS);

theta = angle(S);
S_hat = W*H.*exp(1i*theta);

y_hat = istft(S_hat, HOP, NFFT, FS);
R = audioplayer(y_hat, FS);

np=86;
nv=np+90;
nf=nv+39;
nt=nf+36;
nb=nt+208;

PIANO = W(:,1:np)*H(1:np,:);
VIOLIN = W(:,np+1:nv)*H(np+1:nv,:);
FLUTE = W(:,nv+1:nf)*H(nv+1:nf,:);
TRUMPET = W(:,nf+1:nt)*H(nf+1:nt,:);
BASS = W(:,nt+1:nb)*H(nt+1:nb,:);

EP = PIANO./(PIANO+VIOLIN+FLUTE+TRUMPET+BASS).*S;
EV = VIOLIN./(PIANO+VIOLIN+FLUTE+TRUMPET+BASS).*S;
EF = FLUTE./(PIANO+VIOLIN+TRUMPET+BASS).*S;
ET = TRUMPET./(PIANO+VIOLIN+FLUTE+BASS).*S;
EB = BASS./(PIANO+VIOLIN+FLUTE+BASS).*S;

p = istft(EP, HOP, NFFT, FS);
v = istft(EV, HOP, NFFT, FS);
f = istft(EF, HOP, NFFT, FS);
t = istft(ET, HOP, NFFT, FS);
b = istft(EB, HOP, NFFT, FS);
P = audioplayer(p, FS);
V = audioplayer(v, FS);
F = audioplayer(f, FS);
T = audioplayer(t, FS);
B = audioplayer(b, FS);
plot( (1:length(p))/FS, p, 'b'); hold on;
plot( (1:length(p))/FS, v, 'r');
plot( (1:length(p))/FS, f, 'g');
plot( (1:length(p))/FS, t, 'm');
plot( (1:length(p))/FS, b, 'y'); hold off;
legend('Piano', 'Violin', 'Flute', 'Trumpet', 'Bass');
xlabel('Time(s)');
ylabel('Frequency');
title('Track Data');
%---------------------------------------------------

%% Classification
%--------------------------------------------------
addpath('liblinear-1.96/matlab');
softmaxModel = train(Labels, sparse(abs(Notes(1:NFFT/2+1,:)))', '-s 1', '-wi 0.0001');

[ind_max, ~] = find(H/max(max(H))>0.1);
SS = W(:,ind_max);
[pred, ~, ~] = predict(ones(size(SS,2),1), sparse(SS)', softmaxModel);

instruments = {'piano', 'violin', 'flute', 'trumpet', 'bass'};
inst_counts = [ length(find(pred==1)), length(find(pred==2)), ...
                length(find(pred==3)), length(find(pred==4)), ...
                length(find(pred==5)) ]

[maxi, msi] = max(inst_counts);
disp('instruments detected:');

powers = [ sum(sum(PIANO)), sum(sum(VIOLIN)), sum(sum(FLUTE)), ...
           sum(sum(TRUMPET)), sum(sum(BASS)) ];

COUNT_RATIO = 0.05;
POWER_RATIO = 0.66;
% Compare number of each inst classications to largest.
% Also compare PSD of each signal to largest
for i=1:length(inst_counts)
    if( (inst_counts(i)/maxi>COUNT_RATIO) && powers(i)>max(powers)*POWER_RATIO )
        disp(instruments{i});
    end
end
%--------------------------------------------------------------