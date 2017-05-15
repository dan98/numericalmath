xo = zeros(21,1);
yo = zeros(21,1);
meth1rel = zeros(16,1);
meth2rel = zeros(16,1);
e = zeros(16,1);
xp = xo; yp = yo;
upper1 = e;
upper2 = e;
sol = zeros(9, 1);
sol(1) = 1;


for i=1:21
  xo(i) = (i-1)/20;
  yo(i) = xo(i)^8;
end

Ao = makeVandermondeMatrix(xo, 9);
AAo = Ao' * Ao;
[Qo, Ro] = qr(Ao, 0);
Ap = Ao;

for i=1:16
  if i>1
    e(i) = e(i-1)/10;
  else
    e(1) = 1/10;
  end

  for j=1:21
    xp(j) = (j-1)/20 + 2*(rand()-0.5) * e(i);
    yp(j) = xo(j)^8 + 2*(rand()-0.5) * e(i);
  end

  Ap = makeVandermondeMatrix(xp, 9);

  AAp = Ap' * Ap;
  ccap1 = AAp \ (Ap' * yp);
  [Qp, Rp] = qr(Ap, 0);
  ccap2 = Rp \ (Qp' * yp);
  meth1rel(i) = norm(sol - ccap1);
  meth2rel(i) = norm(sol - ccap2);
  
  At = AAp - AAo;
  bt = Ap'*yp - Ao'*yo;
  cond1(i) = norm(At)*norm(inv(AAo));
  upper1(i) = (cond(AAo)/(1 - cond(AAo)*(norm(At)/norm(AAo))))*(norm(At) / norm(AAo) + norm(bt)/norm(Ao' * yo));

  At = Rp - Ro;
  bt = Qp'*yp - Qo'*yo;
  cond2(i) = norm(At)*norm(inv(Ro));
  upper2(i) = (cond(Ro)/(1 - cond(Ro)*(norm(At)/norm(Ro))))*(norm(At) / norm(Ro) + norm(bt)/norm(Qo' * yo));
end

figure;
loglog(e, meth1rel, 'DisplayName', 'Error in the classic method');
hold on;
loglog(e, upper1, 'DisplayName', 'Upper bound in the classic method');
loglog(e, meth2rel, 'DisplayName', 'Error in the RQ method');
loglog(e, upper2, 'DisplayName', 'Upper bound in the RQ method');
legend('show');
