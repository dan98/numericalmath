% Given a rootfinding problem
%   F(X) := X^2 - B, F(X) = 0
% for a square matrix B, this function returns the Jacobian matrix
% of vec(F) w.r.t. vec(X).
%
% INPUT
% vecX      vector (n^2 x 1) representing a matrix X of size
%           n x n
% jacType   either 'exact' or 'approx'
% h         if approximate, then h is used as accuracy
% B         matrix defining the rootfinding problem
% OUTPUT
% J         Jacobian matrix (n^2 x n^2)
function J = matJac(vecX, jacType, h, B)

    n = sqrt(length(vecX));

    if strcmp(jacType, 'exact')
        x = reshape(vecX, n, n);
        J = kron(eye(n), x) + kron(x.', eye(n));
    else
        % Initialise the Jacobian matrix
        J = zeros(n ^ 2);
        dirVec = zeros(n ^ 2, 1);
        for j = 1 : n ^ 2
            % Compute approxmation (first-order)
            J(:, j) = (matFunc(vecX + h * fillRow(dirVec, j), B) -...
                matFunc(vecX, B)) / h;
        end
    end

    function v = fillRow(v, row)
        v(row) = 1;
    end
end
