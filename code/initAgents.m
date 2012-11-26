function data = initAgents(data)

% The properties of the agents are stored in a struct.
data.agents = [];
%Initialize the position Matrix
%data.agents.pos = []; 
% Stores the number of floors in which a spawn Zone type is present
spawnZoneFloors = zeros(data.floor_count,1);
% Stores, on how many floors a spawnZone is present
res = 0;
agentCounter = 0;

%iterate through each of the spawn zones
for i=1:data.numberSpawnZones
	for j=1:data.floor_count
		%If theres a nonzero element in the spawnzone on the floor,
		if nnz(data.floor(j).spawnZone{i}) > 0 
			spawnZoneFloors(j) = 1; 
			res = res + 1;
		end
	end
	agentsPerFloor = floor(data.spawnCounts(i)/res);
	for j=1:data.floor_count
		if spawnZoneFloors(j) == 1
			placeAgents(data, agentsPerFloor, j, i);
		end
	end
end
