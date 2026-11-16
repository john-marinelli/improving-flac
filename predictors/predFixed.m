function [xhat, p] = predFixed(x)
assert(iscolumn(x), 'predFixed: x must be a column vector');
N = numel(x);

e = x;
bestErr = inf;

for order = 0:min(4, N-1)
    % Repeated differences create the binomial coefficients
    % for each delayed sample
    if order > 0
        e = diff(e);
    end

    err = mean(abs(e));

    if err < bestErr
        bestErr = err;
        p = order;
        eBest = e;
    end
end

xhat = [nan(p,1); x(p+1:end) - eBest];
end
