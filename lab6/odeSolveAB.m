% Performs integration of the system of ODEs given by
%           d/dt u = f(t, u(t)), u(range(1)) = u0
% using an Adams-Bashforth scheme, this gives
% an explicit method of order p
% INPUT
% f         the right-hand side function
% tRange    the time interval of integration
% u0        initial solution at t = tRange(1)
% p         order of accuracy
% h         the step-size
% OUTPUT
% tArray    array containing the time points
% solArray  array containing the solution at each time level
%           (the ith row equals the solution at time tArray(i))
function [tArray, solArray] = odeSolveAB(f, tRange, u0, p, h)

    % Compute Adams-Bashforth coefficients
    b = makeAB(p); b = b(end:-1:1);

    n = size(u0, 1);

    % Number of steps
    nSteps = ceil((tRange(2) - tRange(1)) / h);
    tArray = linspace(tRange(1), tRange(2), nSteps + 1).';
    solArray = zeros(n, nSteps + 1);
    solArray(:, 1) = u0;

    % Compute p - 1 additional initial values by a p-th order Runge-Kutta scheme
    [tArray(1 : p), initSol] = odeSolveRK(f,...
        [tArray(1), tArray(p)], u0, min(p, 5), h);

    solArray(:, 1 : p) = initSol.';

    % Array containing f(t_i, u_i) (could be extracted from RK, but this is easier)
    fArray = zeros(n, nSteps);
    for step = 1 : p - 1
        fArray(:, step) = f(tArray(step), solArray(:, step));
    end

    % Start AB scheme
    for step = p : nSteps
        % New function eval
        fArray(:, step) = f(tArray(step), solArray(:, step));

        % Compute new solution
        solArray(:, step + 1) = solArray(:, step) + fArray(:, step - p + 1 : step) * b * h;
    end
    solArray = solArray.';

end

% This function computes the coefficients of the Adams
% Bashforth formula of order 'order'

% Source:
% A Matrix System for Computing the Coefficients of
% the Adams Bashforth-Moulton Predictor-Corrector
% formulae
% International Journal of Computational and Applied Mathematics.
% ISSN 1819-4966 Volume 6, Number 3 (2011), pp. 215-220
% © Research India Publications
% http://www.ripublication.com/ijcam.htm
function b = makeAB(order)

    A = zeros(order);
    c = ones(order,1);
    for i = 1 : order
        for j = 1 : order
            A(i, j) = (j - 1) ^ (i - 1);
        end
        c(i, 1) = (-1) ^ (i - 1) / i;
    end
    b = A \ c;

end
