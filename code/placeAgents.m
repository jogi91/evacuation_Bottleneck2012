%Actually places the desired amount of agents in the right floor and spawnZone
function data = placeAgents(data, agentCount, floorNumber, spawnZoneNumber)

s = size(data.agents);
numAgents = s(2);
for i=(numAgents+1):numAgents+agentCount+1
	%TODO: Randomly Populate the Area
	data.agents(i).pos
end
