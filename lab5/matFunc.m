% INPUT 
% vecX      vector (n^2 x 1) representing a matrix X of size
%           n x n
% B         matrix B of size n x n
% OUTPUT 
% vecF      vector (n^2 x 1) representing the matrix 
%           F = X^2 - B
function vecF = matFunc(vecX, B)
  n = sqrt(length(vecX));
  X = reshape(vecX, n, n);
  vecF = reshape(X^2 - B, n*n, 1);
end
