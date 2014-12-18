%% nmf_mult  Performs NMF using multiplicative update algorithm
%
%   Usage: [W,H] = nmf_mult(Winit,Hinit,A)
%
%   Inputs:
%       Winit : matrix of initial basis vectors (m by k)
%       Hinit : matrix of initial weight vectors (k by n)
%           A : spectrogram; nonnegative data matrix (m by n)
%
%   Outputs: 
%       W : matrix of learned basis vectors (m by k)
%       H : matrix of weight vectors (k by n)
%
function [W,H] = nmf_mult(Winit,Hinit,A)

[m,n] = size(A);
k = size(Winit,2);

% Check dimensions of Winit
if (size(Winit,1) ~= m)
    disp('Error: check dims of Winit');
    return;
end

% Check if A is nonnegative
if ~all(A >= 0)
    disp('Error: A is not nonnegative');
    return;
end

% Initialize W and H
W = Winit;
H = Hinit;

MAXITER = 200;

fprintf('   Running multiplicative updates...\n');
fprintf('   Iteration ');
reverseStr = '';

for i=1:MAXITER
    H = H .* (W'*A) ./ (W'*W*H + 1e-9);
%     W = W .* (A*H') ./ (W*(H*H') + 1e-9);
    
    msg = num2str(i,'%d');
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end

%% Normalize W to sum to 1
sumW = sum(W);
W = W * diag(1./sumW);
H = diag(sumW) * H;

fprintf('\n');