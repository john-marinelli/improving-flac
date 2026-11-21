function [xhat] = predKL(x)

assert(iscolumn(x), 'predLPC: x must be a column vector');

N = numel(x);
blockLen = min(64, N-1);
numBlocks = ceil(N / blockLen);


x = x - mean(x);
px = [x; zeros(numBlocks*blockLen - N, 1)];
B = reshape(px, blockLen, numBlocks);
r  = zeros(blockLen+1, 1);

for k = 0:blockLen
    r(k+1) = x(1:N-k).' * x(1+k:N);
end

if r(1) == 0, return; end
R = toeplitz(r(1:blockLen)) + 1e-9*r(1)*eye(blockLen);

[V, D] = eig(R);
[~, idx] = sort(diag(D), 'descend');
V = V(:, idx);

size(V)
size(B)
Xhat = V.' * B;

xhat = Xhat(:);

end
