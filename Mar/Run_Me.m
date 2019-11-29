
t = 0;

while t < inf
    
    
    
    
    
    
% ---- Experiment
condition = randi(4)
    
    
% ---- LapJack Setup:
[ljasm,ljudObj,ljhandle] = setup_LabJack()

    % Conditions:   4
    % Trials:       15
    % States:       5 (Rest, Wing Beating Posture, Reach, Motor Preparation, Motor Execution)
v.one =   reshape(linspace(0.5,3,75),5,15);
v.two =   reshape(linspace(0.5,3,75),5,15);
v.three = reshape(linspace(0.5,3,75),5,15);
v.four =  reshape(linspace(0.5,3,75),5,15);
channel = 1;

if condition == 1
    v = v.one
elseif condition == 2
    v = v.two
elseif condition == 3
    v = v.three
elseif condition ==4
    v = v.four

    
    
    t = t+1
end

