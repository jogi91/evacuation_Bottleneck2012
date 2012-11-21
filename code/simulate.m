function simulate(configFile)
%Get the Initial Values from a config file
%For now, they are still hard coded for simplicity
%They could be used, if no configFile was given as argument

%%%%%%%%%%%
%Variables%
%%%%%%%%%%%

%Timestep (in seconds)
dt = 0.1;
duration = 120;
time = 0;

%Initialize the environment

config = loadConfig('../data/democonfig.conf')

% Agents:
% Each row consists of an x and y component.
nAgents = 50;
agentsPos = [10 * (rand(nAgents, 2) - 0.5)];
agentsVel = [rand(nAgents, 2) - 0.5];

targetVel = 0.2;

%Simulation loop
while(time<duration)
    % Calculate forces:
    forces = repulsiveForces(agentsPos, agentsVel);
    % Go to center:
    forces = forces - 0.01 * agentsPos;
    % Target velocity:
    tmp = targetVel - sqrt(sum(agentsVel.^2,2));
    forces = forces + 5 * tmp(:,ones(1,2)) .* agentsVel;
    
    % Progress agents with Leap-Frog integration:
    agentsVel = agentsVel + dt * forces;
    agentsPos = agentsPos + dt * agentsVel;

    % Plot agent positions:
    plot(agentsPos(:,1), agentsPos(:,2), 'o');
    axis([-10, 10, -10, 10]);
    drawnow;

	time = time+dt;
end

%Output processing
