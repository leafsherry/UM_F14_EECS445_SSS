% load in notes
insts = {'piano','violin','flute','trumpet','bass'};
NFFT = 2^15;
for j=1:length(insts)
    varname = [upper(insts{j}),'_FFTS'];
    dirname = ['samples/',insts{j},'/'];
    files = dir(fullfile(dirname, '*.aif*'));
    FFTS = zeros(NFFT/2+1, length(files));
    for i=1:length(files)
        file = files(i).name;
        disp(['Processing file ', file]);
        [x, FS] = audioread(strcat(dirname,file));
        start = find(x>0.002);
        start = start(1);
        x = x(start:end,1); % mono, cut silence at start
        if(length(x) < NFFT)
            x = [x;zeros(NFFT,1)];
        end
        s0 = x(1:NFFT);
        S0 = fft(s0, NFFT);
        S0 = abs(S0(1:NFFT/2+1));
        FFTS(:,i) = S0/sum(S0); % normalize
    end
    a.(varname) = FFTS;
    save(['FFTs/',insts{j},'.mat'], 'NFFT', 'FS');    
    save(['FFTs/',insts{j},'.mat'], '-struct', 'a', varname, '-append');
end