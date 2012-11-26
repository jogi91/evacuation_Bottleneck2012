%Actually places the desired amount of agents in the right floor and spawnZone
function data = placeAgents(data, agentCount, floorNumber, spawnZoneNumber)

%get a random Radius
function r = getRadius();
	r = data.r_min + (data.r_max-data.r_min)*rand(1);	
end

s = size(data.agents);
numAgents = s(2);
[xSpots,ySpots] = find(data.floor(floorNumber).spawnZone{spawnZoneNumber} ==1)
for i=(numAgents+1):numAgents+agentCount+1
	%TODO: Randomly Populate the Area
	data.agents(i).r = getRadius; %How fat is the Agent?
	data.agents(i).v0 = data.v0; %How fast wants the Agent go?
	data.agents(i).f = [0 0]; % Use the Force, Luke!
	data.agents(i).v = [0 0]; %Run Forest, run!
	
	%Where am I?
end
