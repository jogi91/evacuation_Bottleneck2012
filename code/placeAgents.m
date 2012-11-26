%Actually places the desired amount of agents in the right floor and spawnZone
function data = placeAgents(data, agentCount, floorNumber, spawnZoneNumber)

%get a random Radius
function r = getRadius();
r = data.r_min + (data.r_max-data.r_min)*rand(1);	
end


numAgents = length(data.agents);
[xSpots,ySpots] = find(data.floor(floorNumber).spawnZone{spawnZoneNumber} ==1); %where Can I place Agents
%Convert to metric
xSpots = xSpots*data.meter_per_pixel;
ySpots = ySpots*data.meter_per_pixel;

for i=(numAgents+1):numAgents+agentCount+1
	data.floor(floorNumber).agents(i).r = getRadius; %How fat is the Agent?
	data.floor(floorNumber).agents(i).v0 = data.v0; %How fast wants the Agent go?
	data.floor(floorNumber).agents(i).f = [0 0]; % Use the Force, Luke!
	data.floor(floorNumber).agents(i).v = [0 0]; %Run Forest, run!

	%Where am I?

	while tries > 0
	% randomly pick a spot and check if it's free
		idx = randi(length(xSpots));
		data.floor(floorNumber).agents(i).pos = [x(idx)*];
		if checkForIntersection(data, i, cur_agent) == 0
			tries = -1; % leave the loop
		end
		tries = tries - 1;
		end
		if tries > -1
			%remove the last agent
			data.floor(i).agents = data.floor(i).agents(1:end-1);
		end
	end

	%Could the Agent be placed
end

end
