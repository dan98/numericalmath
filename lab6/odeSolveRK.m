% Performs integration of the system of ODEs given by
%           d/dt u = f(t, u(t)), u(range(1)) = u0
% using an explicit Runge-Kutta scheme defined by the
% Butcher array B = [c, A; 0, b'].
% INPUT
% f         the right-hand side function
% tRange    the time interval of integration
% u0        initial solution at t = tRange(1)
% B         can be of two types:
%               B = (1, .. , 5), then an explicit RK method of order B is used
%               B is an array defining an extended Butcher array
% h         the step-size
% OUTPUT
% tArray    array containing the time points
% solArray  array containing the solution at each time level
%           (the ith row equals the solution at time tArray(i))
function [tArray, solArray] = odeSolveRK(f, tRange, u0, B, h)

    % Predefined methods (if B is 1x1 then it equals the order)
    if (numel(B) == 1)
        switch B
        case 1
            % Explicit euler
            B = [0 0; 0 1];
        case 2
            % Midpoint
            B = [0 0 0; 1/2 1/2 0; 0 0 1];
        case 3
            % Kutta's third order
            B = [0 0 0 0 ; 1/2 1/2 0 0; 1 -1 2 0; 0 1/6 2/3 1/6];
        case 4
            % Classical RK4
            B = [0 0 0 0 0; 1/2 1/2 0 0 0; 1/2 0 1/2 0 0;...
                            1 0 0 1 0; 0 1/6 1/3 1/3 1/6];
        case 5
            % Fehlberg (5th order RK)
            B = [0 0 0 0 0 0 0; 1/4 1/4 0 0 0 0 0; 3/8 3/32 9/32 0 0 0 0;...
                    12/13 1932/2197 -7200/2197 7296/2197 0 0 0;...
                    1 439/216 -8 3680/513 -845/4104 0 0;...
                    1/2 -8/27 2 -3544/2565 1859/4104 -11/40 0;...
                    0 16/135 0 6656/12825 28561/56430 -9/50 2/55];
        otherwise
            error(['Order should be one of the following: 1, 2, 3, 4 or 5', ...
                'otherwise Butcher array should be given manually.']);
        end
    end

    % Extract info from Butcher array
    s = size(B, 1) - 1;
    A = B(1 : s, 2 : s + 1);
    c = B(1 : s, 1);
    b = B(s + 1, 2 : s + 1)';
    triuA = triu(A, 0);

    % Check if Butcher array defines an implicit method
    if (any(triuA(:)))
        error('No implicit methods supported.')
    end

    % Initialise variables
    n = size(u0, 1);
    K = zeros(n, s);

    % Number of steps
    nSteps = ceil((tRange(2) - tRange(1)) / h);
    tArray = linspace(tRange(1), tRange(2), nSteps + 1)';
    solArray = zeros(n, nSteps + 1);
    solArray(:, 1) = u0;

    % Main loop
    for step = 1 : nSteps

        for i = 1 : s
            K(:, i) = f(tArray(step) + c(i) * h,...
                solArray(:, step) + h * K(:, 1 : i - 1) * A(i, 1 : i - 1)');
        end
        solArray(:, step + 1) = solArray(:, step) + h * K * b;
    end

    solArray = solArray.';
end