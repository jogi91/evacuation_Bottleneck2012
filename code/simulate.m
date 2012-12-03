function simulate(configFile)
% Get the Initial Values from a config file
% For now, they are still hard coded for simplicity
% They could be used, if no configFile was given as argument

% Timestep (in seconds):
dt = 0.1;
duration = 120;
time = 0;

% Initialize the environment
config = loadConfig('../data/democonfig.conf');
data = initialize(config);

targetVel = 0.5;


% Simulation loop:
while(time<duration)
    % Calculate forces:
    forces = repulsiveForces(data.agents.p, data.agents.v) + ...
             wallForces(data);
    % Target velocity:
    tmp = targetVel - sqrt(sum(data.agents.v.^2,2));
    forces = forces + 5 * tmp(:,ones(1,2)) .* data.agents.v;
    
    % Progress agents with Leap-Frog integration:
    data.agents.v = data.agents.v + dt * forces;
    data.agents.p = data.agents.p + dt * data.agents.v;

    % Plot agent positions:
    hold off;
    pcolor(1 * config.floor.img_wall);
    colormap([1 1 1; 0 0 0]);
    shading flat;
    hold on;
    
    plot(data.agents.p(:,1) / config.meter_per_pixel, ...
         data.agents.p(:,2) / config.meter_per_pixel, 'o');
    
    drawnow;

	time = time+dt;
end

%Output processing
