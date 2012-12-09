function data = plotExitedAgents(config, data)
% Plots the time series of the exit occupations.

figure;

for i = 1 : data.num_exits
    subplot(data.num_exits, 1, i);
    axis([0 data.finish_time 0 config.exit_capacities(i)]);
    plot(data.agents_exited_time_series(:,1), ...
         data.agents_exited_time_series(:,1+i));
    xlabel('time [s]');
    ylabel('# agents');
    title(sprintf('Agents on boat %i', i));
end

end
