function [xhat, p] = predIRLS(x)

assert(iscolumn(x), 'predIRLS: x must be a column vector');

N = numel(x);
maxOrder = min(32, N-1);

% cosine backoff at edges, not sure why exactly this is
% necessary but the spec includes it
w  = 0.5 - 0.5*cos(2*pi*(0:N-1).'/(N-1));
xw = x .* w;
p = 0;
xhat = zeros(N, 1);
bestErr = mean(abs(x));

if ~any(xw), return; end

A = zeros(N+maxOrder, maxOrder);
for i = 1:maxOrder
    A(i+1:i+N, i) = xw;
end
b = [xw; zeros(maxOrder, 1)];


% build a toeplitz matrix of the auto correlation values
% up to the max order (32 when it's a full block)
% a small amount is added along the diagonal to prevent
% R from being singular when we have a perfectly predictable
% signal
for order = 1:maxOrder
    % Feed in the A with delayed signals and b (regular signal)
    a = irls(A(1:N+order, 1:order), b(1:N+order), 1);

    % build filter kernel of [0, a_1, ..., a_order]
    % and convolve it with x performing e[n] = sum(a[i]*x[n-i])
    pred = filter([0; a], 1, x);
    % compare only the non-warm-up samples
    e = x(order+1:end) - round(pred(order+1:end));
    err = mean(abs(e));

    if err < bestErr
        bestErr = err;
        p = order;
        xhat = [nan(order,1); pred(order+1:end)];
    end
end
end
