% This returns a cell array since we need the blocks
% to have variable size
function blocks = splitBlocks(x, N)
assert(ismatrix(x) && size(x,1) >= 1, 'splitBlocks: x must be samples by channels');

numSamples = size(x, 1);
numBlocks  = ceil(numSamples / N);
blocks     = cell(numBlocks, 1);

for b = 1:numBlocks
    first = (b-1)*N + 1;
    last = min(b*N, numSamples);
    blocks{b} = x(first:last, :);
end
end
