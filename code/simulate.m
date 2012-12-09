function simulate(configFile)

% Initialize the environment from config file:
if nargin == 1
    config = loadConfig(configFile);
else
    config = loadConfig('../data/democonfig.conf');
end
data = initialize(config);


% Simulation loop:
time = 0;
it = 0;
while time < data.duration
%     tic;
    
    % Possibly spawn new agents:
    data = placeAgents(data);
    
    % Update desired vector fields:
    data = progressDestFields(data);
    
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
    
%     toc
end
