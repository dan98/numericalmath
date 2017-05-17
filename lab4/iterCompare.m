% Compare several iterative methods on input matrix A and rhs b
function [experiments] = iterCompare(A, b)

    % Parameter (0 = static, 1 = dynamic1, 2 = dynamic2)
    % Type of preconditioner: (0 = none, 1 = Jacobi, 2 = Gauss-Seidel)

    experiments = struct('aType', [], 'pType', [], 'alpha0', [], 'precon', [],...
        'x', [], 'flag', [], 'conv', [], 'nrIter', []);

    parameterTypes = {'static', 'dynamic1', 'dynamic2'};
    preconditionerTypes = {'None', 'Jacobi', 'Gauss-Seidel'};

    n = size(A, 1);                 % Variables
    x0 = zeros(n, 1);               % Zero initial guess
    tol = 1E-12;                    % Parameters
    maxIt = 10 * n;

    iterResults = cell2struct({[], [], []}, parameterTypes, 2);

    % Perform experiments
    idx = 1;
    for parameter = 1:numel(parameterTypes)
        for preconditioner = 1:numel(preconditionerTypes)
            experiments(idx).aType = parameter-1;
            experiments(idx).pType = preconditioner-1;
            experiments(idx).alpha0 = 1;

            experiments(idx) = performExperiment(experiments(idx));

            iterResults.(parameterTypes{parameter}) = [...
                iterResults.(parameterTypes{parameter}); experiments(idx).nrIter];

            idx = idx + 1;
        end
    end

    % Display nr of iterations
    disp(struct2table(iterResults, 'RowNames', preconditionerTypes));

    % Plot eigenvalues
    figure(1);
    plotEigvals(A, experiments);

    % Plot convergence
    figure(2);
    plotConvergence(experiments);

    function experiment = performExperiment(experiment)
                                    % Build the preconditioner
        experiment.precon = makePrecon(A, experiment.pType);

        if (experiment.aType == 0)  % Compute alpha0 if needed
            experiment.alpha0 = optimalAlpha(A, experiment.precon, experiment.pType);
        end

        [experiment.x, experiment.flag, experiment.conv] =...
            iterMethod(A, b, x0, tol, maxIt,...
            experiment.precon, experiment.aType, experiment.alpha0);
        experiment.nrIter = length(experiment.conv);
    end
end


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

function plotEigvals(A, experiments)
    myCmap = [0 0 0; 0 0 1; 1 0 0];
    myStyle = {'.', 'o', 'x'};
    eigTitle = {'No precon', 'Jacobi', 'Gauss-Seidel'};
    hold on;
    for i = 1:3
        P = experiments(3 * (i - 1) + 1).precon;
        alpha0 = experiments(3 * (i - 1) + 1).alpha0;

        if (~isempty(P))
            eigVal = eig(full(A), full(P)); 
        else
            eigVal = eig(full(A));
        end
        eigValShift = 1 - alpha0 * eigVal;

        plot(real(eigValShift), imag(eigValShift),...
             'Color', myCmap(i, :), 'Marker', myStyle{i}, 'LineStyle', 'none');
    end
    unitCircle = exp(1i * linspace(0, 2 * pi, 100));
    plot(real(unitCircle), imag(unitCircle), 'k');
    hold off;
    xlabel('Re(lambda)');
    ylabel('Im(lambda)');
    legend([eigTitle, '|lambda| = 1']);
    title('Spectrum of iteration matrix');
end

function plotConvergence(experiments)
    n = size(experiments(1).x, 1);
    myCmap = hsv(4);
    myStyle = {'-x', '-', '-', '-'};
    plotExp = [1 2 6 9];
    for idx = 1:4
        semilogy(experiments(plotExp(idx)).conv, myStyle{idx}, 'Color', myCmap(idx, :));
        hold on;
    end
    hold off;
    xlabel('Iteration');
    ylabel('||r^{(k)}||/||b||');
    legend('No precon, stat', 'Jacobi, stat', 'GS, dyn1', 'GS, dyn2', 'Location', 'NorthEast');
    title(sprintf('Relative residual, problem size: %.0f', n));
end
