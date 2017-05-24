A = gallery('poisson', 10);        
x0 = rand(100, 1);
Pjac = spdiags(diag(A), 0, size(A, 1), size(A, 2));
Pgauss = tril(A, 0);

ojac = optimalAlpha(A, P, 1);
ogauss = optimalAlpha(A, P, 2);

Bjac = I + ojac * inv(Pjac) * A;
Bgauss = I + ogauss * inv(Pgauss) * A;

