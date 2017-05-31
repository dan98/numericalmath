% INPUT
% tArray        (n + 1) x 1 array
% solArray      (n + 1) x (6 * nrBodies) array, containing the positions and
%                   velocities of nrBodies bodies at n + 1 instances in time
% bodyData      return value of loadNBodyData (struct containing info / textures)
function simulateSolarSystem(tArray, solArray, bodyData)
    N = size(solArray, 2) / 6;

    spaceColor = [1 1 1] * 0.05;
    gridColor = [1 1 1] * 0.2;


    % Plot settings
    figure;
    view(40, 30);
    axis equal;
    set(gca, 'Color', spaceColor,...
            'XColor', gridColor, 'YColor', gridColor, 'ZColor', gridColor);

    grid on;
    labelProps = {
        'FontSize'; 7
        'EdgeColor'; [0 0 0]
        'BackgroundColor'; 0.7 * [1 1 1]
        'Margin'; 1
        };
    myCmap = jet(N);

  
    % Initialise the trajectories
    hold on;
    for body = 1 : N
        plotHandles.trajectory(body) = plot3(solArray(1, (body - 1) * 6 + 4),...
            solArray(1, (body - 1) * 6 + 5),...
            solArray(1, (body - 1) * 6 + 6),...
            'Color', myCmap(body, :));
    end 
    hold off;
    plotHandles.axis1 = get(plotHandles.trajectory(body), 'parent');

    % Draw labels
    for body = 1 : N
        plotHandles.label(body) = text(...
            solArray(1, (body - 1) * 6 + 4),...
            solArray(1, (body - 1) * 6 + 5),...
            solArray(1, (body - 1) * 6 + 6),...
            bodyData(body).name, labelProps{:});
    end

    hold on;
    for body = [1 4 5]
        currentPos = [...
            solArray(1, (body - 1) * 6 + 4),...
            solArray(1, (body - 1) * 6 + 5),...
            solArray(1, (body - 1) * 6 + 6)];
        plotHandles.spheres(body) = plotSphere(currentPos, bodyData(body).radius);
        set(plotHandles.spheres(body), 'FaceColor', 'texturemap', 'CData', bodyData(body).texture);
        bodyData(body).lastPos = currentPos; % Store last used center
    end
    % light(bodyData(1).pos, 'style', 'local');
    
    hold off;

    plotHandles.axis2 = get(plotHandles.spheres(body), 'parent');

    nrSteps = 500;
    nrSol = size(solArray, 1);
    stepSize = ceil(nrSol / nrSteps);

    % Extend the trajectory
    for time = 1 + stepSize : stepSize : nrSol
        timeRange = [time - stepSize : time];

        plotNBody(tArray(timeRange), solArray(timeRange, :),...
            bodyData, plotHandles);

        bodyData = plotEarthMoon(tArray(timeRange), solArray(timeRange, :),...
            bodyData, plotHandles);

        drawnow limitrate;
    end

end

function plotNBody(time, velPos, bodyData, plotHandles)
    N = length(bodyData);   % Nr of bodies

    pos = {velPos(:, (0 : N - 1) * 6 + 4);
           velPos(:, (0 : N - 1) * 6 + 5);
           velPos(:, (0 : N - 1) * 6 + 6)};

    % Extend trajectories
    for body = 1 : N
        set(plotHandles.trajectory(body), 'XData',...
            [get(plotHandles.trajectory(body), 'XData'),...
            pos{1}(:, body)']);
        set(plotHandles.trajectory(body), 'YData',...
            [get(plotHandles.trajectory(body), 'YData'),...
            pos{2}(:, body)']);
        set(plotHandles.trajectory(body), 'ZData',...
            [get(plotHandles.trajectory(body), 'ZData'),...
            pos{3}(:, body)']);
    end

    % Move the labels
    for body = 1 : N
        set(plotHandles.label(body), 'Position',...
            [pos{1}(end, body), pos{2}(end, body), pos{3}(end, body)])
    end

end

function bodyData = plotEarthMoon(time, velPos, bodyData, plotHandles)
    N = length(bodyData);   % Nr of bodies

    pos = {velPos(:, (0 : N - 1) * 6 + 4);
           velPos(:, (0 : N - 1) * 6 + 5);
           velPos(:, (0 : N - 1) * 6 + 6)};

    % Update position of the spheres
    for body = [1 4 5]
        set(plotHandles.spheres(body), 'XData', get(plotHandles.spheres(body), 'XData')...
            - bodyData(body).lastPos(1) + pos{1}(end, body));
        set(plotHandles.spheres(body), 'YData', get(plotHandles.spheres(body), 'YData')...
            - bodyData(body).lastPos(2) + pos{2}(end, body));
        set(plotHandles.spheres(body), 'ZData', get(plotHandles.spheres(body), 'ZData')...
            - bodyData(body).lastPos(3) + pos{3}(end, body));

        bodyData(body).lastPos = [pos{1}(end, body), pos{2}(end, body), pos{3}(end, body)];
    end

end

function sphereHandle = plotSphere(pos, radius)
    % Nr of faces = n^2
    n = 30;

    % Make sphere
    [X, Y, Z] = sphere(n);

    % Scale the sphere
    X = radius * X; Y = radius * Y; Z = radius * Z;

    % Shift the sphere
    X = X + pos(1); Y = Y + pos(2); Z = Z + pos(3); 

    sphereHandle = surf(X, Y, -Z, 'EdgeColor', 'none');
end
