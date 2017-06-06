% INPUT
% t         current time (not used)
% solVec    current solution (should be 6x1 array)
% OUTPUT 
% dSolVec   right-hand side
function rs = twoBodyF(t, vec)
  v = vec(1:3);
  x = vec(4:6);
  f1 = - 4*pi^2 * (x) / (norm(x)^3);
  f2 = v;
  rs = [f1; f2];
end
