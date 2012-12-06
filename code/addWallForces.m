function data = addWallForces(data)
% Calculates the forces of walls acting on the agents.

% Constants (TODO: should be assigned per agent):
A = 1;        % repulsion force factor
B = 0.2;      % distance falloff factor
r = 0.3;      % agent radius
k = 1e2;      % contact repulsion coefficient
kappa = 1e2;  % sliding friction coefficient

n = length(data.agents);

for i=1:n
    % Use shorter variable names:
    p = data.agents(i).p / data.meter_per_pixel;
    v = data.agents(i).v;

    % Calculate wall normal vector:
    ny = lerp2(data.floor.wall_dist_grad_x, p(2), p(1));
    nx = lerp2(data.floor.wall_dist_grad_y, p(2), p(1));
    normal = [nx ny];
    
    % Calculate wall tangent vector:
    tangent = [-ny nx];
    
    % Calculate wall distance:
    d = lerp2(data.floor.wall_dist, p(2), p(1));
    
    % Add force:
    data.agents(i).f = data.agents(i).f + ...
             (A * exp((r-d)/B) + k * max(0, r-d)) * normal + ...
             kappa * max(0, r-d) * dot(v, tangent) * tangent;
end

end
