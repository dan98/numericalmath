% LU factorisation and partial pivoting


e = 1;
y = [1; 2];

err = zeros(16, 1);
conda = err;
condl = err;
condu = err;
focterr = err;
ee = err;
 

for i=1:16
  e = e/10;
  ee(i) = e;


  disp(e)
  x = [e; 1];
  A = makeVandermondeMatrix(x, 2);

  c = 1/(e - 1) * [1 -1; -1 e] * y;

  [ccap, L, U] = luNaive(A, y);

  err(i) = norm(ccap - c) / norm(c); 
  conda(i) = cond(A);
  condl(i) = cond(L);
  condu(i) = cond(U);
  facterr(i) = norm(A - L*U, 'fro');
  eig(A)
end


figure;
title('A = L*U (Naive)')
loglog(ee, err, 'DisplayName', 'err');
hold on;
loglog(ee, conda, 'DisplayName', 'conda');
loglog(ee, condl, 'DisplayName', 'condl');
loglog(ee, condu, 'DisplayName', 'condu');
loglog(ee, facterr, '--', 'LineWidth', 10, 'DisplayName', 'facterr');
legend('show');

err = zeros(16, 1);
conda = err;
condl = err;
condu = err;
focterr = err;
ee = err;
e = 1;
 

for i=1:16
  e = e/10;
  ee(i) = e;


  disp(e)
  x = [e; 1];
  A = makeVandermondeMatrix(x, 2);

  c = 1/(e - 1) * [1 -1; -1 e] * y;

  [ccap, L, U, P] = luPivot(A, y);

  err(i) = norm(ccap - c) / norm(c); 
  conda(i) = cond(A);
  condl(i) = cond(L);
  condu(i) = cond(U);
  facterr(i) = norm(A - inv(P)*L*U, 'fro');
  eig(A)
end


figure;
title('A = L*U (Pivot)')
loglog(ee, err, 'DisplayName', 'err');
hold on;
loglog(ee, conda, 'DisplayName', 'conda');
loglog(ee, condl, 'DisplayName', 'condl');
loglog(ee, condu, 'DisplayName', 'condu');
loglog(ee, facterr, '--', 'LineWidth', 10, 'DisplayName', 'facterr');
legend('show');

