% Adaptive Simpson formula using error estimation by mesh halving
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
function [int, flag, stats] = simpAdpt(f, a, b, tol, hMin)
    % Allow extra stat computations to be disabled since these are
    % really slow
    getStats = false;
    if nargout == 3
        getStats = true;
        % Maximum amount of refinements
        n = floor(log((b-a) / hMin) / log(2))+1;
        totalErEst = zeros(1, n);
        totalNrIntervals = zeros(1, n);
        nodesList = [b];
    end

    flag = 0;
    int = approxInterval(a, b, f(a), f(b), tol, 1);

    if getStats
        % Struct in which to store the stats
        stats = struct('totalErEst', totalErEst, ...
                       'totalNrIntervals', totalNrIntervals, ...
                       'nodesList', nodesList);
    end

    function int = approxInterval(left, right, leftVal, rightVal, localTol, level)
        h = right - left;
        if h < hMin
            int = 0;
            flag = 1;
            return;
        end

        % Compute the middle of the interval and the value of f at
        % that point
        middle = (right + left) / 2;
        middleVal = f(middle);

        % Compute (error) estimates
        coarseEst = h/6 * (leftVal + 4*middleVal + rightVal);
        fineEst = h/12 * (leftVal + 4*f((left + middle)/2) + middleVal) + ...
                  h/12 * (middleVal + 4*f((middle + right)/2) + rightVal);
        errEst = abs(fineEst - coarseEst) / 15;

        if errEst < localTol
            % Tolerance attained
            int = fineEst;

            if getStats
                % Error and nodes do not change after this for this
                % interval, so store all stats for this interval
                nodesList = [nodesList, left];
                updateStats(errEst, level:n);
            end
        else
            % Need more refinement
            int = approxInterval(left, middle, leftVal, middleVal, localTol / 2, level + 1) + ...
                  approxInterval(middle, right, middleVal, rightVal, localTol / 2, level + 1);

            if getStats
                updateStats(errEst, level);
            end
        end
    end

    function updateStats(errEst, level)
        totalErEst(level) = totalErEst(level) + errEst;
        totalNrIntervals(level) = totalNrIntervals(level) + 1;
    end
end
