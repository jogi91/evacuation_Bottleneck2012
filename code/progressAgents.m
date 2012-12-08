function data = progressAgents(data)
% Move agents by applying the forces calculated so far and check for
% exiting agents.

% Shorter constant name for convenience:
mpp = data.meter_per_pixel;

% Store which agents have reached which exit (index of array is agent
% index, value is exit index):
exited = false(length(data.agents), 1);

% Store floor size:
floorW = size(data.floor.img_build, 2) * mpp;
floorH = size(data.floor.img_build, 1) * mpp;

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
    if newpos(1) < mpp; newpos(1) = mpp; end
    if newpos(2) < mpp; newpos(2) = mpp; end
    if newpos(1) > floorW; newpos(1) = floorW; end
    if newpos(2) > floorH; newpos(2) = floorH; end
    
    data.agents(ai).p = newpos;
    
    % Reset force:
    data.agents(ai).f = [0 0];
    
    % Check for exiting:
    for ei = 1:length(data.floor.exits)
        if data.floor.exits{ei}(round(newpos(2) / mpp), ...
                                round(newpos(1) / mpp));
            exited(ai) = true;
            break;
        end
    end
end

% Remove exited agents:
data.agents = data.agents(~exited);

end
