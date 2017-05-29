function B = buildB(lambda, n)
  B = zeros(n, n);
  for i=1:n
    B(i,i) = lambda;
    if(i ~= n)
      B(i, i+1) = 1;
  end
end
