% INPUT
% x         nodal points x_i
% r         polynomial degree

function A = makeVandermondeMatrix(x, r)
  A = zeros(length(x), r);

  % Fill the last column 

  for i=1:length(x)
    A(i, r) = 1;
    for j=1:(r-1)
      A(i, r-j) = A(i, r-j+1) * x(i); 
    end
  end

end
