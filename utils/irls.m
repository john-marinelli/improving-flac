function x = irls(A, b, p, maxIter, tol)
if nargin < 3, p = 1; end
if nargin < 4, maxIter = 50; end
if nargin < 5, tol = 1e-8; end

x = A \ b;
for it = 1:maxIter
    w = max(abs(A*x - b), 1e-8).^(p - 2);
    xNew = (A.' * (w .* A)) \ (A.' * (w .* b));
    if norm(xNew - x) <= tol * norm(x), x = xNew; break; end
    x = xNew;
end
end