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
function [root, flag, iter, convHist] = newton(f, df, x0, tol, maxIt)
  iter = 0;
  flag = 0;

  x = x0;
  err = 0;
  convHist = [];

  while ((err >= tol) || (iter == 0))
    if(iter > maxIt)
      flag = 1;
      break;
    end
    
    delta = -df(x) \ f(x);
    err = norm(delta);

    convHist = [convHist err];

    x = x + delta;
    iter = iter + 1;
  end

  root = x;
end
