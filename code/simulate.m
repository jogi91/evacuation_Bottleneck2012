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

config = loadConfig('../data/democonfig.conf');
data = initialize(config);

targetVel = 0.2;

%Simulation loop
while(time<duration)
    % Calculate forces:
    forces = repulsiveForces(data.agents.p, data.agents.v);
    % Go to center:
    forces = forces - 0.01 * data.agents.p;
    % Target velocity:
    tmp = targetVel - sqrt(sum(data.agents.v.^2,2));
    forces = forces + 5 * tmp(:,ones(1,2)) .* data.agents.v;
    
    % Progress agents with Leap-Frog integration:
    data.agents.v = data.agents.v + dt * forces;
    data.agents.p = data.agents.p + dt * data.agents.v;

    % Plot agent positions:
    plot(data.agents.p(:,1), data.agents.p(:,2), 'o');
    axis([-10, 10, -10, 10]);
    drawnow;

	time = time+dt;
end

%Output processing
