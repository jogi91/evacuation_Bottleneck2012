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
it = 0;
while(time<duration)
    % Calculate forces:
    data = addDesiredForces(data);
    data = addInterAgentForces(data);
    data = addWallForces(data);
    
    % Target velocity:
%     tmp = targetVel - sqrt(sum(data.agents.v.^2,2));
%     forces = forces + 5 * tmp(:,ones(1,2)) .* data.agents.v;
    
    % Clip force magnitude:
%     forces(isnan(forces)) = 0;
%     for i = 1:size(forces,1)
%         if norm(forces(i)) > f_max
%             forces(i) = f_max * forces(i) / norm(forces(i));
%         end
%     end

    % Clip velocity:
    for i = 1:size(data.agents)
        av = data.agents(i).v;
        avn = norm(av);
        if(avn > data.v_max)
            data.agents(i).v = v_max * av / avn;
        end
    end
    
    % Progress agents with Leap-Frog integration:
    for ai = 1:length(data.agents)
        data.agents(ai).v = data.agents(ai).v + dt * data.agents(ai).f;
        
        % Clip velocity:
        avn = norm(data.agents(i).v);
        if(avn > data.v_max)
            data.agents(i).v = data.v_max * data.agents(i).v / avn;
        end
        
        data.agents(ai).p = data.agents(ai).p + dt * data.agents(ai).v;
        data.agents(ai).f = [0 0];
    end

    % Plot agent positions:
    hold off;
    imagesc(1 * config.floor.wall);
    colormap([1 1 1; 0 0 0]);
    shading flat;
    hold on;
    
    for ai = 1:length(data.agents)
        plot(data.agents(ai).p(:,1) / config.meter_per_pixel, ...
             data.agents(ai).p(:,2) / config.meter_per_pixel, 'o');
    end
    
    drawnow;
    
	time = time + dt;
    it = it + 1;
end
