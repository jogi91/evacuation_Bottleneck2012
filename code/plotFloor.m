function plotFloor(data)
% Draws the floor layout with the agents.

hold off;
imagesc(data.floor.wall);
colormap([1 1 1; 0 0 0]);
axis equal;
axis off;
hold on;

% Prepare circle data for drawing:
t = linspace(0, 2*pi, 16);
x = cos(t);
y = sin(t);

for ai = 1:length(data.agents)
    % Draw an agent as a circle with his middle point and radius:
    x0 = data.agents(ai).p(1);
    y0 = data.agents(ai).p(2);
    r  = data.agents(ai).r;
    line((r * x + x0) / data.meter_per_pixel, ...
         (r * y + y0) / data.meter_per_pixel);
end

drawnow;

end

