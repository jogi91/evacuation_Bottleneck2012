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
while length(data.agents) > 0 || time < 2
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
    if data.save_frames
        print('-dpng', sprintf('frames/%s_%05i.png', ...
            data.frame_basename, it));
    end
    
    % Collect statistics:
    data.agents_exited_time_series = ...
        [data.agents_exited_time_series; time, data.agents_exited];
    
	time = time + data.dt;
    it = it + 1;
    
%     toc
end

data.finish_time = time;

% Plot exit occupations:
plotExitedAgents(config, data);

% Store time needed to evacuate:
timeFileID = fopen(sprintf('frames/%s_finish_time.txt', data.frame_basename), 'w');
fprintf(timeFileID, '%.1f\n', data.finish_time);
fclose(timeFileID);
