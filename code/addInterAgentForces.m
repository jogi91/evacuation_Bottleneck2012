function data = addInterAgentForces(data)
% Calculates the repulsive forces between agents.

n = length(data.agents);
if n == 0; return; end

for ai = 1:n  % agent index
    p_i = data.agents(ai).p;
    v_i = data.agents(ai).v;
    
    % Get indices of all near agents:
    rmax = data.r_influence;
    for aj = ai+1:n  % other agent index
            p_j = data.agents(aj).p;
            v_j = data.agents(aj).v;
            
            r = data.agents(ai).r + data.agents(aj).r;

            % Calculate different vectors between agent-agent pair:
            dPos = p_i - p_j;
            d = norm(dPos);
            
            % Distance cutoff:
            if d > rmax; continue; end

            normal = dPos / d;
            tangent = [-normal(2), normal(1)];

            dVel = dot(v_j - v_i, tangent);

            % Calculate force for one agent-agent pair:
            F = ...
                (data.A * exp((r-d)/data.B) + data.k * max(0, r-d)) * normal + ...
                data.kappa * max(0, r-d) * dVel * tangent;

            data.agents(ai).f = data.agents(ai).f + F;
            data.agents(aj).f = data.agents(aj).f - F;
    end
end