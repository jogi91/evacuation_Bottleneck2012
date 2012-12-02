function data = initialize(config)

data = config;

% Initialize capacities:
data.spawnCounts = zeros(config.numberSpawnZones, 1);
data.exitCapacities = zeros(config.numberExits, 1);

data = initAgents(config, data);
