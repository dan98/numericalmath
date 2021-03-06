% INPUT
% f function handle
% df function handle of the derivative of f
% x point at which to evaluate f and df
% iMax maximum number of refinements
% h0 initial h
% OUTPUT
% diffNorm array containing the errors
% hList array containing values of h
function [ diffNorm , hList ] = diffConsistency (f , df , x , iMax , h0 )
  diffNorm = zeros(iMax+1, 1);
  hList = zeros(iMax+1, 1);

  h=h0;

  for i=1:(iMax + 1)
    if h < eps
      break
    end

    hList(i) = h;

    lhs = (f(x+h) - f(x))/h;
    rhs = df(x);

    diffNorm(i) = abs(lhs - rhs);

    h=h/10;
  end

end
