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
  convHist = [];

  err = 1;
  lambda = ((x')*A)*x;

  i = 1;
  convHist(1) = tol + 1;
  while(convHist(i) > tol)
    
    


  end

end
