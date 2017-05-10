% INPUT
% f         function handle
% df        function handle of the derivative of f
% x         point at which to evaluate f and df
% iMax      maximum number of refinements
% h0        initial h
% OUTPUT
% diffNorm  array containing the errors
% hList     array containing values of h
function [diffNorm, hList] = diffConsistency(f, df, x, iMax, h0)
    f_x = f(x);
    df_x = df(x);
    diffNorm = zeros(1, iMax);
    hList = zeros(1, iMax);
    hCurrent = h0;
    for i=1:iMax
        f_ap = f(x+hCurrent);
        df_app = (f_ap - f_x)./hCurrent;
        hList(i) = hCurrent;
        diffNorm(i) = df_app - df_x;
        hCurrent = hCurrent ./ 10.0;
        if (hCurrent < eps)
            i
            break;
        end
    end
    hList = hList(1, 1:i)
    diffNorm = diffNorm(1, 1:i)
    loglog(hList,diffNorm );
    ylabel('Absolute error')
    xlabel('Interval')
        
        
    