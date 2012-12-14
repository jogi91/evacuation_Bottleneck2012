function data = plotExitedAgents(config, data)
% Plots the time series of the exit occupations.

% Plot separate exits:
for i = 1 : data.num_exits
%     subplot(data.num_exits, 1, i);
    figure;
    axis([0 data.finish_time 0 config.exit_capacities(i)]);
    plot(data.agents_exited_time_series(:,1), ...
         data.agents_exited_time_series(:,1+i));
    xlabel('time [s]');
    ylabel('# agents');
    title(sprintf('Agents on boat %i', i));
    print('-depsc2', sprintf('frames/%s_exit_occupation_%d.eps', ...
                             data.frame_basename, i));
end

% Plot totals:
figure;
axis([0 data.finish_time 0 config.exit_capacities(i)]);
plot(data.agents_exited_time_series(:,1), ...
     sum(data.agents_exited_time_series(:,2:data.num_exits+1), 2));
xlabel('time [s]');
ylabel('# agents');
title('Total number of agents on boats');
print('-depsc2', sprintf('frames/%s_exit_occupation_total.eps', ...
                         data.frame_basename));


end
