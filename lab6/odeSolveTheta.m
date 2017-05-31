% Performs integration of the system of ODEs given by
%           d/dt u = f(t, u(t)), u(tRange(1)) = u0
% using the theta-method
% INPUT
% f         the right-hand side function, the output should be a
%           N x 1 array where N is the number of unknowns
% tRange    the time interval of integration
% u0        initial solution at t = tRange(1) (N x 1 array)
% df        a function that evaluates the jacobian of f
% theta     defines the method
% h         the step-size
% OUTPUT
% tArray    array containing the time points
% solArray  array containing the solution at each time level
%           (the ith row equals the solution at time tArray(i))
function [x, u] = odeSolveTheta(f, tRange, u0, df, theta, h)
  x = (tRange(1):h:tRange(2));
  sz = length(u0);
  u = zeros(sz, length(x));
  u(:, 1) = u0;
  n = length(x);

  for i=2:n
    if theta == 0
      % Explicit
      u(:, i) = u(:, i-1) + h*f(x(i-1), u(:, i-1));
    else
      % Implicit
      newtonf = @(xx) (u(:, i-1) + h*(theta*f(x(i), xx) + (1-theta)*f(x(i-1), u(:, i-1))) - xx);
      newtondf = @(xx) (h*theta*df(x(i), xx) - eye(sz));
      u(:, i) = newton(newtonf, newtondf, u(:, i-1), 10^(-6), 1000);
    end
  end

end
