format long
f = @(x) log(x*exp(x));
 c = -3/4;
 x_0 = 3;
 tol = 1e-12;
 maxIt = 25;
 
 [root, flag, convHist_res, convHist_x] = staticIteration_EXAMPLE(f,c, x_0, tol, maxIt);