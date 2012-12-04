function config = loadConfig(config_file)
% Populate config struct from given config file.
%
% Arguments:
%   config_file     string, path to configuration file to load
%


% Get the path from the config file to read images from same directory:
config_path = fileparts(config_file);
if strcmp(config_path, '') == 1
    config_path = '.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s', 'CommentStyle','%');
fclose(fid);

keynames = input{1};
values = input{2};

% Convert numerical values from string to double:
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames);


% Read the image describing the floor layout:
% Building structure:
file = config.floor_build;
file_name = [config_path '/' file];
img_build = imread(file_name);
    [x,y] = size(img_build); %Get dimensions

config.floor.img_build = img_build;


% Decode images:
% Walls, Colormapped to 0
config.floor.wall = img_build==0;

%Spawn Zones, Colormapped from 2..numberSpawnZones+1
%config.floor.spawnZone = zeros(x, y);
for	j=2:config.numberSpawnZones+1
    currentIndex = j-1; %Shift Index to start from 1

    config.floor.spawnZone{currentIndex} = img_build==j;
    
    % Get each spawn count into an array:
    config.spawnCounts(currentIndex) = config.(sprintf('spawnCount%d', currentIndex));
end

% Exits, The remaining part of the colormap
% config.floor.exit = zeros(config.numberExits, x,y);
for j=config.numberSpawnZones+2:config.numberSpawnZones+2+config.numberExits-1
    currentIndex = j-config.numberSpawnZones-1; % Index Shifting

    config.floor.exit{currentIndex} = img_build==j; %Same as above, Not sure...
    config.exitCapacities(currentIndex) = config.(sprintf('exitCapacity%d', currentIndex));
end
