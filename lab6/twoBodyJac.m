% INPUT
% t         current time (not used)
% solVec    current solution (should be 6x1 array)
% OUTPUT 
% J         Jacobian matrix
function J = twoBodyJac(t, vec)
  v = vec(1:3);
  x = vec(4:6);
  zer = zeros(3, 3);
  B = -4*pi^2*( 1/(norm(x)^3) * eye(3) - 1/(norm(x)^5) * x*x');

  J = [zer B; eye(3) zer];
end
