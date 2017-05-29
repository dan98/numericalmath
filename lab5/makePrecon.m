function P = makePrecon(A, pType)
    switch pType
        case 0
            P = [];
        case 1          % Jacobi
            P = spdiags(diag(A), 0, size(A, 1), size(A, 2));
        case 2          % Gauss-Seidel
            P = tril(A, 0);
    end
end


