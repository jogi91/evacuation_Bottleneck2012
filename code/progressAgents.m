function data = progressAgents(data)
% Move agents by applying the forces calculated so far and check for
% exiting agents.

% Store which agents have reached which exit (index of array is agent
% index, value is exit index):
exited = zeros(1, length(data.agents));

% Store floor size:
floorW = size(data.floor.img_build, 2) * data.meter_per_pixel;
floorH = size(data.floor.img_build, 1) * data.meter_per_pixel;

% Progress agents with Leap-Frog integration:
for ai = 1:length(data.agents)
    data.agents(ai).v = data.agents(ai).v + data.dt * data.agents(ai).f;

    % Clip velocity:
    avn = norm(data.agents(ai).v);
    if(avn > data.v_max)
        data.agents(ai).v = data.v_max * data.agents(ai).v / avn;
    end

    newpos = data.agents(ai).p + data.dt * data.agents(ai).v;
    % Restrict position to floor:
    if any(isnan(newpos)); newpos = [0,0]; end
    if newpos(1) < 0; newpos(1) = 0; end
    if newpos(2) < 0; newpos(2) = 0; end
    if newpos(1) > floorW; newpos(1) = floorW; end
    if newpos(2) > floorH; newpos(2) = floorH; end
    
    data.agents(ai).p = newpos;
    
    % Reset force:
    data.agents(ai).f = [0 0];
    
    % Check for exiting:
    for ei = 1:length(data.floor.exit)
        if data.floor.exit{ei}(round(newpos(2) / data.meter_per_pixel), ...
                               round(newpos(1) / data.meter_per_pixel));
            exited(ai) = ei;
            break;
        end
    end
end

% Remove exited agents:
data.agents = data.agents(exited == 0);

end
