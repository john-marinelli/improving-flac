function totalBits = scoreResidual(e, nonResBits)
    if nargin < 2, nonResBits = 0; end
 
    RICE_OVERHEAD = 2 + log2(log(2)) + 1/log(2);
    MIN_BITS      = 1;
 
    if isempty(e)
        totalBits = nonResBits;
        return
    end
 
    m = mean(abs(e(:)));
    bitsPerSample = max(MIN_BITS, log2(m) + RICE_OVERHEAD);
    totalBits = nonResBits + numel(e) * bitsPerSample;
end
