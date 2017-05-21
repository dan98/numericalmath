% Attempts to solve A * x = b, with initial guess x0 using 
% an iterative method of the form
%           x^{k+1} = x^{k} + alpha_k P \ r^{k}, r^{k} = b - A x^{k}
% where alpha_k = alpha0 if dynamic = 0
% INPUT
% A         n x n matrix
% b         n x 1 right-hand side
% x0        initial guess
% tol       desired tolerance
% maxIt     maximum number of iterations
% P         preconditioner of A (optional)
% dynamic   0: static, 1: minimise A-norm of error, 2: minimise
%           2-norm of residual
% alpha0    if dynamic = 0, this value is used for alpha_k
% OUTPUT
% x         approximate solution to A * x = b
% flag      if 0 then tolerance is attained
% convHist  relative residual per iteration
function [x, flag, convHist] = iterMethod(A, b, x0, tol, maxIt, P, dynamic, alpha0)
  r = b - A*x0;
  x = x0;
  nb = norm(b);
  nr0 = norm(r);
  nr = nr0;
  convHist = [];

  flag = 1;

  i = 1;
  while(nr > tol*nb)
    if i > maxIt
      flag = 1;
      break;
    end

    if isempty(P)
      z = r;
    else
      z = P\r;
    end

    az = A*z;
    if dynamic == 0
      alpha = alpha0;
    end

    if dynamic == 1
      alpha = (z' * r)/(z' * az);
    end

    if dynamic == 2
      alpha = (az' * r)/(az' * az);
    end

    x = x + alpha*z;
    r = r - alpha*az;
    nr = norm(r);
    convHist=[convHist (nr/nr0)];
    i = i+1;
  end
end
