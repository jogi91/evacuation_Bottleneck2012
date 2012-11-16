function config = loadConfig(config_file)
% load the configuration file
%
%  arguments:
%   config_file     string, which configuration file to load
%


% get the path from the config file -> to read the images
config_path = fileparts(config_file);
if strcmp(config_path, '') == 1
    config_path = '.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s', 'CommentStyle','%');
fclose(fid);

keynames = input{1};
values = input{2};

%convert numerical values from string to double
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames);


% read the images
for i=1:config.floor_count
    
    %building structure
    file = config.(sprintf('floor_%d_build', i));
    file_name = [config_path '/' file];
    img_build = imread(file_name);
    
    % decode images
		%Walls, Colormapped to 0
    config.floor(i).img_wall = img_build==0;

		%Spawn Zones, Colormapped from 2..numberSpawnZones+1
		for	j=2:config.numberSpawnZones+1
			config.floor(i).spawnZone(j) = img_build==j;
		end

		%Exits, The remaining part of the Colormap...
		for j=config.numberSpawnZones+2:config.numberSpawnZones+2+config.numberExits-1
			config.floor(i).exit(j) = img_build==j;
		end
                                 
		%TODO: actualize...
    %init the plot image here, because this won't change
%    config.floor(i).img_plot = 5*config.floor(i).img_wall
%        + 4*config.floor(i).img_stairs_up ...
%        + 3*config.floor(i).img_stairs_down ...
%        + 2*config.floor(i).img_exit ...
%        + 1*config.floor(i).img_spawn;
%    config.color_map = [1 1 1; 0.9 0.9 0.9; 0 1 0; 0.4 0.4 1; 1 0.4 0.4; 0 0 0];
end

