% INPUT
% f         function of rootfinding problem
% c         static parameter: xnew = x + c*f(x)
% x0        initial guess
% tol       desired tolerance
% maxIt     maximum number of iterations
% OUTPUT
% root      root of f
% flag      if 0: attained desired tolerance
%           if 1: reached maxIt nr of iterations
% convHist  convergence history
function [root, flag, convHist_res, convHist_x] = staticIteration(f, c, x0, tol, maxIt)
    it = 1;
    flag = 0;
    err = tol+1;
    convHist_res = zeros(1,maxIt);
    convHist_x = zeros(1,maxIt);
    while err > tol 
        if it > maxIt
            flag = 1;
            break;
        end
        x_new = x0 + c * f(x0);
        err = abs(f(x_new));        %take residual error 
        err_x = abs(x0-x_new);
        convHist_res(it) =  err;
        convHist_x(it) = err_x;
        x0 = x_new;
        it = it + 1;
    end
   
    root = x0;
    
        
        
        