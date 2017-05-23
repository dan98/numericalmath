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