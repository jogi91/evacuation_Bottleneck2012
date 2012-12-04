function data = initAgents(config, data)

% The properties of the agents are stored in a struct.
data.agents = [];

% TODO: Change in the future
% For now, store all the agents' positions and velocities here:
% data.agents.p = 4 * rand(config.spawnCounts, 2) + 3;
% data.agents.v = rand(config.spawnCounts, 2) - 0.5;

data = placeAgents(data);