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
    % Clip force:
    afn = norm(data.agents(ai).f);
    if(afn > data.f_max)
        data.agents(ai).f = data.f_max * data.agents(ai).f / afn;
    end
    
    % Calculate new velocity:
    newvel = data.agents(ai).v + data.dt * data.agents(ai).f / ...
                                 data.m;

    % Clip velocity:
    avn = norm(newvel);
    if(avn > data.v_max)
        newvel = data.v_max * newvel / avn;
    end

    % Calculate new position:
    oldpos = data.agents(ai).p;
    newpos = oldpos + data.dt * newvel;
    % Restrict position to floor:
    if any(isnan(newpos)); newpos    = [0,0];  end
    if newpos(1) < mpp;    newpos(1) = mpp;    end
    if newpos(2) < mpp;    newpos(2) = mpp;    end
    if newpos(1) > floorW; newpos(1) = floorW; end
    if newpos(2) > floorH; newpos(2) = floorH; end
    
    % If agent got into a wall, move him out:
%     wdepth = data.agents(ai).r - lerp2(data.floor.wall_dist, newpos(2), newpos(1));
%     if wdepth > 0
%         % Calculate wall normal vector:
%         ny = lerp2(data.floor.wall_dist_grad_x, oldpos(2), oldpos(1));
%         nx = lerp2(data.floor.wall_dist_grad_y, oldpos(2), oldpos(1));
%         normal = [nx ny];
%         
%         % Remove perpendicular velocity component:
% %         newvel = newvel - dot(normal, newvel) / dot(normal,normal) * normal;
%         % Move him out:
%         newpos = newpos + normal * wdepth;
%     end
    
    % Apply new state:
    data.agents(ai).v = newvel;
    data.agents(ai).p = newpos;
    
    % Reset force:
    data.agents(ai).f = [0 0];
    
    % Check for exiting:
    for ei = 1:length(data.floor.exits)
        if data.exit_capacities(ei) > 0 && ...
           data.floor.exits{ei}(round(newpos(2) / mpp), ...
                                round(newpos(1) / mpp))
            exited(ai) = true;
            data.exit_capacities(ei) = data.exit_capacities(ei) - 1;
            
            % Update exits and desired vector fields:
            if data.exit_capacities(ei) == 0
                data = createExitFields(data);
                
                if data.dfieldupdate_enable
                    % Add current exit to list of filled ones:
                    numFull = length(data.floor.dfieldupdate_full_exits) + 1;
                    data.floor.dfieldupdate_full_exits(numFull) = ei;
                    data.floor.dfieldupdate_dir_x{numFull} = ...
                         data.floor.dir_new_x;
                    data.floor.dfieldupdate_dir_y{numFull} = ...
                         data.floor.dir_new_y;
                else
                    % If fancy circular updating is disabled, update the
                    % entire field immediately:
                    data.floor.dir_x = data.floor.dir_new_x;
                    data.floor.dir_y = data.floor.dir_new_y;
                end
            end
            break;
        end
    end
end

% Remove exited agents:
data.agents = data.agents(~exited);

end
