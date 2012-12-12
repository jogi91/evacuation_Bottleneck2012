%matlabpool open 4;
n = 11


for i=1:n
	configfiles{i} = sprintf('../data/costa_voyager_%d.conf', i);
end

for i=1:n
	sprintf('simulate(%s)',configfiles{i})
	x(i) = batch('simulate', 0, {configfiles{i}});
end
