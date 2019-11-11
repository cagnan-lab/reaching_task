%%% what do we want:
% get ready:2s
% rest: 20sec
% point centre #1: 20 sec
% point targets: alternate 4 targets (5sec*4) + 4 centres (5sec*4) =40sec
% point centre #2: 5 sec
%%% note: point centre #1 and #2 to alternate

%% Setup LabJack for triggers
% [ljasm,ljudObj,ljhandle] = setup_LabJack();

v=reshape(linspace(0.5,3,24),3,8); % 3x8 targets (2 sizes + 1 command x 8 positions) = 24;%

% Reaching Task Master Script
%  gpath = 'C:\Users\creis\Documents\GitHub';
% gpath = 'C:\Users\Tim\Documents\Work\GIT';
[dpath,gpath] = add_ReachingTask_paths();
% Setup Images
baseTar = {
    [gpath '\reaching_task\task_images\targets1\fixation_cross_targets.bmp'];...
    [gpath '\reaching_task\task_images\targets1\0_0_0_0_targets.bmp'];...
    };
selTar = {
    {[gpath '\reaching_task\task_images\ind_targets\ind_tar_10000000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_01000000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00100000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00010000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00001000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00000100.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00000010.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00000001.png']};...
    
    {[gpath '\reaching_task\task_images\ind_targets\ind_tar_20000000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_02000000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00200000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00020000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00002000.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00000200.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00000020.png'];...
    [gpath '\reaching_task\task_images\ind_targets\ind_tar_00000002.png']};...
    };
indTar = {
    [gpath '\reaching_task\task_images\indicators\1_0_0_0_indicator.bmp'];...
    [gpath '\reaching_task\task_images\indicators\0_1_0_0_indicator.bmp'];...
    [gpath '\reaching_task\task_images\indicators\0_0_1_0_indicator.bmp'];...
    [gpath '\reaching_task\task_images\indicators\0_0_0_1_indicator.bmp'];...
    };

% Setup Display
tic


%% Welcome String
txt_welcomeStr = 'Start of first session!!!';               % Look for basic matlab
preparestring( txt_welcomeStr, 2 ); % Put word in buffer 2
% Draw Welcome Text
t0 = drawpict( 2 );             % t0 = toc
waituntil( t0 + 2000 );         % toc is in seconds. t0 + 20
clearpict( 2 );

%% show some strings and bijbehorende timings

% Give quick recap of instructions and wait for input
txt_instructions = {'In this session you are asked to rest,reach and point.';
    'When you see the cross in the centre please REST.';
    'When you see a cross surrounded by red targets please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};

% Waiting for key presses: matlab "pause"
for i=1:5
    preparestring( txt_instructions{i}, 4 );
    % Draw Welcome Text
    t0 = drawpict( 4 );
    waitkeydown(t0+20000,71)
    clearpict( 4 );
end
txt_reach = 'Get ready to reach!!!';
preparestring( txt_instructions{i}, 5 );

%% main experiment start

% Setup rng seed (so to make reproducible sequence)
rng(14231)
% Setup number of trials
ntrials = 10;
% Setup random vector of targets
tarlist = randi(12,1,ntrials);

for i = 1 %:ntrials
    
    restst = [20 5];
    
    % Fixation Cross (for Rest)
    t(1) = drawpict( 1 ); % Display fixation cross
%     sendLJTrigger(ljudObj,ljhandle,v(3,1));
    waituntil( t(1) + restst(1)*1e3 ); % Display fixation point for 1000ms
    
    
    for trn = 1:15
        % Target Choice
        clearpict( 4 );
        sz =  randi(2,1,1);
        p =  randi(8,1,1);
        loadpict( selTar{sz}{p}, 4 );
        t(4) = drawpict( 4 );
        
%         sendLJTrigger(ljudObj,ljhandle,v(sz,p));
        waituntil(t(4)+ 3000 );
        
        % Centre Target
        t(2) = drawpict( 1 );
%         sendLJTrigger(ljudObj,ljhandle,v(3,2));
        waituntil( t(2) + 6000 + 1000.*(2.*randn)); % 6 seconds plus/min 2 (STD)
    end
    
%     sendLJTrigger(ljudObj,ljhandle,v(3,3));
    txt_trialEnd = 'End of trial, take a break...';
    preparestring( txt_trialEnd, 2 );
    t0 = drawpict( 2 );
    waituntil( t0 + 1000);
    disp(['Trial number ' num2str(i)])
end
stop_cogent;
toc