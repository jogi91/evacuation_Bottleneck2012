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

% Calculate normalized wall distance gradients:
walls = zeros(size(data.floor.wall));
walls(data.floor.wall) = -1;
data.floor.wall_dist = fastSweeping(walls) * data.meter_per_pixel;
[data.floor.wall_dist_grad_x, data.floor.wall_dist_grad_y] = ...
    getNormalizedGradient(walls, data.floor.wall_dist - data.meter_per_pixel);