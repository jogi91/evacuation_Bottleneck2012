function simulate(configFile)
% Get the Initial Values from a config file
% For now, they are still hard coded for simplicity
% They could be used, if no configFile was given as argument

% Timestep (in seconds):
dt = 0.1;
duration = 120;
time = 0;
f_max = 10;

% Initialize the environment
config = loadConfig('../data/democonfig.conf');
data = initialize(config);

targetVel = 0.5;


% Simulation loop:
it = 0;
while(time<duration)
    % Calculate forces:
    forces = repulsiveForces(data.agents.p, data.agents.v) + ...
             wallForces(data);
    % Target velocity:
    tmp = targetVel - sqrt(sum(data.agents.v.^2,2));
    forces = forces + 5 * tmp(:,ones(1,2)) .* data.agents.v;
    
    % Clip force magnitude:
    forces(isnan(forces)) = 0;
    for i = 1:size(forces,1)
        if norm(forces(i)) > f_max
            forces(i) = f_max * forces(i) / norm(forces(i));
        end
    end
    
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
    
    % TEST:
%     if(mod(it, 10) == 0)
%         p = data.agents.p(1,:);
%         fprintf('\nAgent pos: %.2f, %.2f\n', p(1), p(2));
%         
%         [x y] = ginput(1);
%         fprintf('Click: %.2f, %.2f\n', x*data.meter_per_pixel, y*data.meter_per_pixel);
%     end

	time = time + dt;
    it = it + 1;
end

%Output processing
