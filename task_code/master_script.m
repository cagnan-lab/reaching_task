% Reaching Task Master Script
gpath = 'C:\Users\creis\Documents\GitHub';
% Setup Images
baseTar = {
    [gpath '\reaching_task\task_images\targets\fixation_cross_targets.bmp'];...
    [gpath '\reaching_task\task_images\targets\0_0_0_0_targets.bmp'];...
    };
selTar = {
    [gpath '\reaching_task\task_images\targets\1_0_0_0_targets.bmp'];...
    [gpath '\reaching_task\task_images\targets\0_1_0_0_targets.bmp'];...
    [gpath '\reaching_task\task_images\targets\0_0_1_0_targets.bmp'];...
    [gpath '\reaching_task\task_images\targets\0_0_0_1_targets.bmp'];...
    };

% Setup Display
% config_display(1, 6, [0 0 0], [1 1 1], 'Helvetica', 50, 4, 24);
config_display(0,6, [1 1 1],[0 0 0])
config_log( 'reachingTask.log' ); % Configure log file
start_cogent;

% Fixation cross
clearpict( 1 );
loadpict( baseTar{1}, 1 );

% Target Selection
clearpict( 3 );
loadpict( baseTar{2}, 3 );

txt_welcomeStr = 'Get ready to reach!!!';
preparestring( txt_welcomeStr, 2 ); % Put word in buffer 1
% Draw Welcome Text
t0 = drawpict( 2 );
waituntil( t0 + 2000 );

% Setup rng seed (so to make reproducible sequence)
rng(14231)
% Setup number of trials
ntrials = 10;
% Setup random vector of targets
tarlist = randi(4,1,ntrials);

for i = 1:ntrials
    % Fixation Cross
    t(1) = drawpict( 1 ); % Display fixation cross
    waituntil( t(1) + 1500 ); % Display fixation point for 1000ms
    
    % Target Range
    t(2) = drawpict( 3 ); % Display target range
    
    % Target Choice
    r = randn(2500,1000,1);
    waituntil( t(2)+ r);
    clearpict( 4 );
    loadpict( selTar{tarlist(i)}, 4 );
    t(3) = drawpict( 4 ); % Display word and get the time
    waituntil(t(3)+ 2000 );
    
end
stop_cogent;