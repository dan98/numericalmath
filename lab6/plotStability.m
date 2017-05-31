% INPUT
% eigenValues   list of eigenvalues (scaled by dt)
% solverName    names of solvers (cell array)
% solverParam   corresponding parameter (order)
function [] = plotStability(eigenValues, solverName, solverParam)
% source: http://www.mathworks.com/examples/matlab/3291-stability-regions-of-ode-formulas

% input example: plotStability(-0.75, {'AB', 'AB', 'RK', 'Theta'}, [1 2 4 1])
% for studying AB(1), AB(2) ,RK(4) and Theta(1)

if nargin < 2
    solverName = [repmat({'RK'}, 4, 1); repmat({'AB'}, 4, 1); {'Theta'}];
    solverParam = [1:4, 1:4, 1];
end

if nargin < 1
    eigenValues = [];
end

nrSolvers = length(solverParam);
myLegend = {};
C = 'Color'; c = {'b','r','g','m','y','c'};
myCmap = jet(nrSolvers);
x = [0 0]; y = [-8 8]; K = 'k'; LW = 'linewidth'; FS = 'fontsize';
LS = 'linestyle';

t = linspace(0, 2*pi, 5E2); 
z = exp(1i*t); r = z-1;

figure
hold on
h = [];
% main loop
for solver = 1:nrSolvers
    plotTest = true;
    switch solverName{solver}
        case 'RK'
            w = z-1;
            if solverParam(solver) > 1
                for i = 1:3
                  w = w-(1+w+.5*w.^2-z.^2)./(1+w);
                end
            end

            if solverParam(solver) > 2 
                for i = 1:4
                  w = w-(1+w+.5*w.^2+w.^3/6-z.^3)./(1+w+w.^2/2);
                end
            end
            if solverParam(solver) > 3 
                for i = 1:4
                  w = w-(1+w+.5*w.^2+w.^3/6+w.^4/24-z.^4)...
                      ./(1+w+w.^2/2+w.^3/6);
                end         
            end
            if solverParam(solver) > 4
                plotTest = false;
            end
            L = '-';
        case 'AB' 
            
            b = makeAB(solverParam(solver));
            s = sum(bsxfun(@times, b, 1./bsxfun(@power, z, [0:solverParam(solver) - 1]')), 1);

            w = r./s;
            L = '-';
        case 'Theta'
            if solverParam(solver) == 0
                w = z - 1;
                L = '-';
            elseif solverParam(solver) == 1/2
                % crank nicolson
                plotTest = false;
            elseif solverParam(solver) == 1
                % backward euler
                w = z + 1;
                L = '--';
            end
                    
                    
        otherwise
            plotTest = false;
    end % end main switch

    if plotTest
        h = [h, plot(w,C,myCmap(solver, :),LW,2,LS,L)];
        if strcmp(solverName{solver}, 'Theta')
            legendEntry = sprintf([solverName{solver},'(%s)'], strtrim(rats(solverParam(solver))));
        else 
            legendEntry = sprintf([solverName{solver},'%.0f'], solverParam(solver));
        end
        myLegend = [myLegend, legendEntry];
    end
end


% plot the eigenvalues
plot(real(eigenValues), imag(eigenValues), 'kx', 'markersize',...
    8,  LW, 2)

xlabel('Re($\lambda$ dt)', 'Interpreter', 'LaTeX')
ylabel('Im($\lambda$ dt)', 'Interpreter', 'LaTeX')
rangeList = axis;
plot([0 0],rangeList([3 4]),K,LW,1)
plot(rangeList([1 2]),[0 0],K,LW,1)

grid on
legend(h, myLegend, 'Location', 'EastOutside')
% title('Dashed <=> exterior & Solid <=> interior')
hold off



end


% This function computes the coefficients of the Adams
% Bashforth formula of order 'order'

% Source:
% A Matrix System for Computing the Coefficients of
% the Adams Bashforth-Moulton Predictor-Corrector
% formulae
% International Journal of Computational and Applied Mathematics.
% ISSN 1819-4966 Volume 6, Number 3 (2011), pp. 215-220
% © Research India Publications
% http://www.ripublication.com/ijcam.htm
function b = makeAB(order)

    A = zeros(order);
    c = ones(order,1);
    for i = 1 : order
        for j = 1 : order
            A(i, j) = (j - 1) ^ (i - 1);
        end
        c(i, 1) = (-1) ^ (i - 1) / i;
    end
    b = A \ c;

end
