function data = initialize(config)

data = config;


% Seed random number generator:
rng(data.rseed);

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
data.floor.dir_x = data.floor.dir_new_x;
data.floor.dir_y = data.floor.dir_new_y;

% Calculate middle points of exits in pixels and
% initialize destination field update progresses:
for ei = 1:length(data.floor.exits)
    [rs cs] = find(data.floor.exits{ei});
    n = length(rs);
    data.floor.exit_midpoints{ei} = [sum(rs) sum(cs)] / n;
    
    data.floor.dfieldupdate_cur_radii(ei) = 0;
end
data.floor.dfieldupdate_full_exits = [];
data.floor.dfieldupdate_dir_x = [];
data.floor.dfieldupdate_dir_y = [];

% Maximum distance for influence of agents on each other:
data.r_influence = ...
    fzero(@(r) data.A * exp((2*data.r_max-r)/data.B) - 1e-4, data.r_max);

% Initialize exit statistics:
data.agents_exited = zeros(1, data.num_exits);
data.agents_exited_time_series = [];
