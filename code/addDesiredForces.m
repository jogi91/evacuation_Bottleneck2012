function data = addDesiredForces(data)
% Calculates the forces for agents looking for the exits.

% Constants (TODO: should be in data):
tau = 0.5;

for i = 1:length(data.agents);
    % Use shorter variable names:
    p  = data.agents(i).p / data.meter_per_pixel;
    v  = data.agents(i).v;
    v0 = data.agents(i).v0;

    % Calculate desired vector:
    e = [lerp2(data.floor.dir_x, p(2), p(1)), ...
         lerp2(data.floor.dir_y, p(2), p(1))];
    
    % Add force:
    data.agents(i).f = data.agents(i).f + (v0 * e - v) / tau;
end

end
