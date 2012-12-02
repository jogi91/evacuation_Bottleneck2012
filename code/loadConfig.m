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
		[x,y] = size(img_build); %Get dimensions

    
    % decode images
		%Walls, Colormapped to 0
    config.floor(i).img_wall = img_build==0;

		%Spawn Zones, Colormapped from 2..numberSpawnZones+1
		%config.floor(i).spawnZone = zeros(x, y);
% 		config.floor(i)
		for	j=2:config.numberSpawnZones+1
			currentIndex = j-1; %Shift Index to start from 1
			config.floor(i).spawnZone{currentIndex} = img_build==j; 
			config.spawnCounts(currentIndex) = config.(sprintf('spawnCount%d', currentIndex)); % get each spawn count into an array
		end

		%Exits, The remaining part of the Colormap...
		%config.floor(i).exit = zeros(config.numberExits, x,y);
		for j=config.numberSpawnZones+2:config.numberSpawnZones+2+config.numberExits-1
			currentIndex = j-config.numberSpawnZones-1; % Index Shifting
			config.floor(i).exit{currentIndex} = img_build==j; %Same as above, Not sure...
			config.exitCapacities(currentIndex) = config.(sprintf('exitCapacity%d', currentIndex));
		end
                                 
end
