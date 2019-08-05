%%% what do we want:
% get ready:2s
% rest: 20sec
% point centre #1: 20 sec
% point targets: alternate 4 targets (5sec*4) + 4 centres (5sec*4) =40sec
% point centre #2: 5 sec
%%% note: point centre #1 and #2 to alternate

% Reaching Task Master Script
% gpath = 'C:\Users\creis\Documents\GitHub';
% gpath = 'C:\Users\Tim\Documents\Work\GIT';
gpath = 'C:\Users\pb-lab\Desktop';
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
    [gpath '\reaching_task\task_images\targets\0_0_0_0_targets.bmp'];...
    };
indTar = {
    [gpath '\reaching_task\task_images\indicators\1_0_0_0_indicator.bmp'];...
    [gpath '\reaching_task\task_images\indicators\0_1_0_0_indicator.bmp'];...
    [gpath '\reaching_task\task_images\indicators\0_0_1_0_indicator.bmp'];...
    [gpath '\reaching_task\task_images\indicators\0_0_0_1_indicator.bmp'];...
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
    waituntil( t(1) + 10000 ); % Display fixation point for 1000ms
    
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 10000 ); % Display fixation point for 1000ms
    

    % Target Choice
    clearpict( 4 );
    loadpict( selTar{tarlist(i)}, 4 );
    t(3) = drawpict( 4 ); % Display word and get the time
    waituntil(t(3)+ 1000 );
    
    % Centre
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 1000 ); % Display fixation point for 1000ms  
    
    % Target Choice
    clearpict( 4 );
    p =  randi(4,1,1);
    loadpict( selTar{p}, 4 );
    t(4) = drawpict( 4 ); % Display word and get the time
    waituntil(t(4)+ 1000 );
   
    % Centre
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 1000 ); % Display fixation point for 1000ms  
    
    clearpict( 4 );
    p = randi(4,1,1);
    loadpict( selTar{p}, 4 );
    t(5) = drawpict( 4 ); % Display word and get the time
    waituntil(t(5)+ 1000 );
    
    % Centre
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 1000 ); % Display fixation point for 1000ms     
    
    clearpict( 4 );
    p = randi(4,1,1);
    loadpict( selTar{p}, 4 );
    t(6) = drawpict( 4 ); % Display word and get the time
    waituntil(t(6)+ 1000 );    
    
    % Centre
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 1000 ); % Display fixation point for 1000ms  
    
    clearpict( 4 );
    p = randi(4,1,1);
    loadpict( selTar{p}, 4 );
    t(7) = drawpict( 4 ); % Display word and get the time
    waituntil(t(7)+ 1000 );  
    
    % Centre
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 1000 ); % Display fixation point for 1000ms  
    
    clearpict( 4 );
    p = randi(4,1,1);
    loadpict( selTar{p}, 4 );
    t(8) = drawpict( 4 ); % Display word and get the time
    waituntil(t(8)+ 1000 ); 
    
    disp(['Trial number ' num2str(i)])
end
stop_cogent;