function F = wallForces(data)
% Returns a matrix with a row per 2D agent force.

% Constants (TODO: should be assigned per agent):
A = 0.1;      % repulsion force factor
B = 0.1;      % distance falloff factor
r = 0.3;      % agent radius
k = 1e2;      % contact repulsion coefficient
kappa = 1e2;  % sliding friction coefficient

n = length(data.agents.p);

% Initialize output:
F = zeros(n, 2);

for i=1:n
    % Use shorter variable names:
    p = data.agents.p(i, :) / data.meter_per_pixel;
    v = data.agents.v(i, :);

    % Calculate wall normal vector:
    nx = lerp2(data.floor.wall_dist_grad_x, p(1), p(2));
    ny = lerp2(data.floor.wall_dist_grad_y, p(1), p(2));
    normal = [nx ny];
    
    % Calculate wall tangent vector:
    tangent = [-ny nx];
    
    % Calculate wall distance:
    d = lerp2(data.floor.wall_dist, p(1), p(2));
    
    F(i,:) = ...
             (A * exp((r-d)/B) + k * max(0, r-d)) * normal + ...
             kappa * max(0, r-d) * dot(v, tangent) * tangent;
end

end
