syms x;
format long e;
f = atan(sqrt(x));
f_hand = matlabFunction(f);
a = 0;
b = 2;
hMin = eps;
tol = 1e-10;
[area, flag, stats] = trapComp(f_hand, a, b, tol,hMin )
actualArea = 3 .* atan(sqrt(2)) - sqrt(2)