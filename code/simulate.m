function simulate(configFile)
%Get the Initial Values from a config file
%For now, they are still hard coded for simplicity
%They could be used, if no configFile was given as argument

%%%%%%%%%%%
%Variables%
%%%%%%%%%%%

%Timestep (in seconds)
dt = 0.1;
duration = 60;
time = 0;

%Initialize the environment

%Simulation loop
while(time<duration)


	time = time+dt;
end
%Output processing


