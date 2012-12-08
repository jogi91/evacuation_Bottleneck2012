function data = createExitFields(data)
% Calculates the desired vector fields for the agents to find the exits,
% only including non-full exits.
% Fields are placed in data.floor.dir_new_{x,y}.

boundary_data = zeros(size(data.floor.wall));
boundary_data(data.floor.wall) = 1;

for i = 1:length(data.floor.exits)
    % Check if exit has been filled:
    if data.exit_capacities(i) > 0
        boundary_data(data.floor.exits{i}) = -1;
    end
end

exit_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
[data.floor.dir_new_x, data.floor.dir_new_y] = ...
    getNormalizedGradient(boundary_data, -exit_dist);

end
