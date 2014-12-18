%% nmf_ALS  Performs NMF using multiplicative update algorithm
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

function [W,H] = nmf_ALS(Winit, Hinit, A)

[m,n] = size(A);
k = size(Winit, 2);

W = Winit;
H = Hinit;

MAXITER = 200;

% Check dimensions of Winit
% if (size(Winit,1) ~= m) || (k ~= n)
%     disp('Error: check dims of Winit');
%     return;
% end

% Check if A is nonnegative
if ~all(A >= 0)
    disp('Error: A is not nonnegative');
    return;
end

fprintf('   Running ALS updates...\n');
fprintf('   Iteration ');
reverseStr = '';

for i=1:MAXITER
    H = max(eps,pinv(W'*W)*W'*A);
    for f = 1:k
        for g = 1:n
            if H(f,g) < 0
                H(f,g) = eps;
            end
        end
    end
    
    W = max(eps,(pinv(H*H')*(H*A'))');
    for h = 1:m
        for j = 1:k
            if W(h,j) < 0
                W(h,j) = eps;
            end
        end
    end
    
    msg = num2str(i,'%d');
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end

%% Normalize W to sum to 1
sumW = sum(W);
W = W * diag(1./sumW);
H = diag(sumW) * H;

end

