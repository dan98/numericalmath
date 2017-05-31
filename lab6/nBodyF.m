% INPUT
% t         current time level
% solVec    current solution vector (size 6 * N x 1)
% N         number of bodies
% mass      array with mass of each body (N x 1)
% OUTPUT
% du        right-hand side of the N-body system
function du = nBodyF(t, solVec, N, mass)

    % Reshape such that each column represents one body
    solVec = reshape(solVec, 6, N);
    R = repmat(solVec(4 : 6, :), 1, 1, N);

    % radii(:, i, j) equals r(i) - r(j)
    radii = R - permute(R, [1 ,3, 2]);
    dist = sum(radii .^ 2, 1) .^ (3 / 2);
    dist = repmat(dist, 3, 1, 1);

    massM = repmat(mass', 3, 1, N);
    zeroIdx = (dist ~= 0);

    F = zeros(3, N, N);
    F(zeroIdx) = massM(zeroIdx) .* radii(zeroIdx) ./ dist(zeroIdx);

    DU = solVec;
    DU(1 : 3, :) = (4 * pi ^ 2) * reshape(sum(F, 2), 3, N);
    DU(4 : 6, :) = solVec(1 : 3, :);
    du = reshape(DU, 6 * N, 1);

end
