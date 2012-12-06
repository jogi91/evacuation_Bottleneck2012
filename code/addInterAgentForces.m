function data = addInterAgentForces(data)
% Calculates the repulsive forces between agents.

n = length(data.agents);

for ai = 1:n  % agent index
    for oi = 1:n  % other index
        % Skip if the two agents are the same:
        if oi == ai
            continue
        end
        
        r = data.agents(ai).r + data.agents(oi).r;
        
        % Calculate different vectors between agent-agent pair:
        dPos = data.agents(ai).p - data.agents(oi).p;
        d = norm(dPos);
        
        % Distance cutoff:
        if(d > 2), continue; end
        
        normal = dPos / d;
        tangent = [-normal(2), normal(1)];
        
        dVel = dot(data.agents(oi).v - data.agents(ai).v, tangent);
        
        % Calculate force for one agent-agent pair:
        data.agents(ai).f = data.agents(ai).f + ...
            (data.A * exp((r-d)/data.B) + data.k * max(0, r-d)) * normal + ...
            data.kappa * max(0, r-d) * dVel * tangent;
    end
end