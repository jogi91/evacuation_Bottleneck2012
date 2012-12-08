function data = placeAgents(data)
% Try to place remaining agents in all spawning zones.

% Calculate a random agent radius:
function r = getRadius()
    r = data.r_min + (data.r_max-data.r_min)*rand(1);	
end


% Get number of agents existing so far:
numAgents = length(data.agents);

% Iterate through each of the spawn zones:
for si = 1:data.num_spawn_zones
    % Get pixel coordinates for spawning spots:
    [ySpots,xSpots] = find(data.floor.spawn_zones{si}==1);
    % Convert to meters:
    xSpots = xSpots * data.meter_per_pixel;
    ySpots = ySpots * data.meter_per_pixel;
    
    % Try to place remaining number of agents for this spawn zone:
    curSpawnCount = data.spawn_counts(si);
    for j = 1:curSpawnCount
        ai = numAgents + 1;  % new agent index
        
        data.agents(ai).r = getRadius();
        data.agents(ai).v0 = data.v0;
        data.agents(ai).v = [0 0];  % velocity
        data.agents(ai).f = [0 0];  % force

        % Try to find an empty spot:
        tries = 5;
        while tries > 0
            % Randomly pick a spot and check if it's free:
            idx = randi(length(xSpots));
            data.agents(ai).p = [xSpots(idx), ySpots(idx)];

            % Check for agent intersections:
    		if checkForIntersection(data, ai) == 0
    			tries = -1;  % leave the loop
            end

            % Agent was intersecting; try again or give up.
            tries = tries - 1;
        end

        if tries > -1
            % If placement failed, remove the new agent
            data.agents = data.agents(1:end-1);
        else
            numAgents = numAgents + 1;
            % Decrease spawn count for this zone:
            data.spawn_counts(si) = data.spawn_counts(si) - 1;
        end
    end
end

end
