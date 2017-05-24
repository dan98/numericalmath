syms x;
f = atan(sqrt(x));
df = diff(f, 1);
d2f = diff(df, 1);
d3f = diff(d2f, 1);
cf = matlabFunction(f);
cdf = matlabFunction(df);


n = 8;
% TrapComp
tol = 1;
nrint = zeros(4, 12, 2);

eps = 10^(-10);

for i=1:n
  disp(sprintf('Computing for tol = %.e', tol));

  tol=tol/10;
  [int, flag, stats] = trapComp(cf, 0, 2, tol, eps);
  nrint(1,i,1) = stats.totalNrIntervals(end);
  nrint(1,i,2) = stats.totalErEst(end);

  [int, flag, stats] = trapAdpt(cf, 0, 2, tol, eps);
  nrint(2,i,1) = stats.totalNrIntervals(end);
  nrint(2,i,2) = stats.totalErEst(end);

  [int, flag, stats] = simpComp(cf, 0, 2, tol, eps);
  nrint(3,i,1) = stats.totalNrIntervals(end);
  nrint(3,i,2) = stats.totalErEst(end);

  [int, flag, stats] = simpAdpt(cf, 0, 2, tol, eps);
  nrint(4,i,1) = stats.totalNrIntervals(end);
  nrint(4,i,2) = stats.totalErEst(end);
  if i==n
    scatter(stats.nodesList, zeros(length(stats.nodesList), 1));
  end
end

figure;
title('LogLog plot of the number of intervals against the tol');
loglog(nrint(1,:,2), nrint(1,:,1));

disp('trapComp, trapAdpt, simpComp, simpAdpt');

for i=1:n
  println([nrint(1,i,1), nrint(2,i,1), nrint(3,i,1), nrint(4,i,1)], []);
end

for i=1:n
  if(i>1)
    println([nrint(1,i,2), nrint(2,i,2), nrint(3,i,2), nrint(4,i,2)], [nrint(1,i-1,2)/nrint(1,i,2), nrint(3,i-1,2)/nrint(3,i,2)]);
  else
    println([nrint(1,i,2), nrint(2,i,2), nrint(3,i,2), nrint(4,i,2)], []);
  end
end


