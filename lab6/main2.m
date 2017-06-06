close all;
R = 1;
vec0 = vecExact(0, R);

P = 1;

hJac = @(t, x) twoBodyJac(t, x);
hF = @(t, x) twoBodyF(t, x);

disp(vec0);
h = P;

hx = [];
err = zeros(8, 3);
tim = err;

for i=1:8
  h = h/2;
  hx = [hx h];
  tic;
  [trk, solrk] = odeSolveRK(hF, [0, 5*P], vec0, 5, h);
  rk = toc;
  tim(i, 1) = rk;
  tic;
  [tab, solab] = odeSolveAB(hF, [0, 5*P], vec0, 5, h);
  ab = toc;
  tim(i, 2) = ab;
  tic;
  [tth, solth] = odeSolveTheta(hF, [0, 5*P], vec0, hJac, 1/2, h);
  th = toc;
  tim(i, 3) = th;
  solex = solrk;
  for j=1:length(trk)
    solex(j, :) = vecExact(trk(j), R)';
  end
  err(i, 1) = norm(solrk - solex);
  err(i, 2) = norm(solab - solex);
  err(i, 3) = norm(solth - solex);
  out = err(i, :);
  if i>1
    println([i, h], [out, rk, ab, th]);
  end
end

loglog(hx, err(:, 1), 'DisplayName', 'RK5');
hold on;
loglog(hx, err(:, 2), 'DisplayName', 'AB5');
loglog(hx, err(:, 3), 'DisplayName', 'Theta5');

figure;
plot((1:1:8), tim(:, 1), 'DisplayName', 'Time for RK5');
hold on;
plot((1:1:8), tim(:, 2), 'DisplayName', 'Time for AB5');
plot((1:1:8), tim(:, 3), 'DisplayName', 'Time for Theta');
legend('show');

