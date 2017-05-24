% INPUT 
% A             n x n matrix 
% x0            n x 1 initial guess
% tol           desired tolerance
% maxIt         maximum number of iterations
% OUTPUT
% lambda        eigenvalue of A largest in magnitude
% x             corresponding eigenvector
% flag          if 0 then tolerance is attained
% lambdaList    list of intermediate eigenvalues
% xList         list of intermediate eigenvectors
% convHist      error estimate per iteration
function [lambda, x, flag, lambdaList, xList, convHist] = powerMethod(A, x0, tol, maxIt)
  x = x0/norm(x0);

  xList = [];
  lambdaList = [];

  flag = 0;
  err = 1;

  lambda1 = ((x')*A)*x;

  l0 = lambda1;
  i = 1;
  convHist = [tol + 1];
  while(convHist(end) > tol)
    if(i > maxIt)
      flag = 1;
      break;
    end
    x = A*x;
    x = x/norm(x);
    xList = [xList x];
    lambda2 = ((x')*A)*x;
    lambdaList = [lambdaList lambda2];
    err = [err abs]
    convHist = [convHist abs((l0 - lambda2)/l0)];
    lambda2 = lambda1;
    i = i+1;
  end

  lambda = lambdaList(end);

end
