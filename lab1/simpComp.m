% Composite trapezoidal formula using error estimating by mesh halving
% INPUT
% f         function handle (the integrand)
% a         beginpoint of the integration interval
% b         endpoint of the integration interval
% tol       desired accuracy
% hMin      smallest permissable interval length
% OUTPUT
% int       approximation to integral of f over the interval [a,b]
% flag      if 1: tol not attained, 0: tol attained
% stats     struct containing data about error estimates per number of intervals
function [int, flag, stats] = simpComp(f, a, b, tol, hMin)
    % Initialise variables
    h = b - a;
    n = 1;
    int = h / 6 * (f(a) + 4*f((a+b)/2)+ f(b));
    flag = 1;

    if nargout == 3
        stats = struct('totalErEst', [], 'totalNrIntervals', [], 'nodesList', []);
    end

    while h > hMin
        h = h / 2;
        n = 2 * n;
        if h < eps % Check if h is not "zero"
            break;
        end

        intNew = 0;
        for j = 2:n
          prev = a + (j-1)*h;
          curr = prev + h;
          intNew = intNew + (h/6)*(f(prev) + 4*f((prev + curr)/2) + f(curr));
        end

        % Estimate the error
        errorEst = 1 / 15 * (int - intNew);
        int = intNew;
        if nargout == 3 % Update stats
            stats.totalErEst = [stats.totalErEst; abs(errorEst)];
            stats.totalNrIntervals = [stats.totalNrIntervals; n / 2];
        end

        if abs(errorEst) < tol
            flag = 0;
            break
        end
    end
end
