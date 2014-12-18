phi = angle(X);
% reconstruct each basis as a separate source
for i=1:K
    XmagHat = W(:,i)*H(i,:);
    % create upper half of frequency before istft
    XmagHat = [XmagHat; conj( XmagHat(end-1:-1:2,:))];
    % Multiply with phase
    XHat = XmagHat.*exp(1i*phi);
    xhat(:,i) = real(invmyspectrogram(XHat,HOPSIZE))';
end