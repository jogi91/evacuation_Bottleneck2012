%matlabpool open 4;
n = 82


for i=1:n
	configfiles{i} = sprintf('../data/costa_voyager_%d.conf', i);
end

for i=51:n
		sprintf('simulate(%s)',configfiles{i})
		x(i-50) = batch('simulate', 0, {configfiles{i}});
end
