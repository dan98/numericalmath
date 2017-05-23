% INPUT
% A         square matrix
% b         right hand side
% OUTPUT
% x         solution such that A*x=b
% L         lower triangular matrix such that A = L*U
% U         upper triangular matrix such that A = L*U
function [x, L, U, P] = luPivot(A, b)
  n = length(b);
  L = zeros(n, n); U = L;
  P = eye(n);

  for k=1:(n-1)
    [x, ind] = max(abs(A(k:n,k)));
    ind = ind + k - 1;
    A = swapRows(A, k, ind);
    P = swapRows(P, k, ind);

    for i=(k+1):n
      A(i,k) = A(i, k)/A(k, k);
      for j=(k+1):n
        A(i,j) = A(i, j) - A(i,k)*A(k,j);
      end
    end
  end

  L = tril(A, -1) + eye(n);
  U = triu(A, 0);


  y = L\(P*b);
  x = U\y;
end
