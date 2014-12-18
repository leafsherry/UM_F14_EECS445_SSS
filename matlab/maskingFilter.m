%% maskingFilter  Applies masking filter to input signal
%
%   Usage: XHat = maskingFilter(X,W,H)
%
%   Inputs:
%       X : input time history signal
%       W : matrix of learned basis vectors (m by k)
%       H : matrix of learned weight vectors ( k by n)
%
%   Outputs: 
%       XHat : mask filtered FFT of input signal X
%
function XHat = maskingFilter(X,W,H)

k = size(W, 2); % The number of basis vectors.
phi = angle(X); % The phase of the input signal.

% Reconstruct each basis as a separate source.
for i=1:k
    XmagHat = W(:,i)*H(i,:);
    
    % create upper half of frequency before istft
    XmagHat = [XmagHat; conj( XmagHat(end-1:-1:2,:))];
    
    % Multiply with phase
    XHat = XmagHat .* exp(1i*phi);
end
