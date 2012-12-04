function data = addInterAgentForces(data)
% Calculates the repulsive forces between agents.

% Constants (TODO: should be assigned per agent):
A = 0.1;      % repulsion force factor
B = 0.1;      % distance falloff factor
r = 0.3;      % agent radius
k = 1e2;      % contact repulsion coefficient
kappa = 1e2;  % sliding friction coefficient

n = length(data.agents);

for agentIdx = 1:n
    for otherIdx = 1:n
        % Skip if the two agents are the same:
        if otherIdx == agentIdx
            continue
        end
        
        % Calculate different vectors between agent-agent pair:
        dPos = data.agents(agentIdx).p - data.agents(otherIdx).p;
        d = norm(dPos);
        
        % Distance cutoff:
        if(d > 2), continue; end
        
        normal = dPos / d;
        tangent = [-normal(2), normal(1)];
        
        dVel = dot(data.agents(otherIdx).v - data.agents(agentIdx).v, tangent);
        
        % Calculate force for one agent-agent pair:
        data.agents(agentIdx).f = data.agents(agentIdx).f + ...
            (A * exp((r-d)/B) + k * max(0, r-d)) * normal + ...
            kappa * max(0, r-d) * dVel * tangent;
    end
end