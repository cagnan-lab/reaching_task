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
gpath = add_ReachingTask_paths();

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

bindTar = {
    [gpath '\reaching_task\task_images\bindicators\2_0_1_0_bindicator.bmp'];...
    [gpath '\reaching_task\task_images\bindicators\0_2_0_1_bindicator.bmp'];...
    [gpath '\reaching_task\task_images\bindicators\1_0_2_0_bindicator.bmp'];...
    [gpath '\reaching_task\task_images\bindicators\0_1_0_2_bindicator.bmp'];...
    };
% Setup Display
% config_display(1, 6, [0 0 0], [1 1 1], 'Helvetica', 50, 4, 24);
config_display(0,6, [1 1 1],[0 0 0])
config_keyboard( 100, 5, 'nonexclusive')
config_log( 'reachingTask.log' ); % Configure log file
start_cogent;

% Fixation cross
clearpict( 1 );
loadpict( baseTar{1}, 1 );

% Target Selection
clearpict( 3 );
loadpict( baseTar{2}, 3 );

%% Welcome String
txt_welcomeStr = 'Start of first session!!!';
preparestring( txt_welcomeStr, 2 ); % Put word in buffer 1
% Draw Welcome Text
t0 = drawpict( 2 );
waituntil( t0 + 2000 );

% Give quick recap of instructions and wait for input
txt_instructions = {'In this session you are asked to rest,reach and point.';
    'When you see the cross in the centre please REST.';
    'When you see a cross surrounded by red targets please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};
for i=1:5
    preparestring( txt_instructions{i}, 4 ); % Put word in buffer 1
    % Draw Welcome Text
    t0 = drawpict( 4 );
    waitkeydown(t0+20000,71)
    clearpict( 4 );
end

% Setup rng seed (so to make reproducible sequence)
rng(14231)
% Setup number of trials
ntrials = 10;
% Setup random vector of targets
tarlist = randi(4,1,ntrials);
oplist = [3 4 1 2];

%% Start of Trials
for i = 1:ntrials
    % Fixation Cross
    t(1) = drawpict( 1 ); % Display fixation cross
    waituntil( t(1) + 10000 ); % Display fixation point for 1000ms
    
    loadpict( selTar{5}, 4 );
    t(2) = drawpict( 4 ); % Display word and get the time
    waituntil( t(2) + 10000 ); % Display fixation point for 1000ms
    
    for tp = 1:5
        % Target Range
        r = 1000; % + (1000.*randn(1));
        pt = randi(4,1,1);
        loadpict( bindTar{pt}, 4 );
        t(2) = drawpict( 4 ); % Display word and get the time
        waituntil( t(2)+ r);
        
        % Target Choice
        if rand>0.6
            dirchc = oplist(pt);
        else
            dirchc = pt;
        end
        
        clearpict( 4 );
        loadpict( selTar{dirchc}, 4 );
        t(3) = drawpict( 4 ); % Display word and get the time
        waituntil(t(3)+ 1000 );
    end
    disp(['Trial ' num2str(i)])
end
stop_cogent;