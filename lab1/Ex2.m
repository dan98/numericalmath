syms x;
f = 1/(1+x^2);
df = diff(f, 1);
cdf = matlabFunction(df);
cf = matlabFunction(f);

rng(10);

iMax = 10;
errors = zeros(iMax+1, 1);
h0 = 0.01;


n = 1;

for i=1:n
  x = rand;
  [A, B] = diffConsistency(cf, cdf, x, iMax, h0);
  errors = errors + A;
  H = B;
end

errors = errors/n;

loglog(H, errors);
title('LogLog Plot of the mesh size h against the error');
