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

%Spawn Zones, Colormapped from 2..num_spawn_zones+1
for	j=2:config.num_spawn_zones+1
    currentIndex = j-1; %Shift Index to start from 1

    config.floor.spawn_zones{currentIndex} = img_build==j;
    
    % Get each spawn count into an array:
    config.spawn_counts(currentIndex) = config.(sprintf('spawn_count_%d', currentIndex));
end

% Exits, The remaining part of the colormap
for j=config.num_spawn_zones+2:config.num_spawn_zones+2+config.num_exits-1
    currentIndex = j-config.num_spawn_zones-1; % Index Shifting

    config.floor.exits{currentIndex} = img_build==j; %Same as above, Not sure...
    config.exit_capacities(currentIndex) = config.(sprintf('exit_capacity_%d', currentIndex));
end
