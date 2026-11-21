root = fileparts(mfilename('fullpath'));

addpath(fullfile(root, 'utils'), ...
    fullfile(root, 'predictors'), ...
    fullfile(root, 'metrics'), ...
    fullfile(root, 'data'));

file = 'test.wav';
N = 4096;

[x, fs] = loadAudio(fullfile(root, 'data', 'testSine.wav'));
x = x(:, 1);

blocks = splitBlocks(x(:,1), N);

fixedErrs = zeros(numel(blocks), 1);
lpcErrs = zeros(numel(blocks), 1);
klErrs = zeros(numel(blocks), 1);
irlsErrs = zeros(numel(blocks), 1);

for b = 1:numel(blocks)
    blk = blocks{b};
    [xhatF, pF] = predFixed(blk);
    [xhatL, pL] = predLPC(blk);
    xhatK = predKL(blk);
    [xhatI, pI] = predIRLS(blk);
    eF = blk(pF+1:end) - round(xhatF(pF+1:end));
    fixedErrs(b) = mean(abs(eF));
    eL = blk(pL+1:end) - round(xhatL(pL+1:end));
    lpcErrs(b) = mean(abs(eL));
    klErrs(b) = mean(abs(xhatK));
    eI = blk(pI+1:end) - round(xhatI(pI+1:end))
    irlsErrs(b) = mean(abs(eI));
end

t = 1:numel(blocks);

plot(t, fixedErrs, t, lpcErrs, t, klErrs, t, irlsErrs);
legend('fixed', 'LPC', 'KL', 'IRLS');
xlabel('block');
ylabel('mean absolute error');
