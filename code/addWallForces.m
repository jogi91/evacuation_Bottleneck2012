function data = addWallForces(data)
% Calculates the forces of walls acting on the agents.

for ai = 1:length(data.agents)
    % Use shorter variable names:
    p = data.agents(ai).p / data.meter_per_pixel;
    v = data.agents(ai).v;
    r = data.agents(ai).r;

    % Calculate wall normal vector:
    ny = lerp2(data.floor.wall_dist_grad_x, p(2), p(1));
    nx = lerp2(data.floor.wall_dist_grad_y, p(2), p(1));
    normal = [nx ny];
    
    % Calculate wall tangent vector:
    tangent = [-ny nx];
    
    % Calculate wall distance:
    d = lerp2(data.floor.wall_dist, p(2), p(1));
    
    % Add force:
    data.agents(ai).f = data.agents(ai).f + ...
             (data.A * exp((r-d)/data.B) + data.k * max(0, r-d)) * normal + ...
             data.kappa * max(0, r-d) * dot(v, tangent) * tangent;
end

end
