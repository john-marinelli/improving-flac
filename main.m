root = fileparts(mfilename('fullpath'));

addpath(fullfile(root, 'utils'), ...
    fullfile(root, 'predictors'), ...
    fullfile(root, 'metrics'), ...
    fullfile(root, 'data'));

file = 'test.wav';
N = 4096;

[x, fs, bps] = loadAudio(fullfile(root, 'data', 'testSine.wav'));
x = x(:, 1);
params.bitsPerRawSample = bps;

blocks = splitBlocks(x(:,1), N);

fixedErrs = zeros(numel(blocks), 1);
lpcErrs = zeros(numel(blocks), 1);

for b = 1:numel(blocks)
    blk = blocks{b};
    [xhatF, ~, pF] = predFixed(blk, params);
    [xhatL, ~, pL] = predLPC(blk, params);
    eF = blk(pF+1:end) - round(xhatF(pF+1:end));
    fixedErrs(b) = mean(abs(eF));
    eL = blk(pL+1:end) - round(xhatL(pL+1:end));
    lpcErrs(b) = mean(abs(eL));
    
end

t = 1:numel(blocks);

plot(t, fixedErrs, t, lpcErrs);
legend('fixed', 'LPC');
xlabel('block');
ylabel('error');
