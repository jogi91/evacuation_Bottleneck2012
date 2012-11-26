function data = initialize(config)


data = config;

%Initialize Capacities
data.spawnCounts = zeros(config.numberSpawnZones,1);
data.exitCapacities = zeros(config.numberExits,1);

data = initAgents(data);

