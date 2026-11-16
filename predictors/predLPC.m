function [xhat, p] = predLPC(x)

assert(iscolumn(x), 'predLPC: x must be a column vector');

N = numel(x);
maxOrder = min(32, N-1);

% cosine backoff at edges, not sure why exactly this is
% necessary but the spec includes it
w  = 0.5 - 0.5*cos(2*pi*(0:N-1).'/(N-1));
xw = x .* w;
r  = zeros(maxOrder+1, 1);
% autocorrelation, builds a vector of
% inner products of x with x delayed by k
% samples
for k = 0:maxOrder
    r(k+1) = xw(1:N-k).' * xw(1+k:N);
end

p = 0;
xhat = zeros(N, 1);
bestErr = mean(abs(x));
% if we have an autocorrelation of 0 for x with itself,
% we have all zeros, or a squared norm of 0
if r(1) == 0, return; end

% build a toeplitz matrix of the auto correlation values
% up to the max order (32 when it's a full block)
% a small amount is added along the diagonal to prevent
% R from being singular when we have a perfectly predictable
% signal
R = toeplitz(r(1:maxOrder)) + 1e-9*r(1)*eye(maxOrder);
for order = 1:maxOrder
    % This is a Gram matrix, solving for the the coefficients
    % for each of the basis vectors (built by delaying x up to the order)
    % The autocorrelation vector r here is the inner product of
    % the original signal x with all of its delayed versions.
    % That's why we're grabbing r(2:order+1), because we
    % don't want the inner product of x with itself involved
    % in the projection. Sorry that was long winded
    a = R(1:order, 1:order) \ r(2:order+1);
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
