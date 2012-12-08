function data = addDesiredForces(data)
% Calculates the forces for agents looking for the exits.

for ai = 1:length(data.agents);
    % Use shorter variable names:
    p  = data.agents(ai).p / data.meter_per_pixel;
    v  = data.agents(ai).v;
    v0 = data.agents(ai).v0;

    % Calculate desired vector:
    e = [lerp2(data.floor.dir_y, p(2), p(1)), ...
         lerp2(data.floor.dir_x, p(2), p(1))];
    
    % Add force:
    data.agents(ai).f = data.agents(ai).f + data.m * (v0 * e - v) / data.tau;
end

end
