% INPUT
% f         function of rootfinding problem
% df        function returning the Jacobian matrix
% x0        initial guess
% tol       desired tolerance
% maxIt     maximum number of iterations
% OUTPUT    
% root      if successful, root is an approximation to the
%           root of the nonlinear equation
% flag      flag = 0: tolerance attained, flag = 1: reached maxIt
% iter      the number of iterations
% convHist  convergence history
function [root, flag, iter, convHist] = newtonIter(f, x0, tol, maxIt)
  iter = 0;
  flag = 0;

  x = x0;
  n = size(x0, 1);
  err = 0.000001;
  convHist = [];

  while ((err >= tol) || (iter == 0))
    if(iter > maxIt)
      flag = 1;
      break;
    end
    
    dfIter = @(dir) dirVec(f, x, dir, 10^(-1), 1);

    [delta, fl, ch] = iterMethod(dfIter, f(x), rand(n, 1), 10^(-6), n, 2, 1);

    err = norm(delta);

    convHist = [convHist err];

    x = x - delta;
    iter = iter + 1;
  end

  root = x;
end
