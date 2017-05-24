B = [
  2 1 0 0;
  0 2 1 0;
  0 0 2 1;
  0 0 0 2
];

n = 4;

vecB = reshape(B, n*n, 1);

tr = 1;
vecX = rand(n*n, 1);
hopt = 1;
besthval = 1;

disp('Cosistency check!!');
for i=1:15
  jex = matJac(vecX, 'exact', [], B);
  jap = matJac(vecX, 'approx', tr, B);
  err = max(max(abs(jex - jap)));
  if(err < besthval)
    besthval = err;
    hopt = tr;
  end

  println([i, tr], [err]);

  tr = tr/10;
end

hopt


dfFuncEx = @(x) matJac(x, 'exact', [], B);
dfFuncH = @(x) matJac(x, 'approx', 0.1, B);
dfFuncHopt = @(x) matJac(x, 'approx', hopt, B);

fFunc = @(x) matFunc(x, B);
x0 = reshape(eye(n), n*n, 1);

[rsEx, flagEx, iterEx, convHistEx] = newton (fFunc, dfFuncEx, x0, 10^(-10), 25);

[rsH, flagH, iterH, convHistH] = newton (fFunc, dfFuncH, x0, 10^(-10), 25);

[rsHopt, flagHopt, iterHopt, convHistHopt] = newton (fFunc, dfFuncHopt, x0, 10^(-10), 25);

disp(rsEx);
disp(rsH);
disp(rsHopt);

sq = reshape(rsEx, n, n);
disp(sq*sq);

figure;
plot((1:1:length(convHistEx)), convHistEx, 'DisplayName', 'Exact Jacobian');
hold on;

plot((1:1:length(convHistH)), convHistH, 'DisplayName', 'H = 0.1 Jacobian');

plot((1:1:length(convHistHopt)), convHistHopt, 'DisplayName', 'Hopt Jacobian');

legend('show');

