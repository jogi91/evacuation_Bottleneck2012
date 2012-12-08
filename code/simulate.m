function simulate(configFile)
% Get the Initial Values from a config file
% For now, they are still hard coded for simplicity
% They could be used, if no configFile was given as argument

% Initialize the environment
config = loadConfig('../data/democonfig.conf');
data = initialize(config);


% Simulation loop:
time = 0;
it = 0;
while time < data.duration
    % Calculate forces:
    data = addDesiredForces(data);
    data = addInterAgentForces(data);
    data = addWallForces(data);
    
    % Progress agents:
    data = progressAgents(data);

    % Draw floor and agents:
    plotFloor(data);
    
	time = time + data.dt;
    it = it + 1;
end
