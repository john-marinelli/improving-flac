function [xhat, nonResBits, p] = predFixed(x, params)
assert(iscolumn(x), 'predFixed: x must be a column vector');
N = numel(x);

e = x;
bestBits = inf;

for order = 0:min(4, N-1)
    % Repeated differences create the binomial coefficients
    % for each delayed sample
    if order > 0
        e = diff(e);
    end

    bits = scoreResidual(e, order*params.bitsPerRawSample);

    if bits < bestBits
        bestBits = bits;
        p = order;
        eBest = e;
    end
end

xhat = [nan(p,1); x(p+1:end) - eBest];
nonResBits = p * params.bitsPerRawSample;
end
