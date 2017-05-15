function [A] = swapRows(A, i, j)
  for k=1:size(A, 2)
    aux = A(i, k);
    A(i, k) = A(j, k);
    A(j, k) = aux;
  end
end
