function alpha0 = optimalAlpha(A, P, pType)
    if (pType == 2)         % Gauss-Seidel
        alpha0 = 3 / 2;
    else                    % Jacobi
        if (~isempty(P))    % Preconditioner
            eigVal = eig(full(A), full(P));
        else                % No preconditioner
            eigVal = eig(full(A));
        end
        [~, sorted] = sort(abs(eigVal));
        eigVal = eigVal(sorted);

        alpha0 = 2 / (eigVal(1) + eigVal(end));
    end
end
