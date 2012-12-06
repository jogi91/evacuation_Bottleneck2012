function data = initialize(config)

data = config;

% Compile C functions:
mex 'fastSweeping.c';
mex 'getNormalizedGradient.c';
mex 'lerp2.c';

% Initialize capacities:
% data.spawnCounts = zeros(config.numberSpawnZones, 1);
% data.exitCapacities = zeros(config.numberExits, 1);

% Initialize agents:
data = initAgents(config, data);

% Calculate wall force fields:
boundary_data = zeros(size(data.floor.wall));
boundary_data(data.floor.wall) = -1;
data.floor.wall_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
[data.floor.wall_dist_grad_x, data.floor.wall_dist_grad_y] = ...
    getNormalizedGradient(boundary_data, data.floor.wall_dist - data.meter_per_pixel);

% Calculate exit force fields:
data = createExitFields(data);
