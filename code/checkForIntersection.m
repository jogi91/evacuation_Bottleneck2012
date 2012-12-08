function val = checkForIntersection(data, agent_idx)
% Check an agent for an intersection with another agent or a wall.
% the check is kept as simple as possible
%
%  arguments:
%   data            global data structure
%   agent_idx       which agent on that floor
%
%  return:
%   0               for no intersection
%   1               has an intersection with wall
%   2                                   with another agent

val = 0;

p = data.agents(agent_idx).p;
r = data.agents(agent_idx).r;

% Check for agent intersection:
for i = 1:length(data.agents)
    if i ~= agent_idx
        if norm(data.agents(i).p - p) ...
           <= r + data.agents(i).r
            val=2;
            return;
        end
    end
end

% Vheck for wall intersection:
if lerp2(data.floor.wall_dist, p(2), p(1)) < r
    val = 1;
end
