function [root, flag, convHist_res, convHist_x] = aitkenIteration(f, c, x0, tol, maxIt, depth)
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
        if depth == 0
            x_new = x0 + c * f(x0);
        else
            phi = aitkenIteration(f,c, x0, tol, 1, depth-1);        %return the root
            phiPhi = aitkenIteration(f,c, phi, tol, 1, depth-1);
            x_new = x0 - ((phi - x0)^2) /(phiPhi - 2* phi + x0);
        end
        err = abs(f(x_new));        %take residual error 
        err_x = abs(x0-x_new);
        convHist_res(it) =  err;
        convHist_x(it) = err_x;
        x0 = x_new;
        it = it + 1;
    end
   
    root = x0;
    %convHist_res = convHist_res(1:it);


