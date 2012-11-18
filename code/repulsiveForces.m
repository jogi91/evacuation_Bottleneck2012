%calculates the repulsive force of each agent
function forces = repulsiveForces(agentsPos, agentsVel)

% Constants (TODO: should be assigned per agent):
A = 0.1;      % repulsion force factor
B = 0.1;      % distance falloff factor
r = 0.3;      % agent radius
k = 1e2;      % contact repulsion coefficient
kappa = 1e2;  % sliding friction coefficient

n = length(agentsPos);
forces = zeros(n, 2);

for agentIdx = 1:n
    for otherIdx = 1:n
        % Skip if the two agents are the same:
        if otherIdx == agentIdx
            continue
        end
        
        % Calculate different vectors between agent-agent pair:
        dPos = agentsPos(agentIdx,:) - agentsPos(otherIdx,:);
        d = norm(dPos);
        
        % Distance cutoff:
        if(d > 2), continue; end
        
        normal = dPos / d;
        tangent = [-normal(2), normal(1)];
        
        dVel = dot(agentsVel(otherIdx,:) - agentsVel(agentIdx,:), tangent);
        
        % Calculate force for one agent-agent pair:
        forces(agentIdx,:) = forces(agentIdx,:) + ...
            (A * exp((r-d)/B) + k * max(0, r-d)) * normal + ...
            kappa * max(0, r-d) * dVel * tangent;
    end
end