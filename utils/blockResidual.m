function err = blockResidual(x, xhat, p)
pred = xhat(p+1:end);

err = x(p+1:end) - round(pred);
end