function err = lebeq_ch(n)
    err = 2/pi * (log(n) + 0.547721 + log(8/pi)) + pi/ (72 * n^2);
end
