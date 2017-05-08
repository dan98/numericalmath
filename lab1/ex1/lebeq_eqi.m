function err = lebeq_eqi(n)
    err = 2^(n+1)./ (exp(1) .* n .* (log(n) + 0.547721));
end

