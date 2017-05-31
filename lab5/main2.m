format long;

n = 50;
B = buildB(2, n);

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

tic
[rsEx, flagEx, iterEx, convHistEx] = newton (fFunc, dfFuncEx, x0, 10^(-10), 25);
toc

tic
[rsH, flagH, iterH, convHistH] = newton (fFunc, dfFuncH, x0, 10^(-10), 25);
toc

tic
[rsHopt, flagHopt, iterHopt, convHistHopt] = newton (fFunc, dfFuncHopt, x0, 10^(-10), 25);
toc

tic
[rsIter, flagIter, iterIter, convHistIter] = newtonIter (fFunc, x0, 10^(-10), 25);
toc

disp('Exact');
disp(convHistEx);
disp('h = 10^(-8)');
disp(convHistHopt);
disp('h = 1/10');
disp(convHistH);
disp('iter meth');
disp(convHistIter);

figure;
semilogy((1:1:length(convHistEx)), convHistEx, 'DisplayName', 'Exact Jacobian');
hold on;

semilogy((1:1:length(convHistH)), convHistH, 'DisplayName', 'H = 0.1 Jacobian');

semilogy((1:1:length(convHistHopt)), convHistHopt, 'DisplayName', 'Hopt Jacobian');

semilogy((1:1:length(convHistIter)), convHistIter, 'DisplayName', 'Iter Jacobian');

legend('show');
