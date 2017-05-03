% INPUT
% func      function handle
% x         array with distinct and increasing nodes
%           which are the interpolation points
% epsilon   the maximum of the random perturbation
% OUTPUT
% maxError  the maximum error of the perturbed
%           interpolating polynomial
function [maxError] = lagrangeStability(func, x, epsilon)
    % Number of subintervals equals number of nodes minus one
    n = length(x) - 1;

    % Compute function values at the interpolation nodes
    y = func(x);
    % Compute coefficients of interpolating polynomial (read "help polyfit")
    coeff = polyfit(x, y, n);

    % Perturb the data
    rng('default')
    perturbation = rand(size(y)) - 1 / 2;
    % perturbation = (-1).^[1:n+1];

    % Scale the perturbation such that the maximum is given by
    % epsilon
    perturbation = epsilon * perturbation / max(abs(perturbation));
    % Add the perturbation to the data
    yPerturbed = y + perturbation;

    % Coefficients of the perturbed interpolating polynomial
    coeffPerturbed = polyfit(x, yPerturbed, n);
    % Difference of coefficients gives the error polynomial
    coeffError = coeffPerturbed - coeff;

    % Find the maximum error using 16n + 1 points
    maxError = max(abs(polyval(coeffError, linspace(x(1), x(end), 16 * n + 1))));

    % Plot the original function and the interpolating polynomial
    plotNodes = linspace(x(1), x(end), 200);
    % Original func
    plot(plotNodes, func(plotNodes), 'k')
    hold on
    % Interpolating polynomial
    plot(plotNodes, polyval(coeff, plotNodes), 'k--')
    % Perturbed interpolating polynomial
    plot(plotNodes, polyval(coeffPerturbed, plotNodes), 'k:')
    % Show interpolating nodes
    plot(x, zeros(n + 1), 'kx');
    hold off
    xlabel('x')
    ylabel('y')
    legend('Original function', 'Interpolating polynomial',...
           'Perturbed interpolating polynomial', 'Location', 'SouthOutside')
end
