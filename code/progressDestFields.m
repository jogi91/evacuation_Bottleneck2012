function data = progressDestFields(data)
% Updates the destination vector fields in radially growing shapes from
% closed exits (only when data.dfieldupdate_enable is set).

if ~data.dfieldupdate_enable; return; end

% Get size of layout in pixels:
floorSize = size(data.floor.img_build);

for fei = 1:length(data.floor.dfieldupdate_full_exits)
    ei = data.floor.dfieldupdate_full_exits(fei);
    curRadius = data.floor.dfieldupdate_cur_radii(ei);
    if data.exit_capacities(ei) == 0 && curRadius < max(floorSize)
        % Grow circle (all units in pixels):
        newRadius = curRadius + ...
            data.dt * data.dfieldupdate_speed / data.meter_per_pixel;
            
        data.floor.dfieldupdate_cur_radii(ei) = newRadius;
        
        % Generate a corresponding circular mask:
        [rs cs] = meshgrid(1:floorSize(1), 1:floorSize(2));
        r0 = data.floor.exit_midpoints{ei}(1);
        c0 = data.floor.exit_midpoints{ei}(2);
        circleMask = ((rs - r0).^2 + (cs - c0).^2 <= newRadius^2)';
        
        % Update fields:
        data.floor.dir_x(circleMask) = data.floor.dfieldupdate_dir_x{fei}(circleMask);
        data.floor.dir_y(circleMask) = data.floor.dfieldupdate_dir_y{fei}(circleMask);
    end
end
    
end

