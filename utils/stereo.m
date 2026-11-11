% splits into left, right, mid and side
function [ch, chBps] = stereo(block, bitsPerRawSample)

C = size(block, 2);

if C ~= 2
    ch = block;
    chBps = bitsPerRawSample * ones(1, C);
    return
end

L = block(:, 1);
R = block(:, 2);
M = floor((L + R) / 2);
S = L - R;

ch    = [L, R, M, S];
% Side could double in value so it needs another bit
chBps = [
    bitsPerRawSample, ... 
    bitsPerRawSample, ...
    bitsPerRawSample, ...
    bitsPerRawSample + 1
];

end
