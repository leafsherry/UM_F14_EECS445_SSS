% load in notes
insts = {'piano','violin','flute','trumpet'};
NFFT = 2^15;
for j=1:length(insts)
    varname = [upper(insts{j}),'_FFTS'];
    dirname = ['../samples/',insts{j},'/'];
    files = dir(fullfile(dirname, '*.aiff'));
    FFTS = zeros(NFFT/2+1, 2*length(files));
    for i=1:2:2*length(files)
        file = files((i+1)/2).name;
        [x, FS] = audioread(strcat(dirname,file));
        start = find(x>0.002);
        start = start(1);
        x = x(:,1); % mono
        if(length(x) < NFFT+start+NFFT/2)
            x = [x;zeros(NFFT+start+NFFT/2-length(x),1)];
        end
        win = hamming(NFFT, 'periodic');
        win(1:NFFT/2) = 1;
        x0 = x(start:start+NFFT-1).*win;
        x1 = x(start+NFFT/2:start+1.5*NFFT-1).*win;
        S0 = fft(x0, NFFT);
        S0 = abs(S0(1:NFFT/2+1));
        S1 = fft(x1, NFFT);
        S1 = abs(S1(1:NFFT/2+1));
        FFTS(:,i) = S0/sum(S0); % normalize
        FFTS(:,i+1) = S1/sum(S1); % normalize
        %p0 = audioplayer(x0, FS);
        %p1 = audioplayer(x1, FS);
    end
    a.(varname) = FFTS;
    save([insts{j},'.mat'], 'NFFT', 'FS');    
    save([insts{j},'.mat'], '-struct', 'a', varname, '-append');
end

%f = 1e-3*FS/2*linspace(0,1,NFFT/2+1);
%plot(f, 10*log10(abs(S0)));
%xlabel('f (kHz)');
