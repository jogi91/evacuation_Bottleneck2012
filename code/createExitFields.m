function data = createExitFields(data)
% Calculates the desired vector fields for the agents to find the exits.

boundary_data = zeros(size(data.floor.wall));
boundary_data(data.floor.wall) = -1;
exit_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
[data.floor.dir_x, data.floor.dir_y] = ...
    getNormalizedGradient(boundary_data, -exit_dist);

end
