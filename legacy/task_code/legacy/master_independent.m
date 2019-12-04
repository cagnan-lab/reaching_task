%%% what do we want:
% get ready:2s
% rest: 20sec
% point centre #1: 20 sec
% point targets: alternate 4 targets (5sec*4) + 4 centres (5sec*4) =40sec
% point centre #2: 5 sec
%%% note: point centre #1 and #2 to alternate

%% Setup LabJack for triggers
% [ljasm,ljudObj,ljhandle] = setup_LabJack();

% v=reshape([0.2:0.2:3],5,3);
% v = [0.5 1 2 2.25 2.5 2.75 3]; % (1) At rest; (2) Reach; (3) Centre; (4) 1 0 0 0; (5) 0 1 0 0; (6) 0 0 1 0; (7) 0 0 0 1;

% Reaching Task Master Script
% gpath = 'C:\Users\creis\Documents\GitHub';
% gpath = 'C:\Users\Tim\Documents\Work\GIT';
 gpath = add_ReachingTask_paths();
% Setup Images
baseTar = {
    [gpath '\reaching_task\task_images\targets1\fixation_cross_targets.bmp'];...
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
loadpict( baseTar{1}, 3 );

%% Welcome String
txt_welcomeStr = 'Start of first session!!!';
preparestring( txt_welcomeStr, 2 ); % Put word in buffer 2
% Draw Welcome Text
t0 = drawpict( 2 );
waituntil( t0 + 2000 );
clearpict( 2 );

% Give quick recap of instructions and wait for input
txt_instructions = {'In this session you are asked to rest,reach and point.';
    'When you see the cross in the centre please REST.';
    'When you see a cross surrounded by red targets please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};
for i=1:5
    preparestring( txt_instructions{i}, 4 );
    % Draw Welcome Text
    t0 = drawpict( 4 );
    waitkeydown(t0+20000,71)
    clearpict( 4 );
end
txt_reach = 'Get ready to reach!!!';
preparestring( txt_instructions{i}, 5 );

% Setup rng seed (so to make reproducible sequence)
rng(14231)
% Setup number of trials
ntrials = 10;
% Setup random vector of targets
tarlist = randi(4,1,ntrials);

for i = 1:ntrials

    
%     if 1 %rand>=0.5
%         restst = [20 5];
%     else
%         restst = [5 20];
%     end

restst = 10;
    
    % Fixation Cross (for Rest)
    t(1) = drawpict( 1 ); % Display fixation cross
    %sendLJTrigger(ljudObj,ljhandle,v(1));
    waituntil( t(1) + restst(1)*1e3 ); % Display fixation point for 1000ms
    
%     % Load Point Target
%     loadpict( selTar{5,sz}, 4 );
%     t(2) = drawpict( 4 ); % Display target
%     %sendLJTrigger(ljudObj,ljhandle,v(2));
%     waituntil( t(2) + 20000 ); % Display  target for 1000ms
%     %sendLJTrigger(ljudObj,ljhandle,0);
    
    % Prepare to reach
%     t(5) = drawpict( 4 );
%     waituntil(t(5)+ 1000 );
    
    for trn = 1:8
  
        % Centre Target
%         loadpict( selTar{5,sz}, 4 );
%         t(2) = drawpict( 4 );
%         %sendLJTrigger(ljudObj,ljhandle,v(3));
%         waituntil( t(2) + 1000 );
        
        % Target Choice
        clearpict( 4 );
        p =  randi(8,1,1);
        loadpict( selTar{p}, 4 );
        t(4) = drawpict( 4 );
        %sendLJTrigger(ljudObj,ljhandle,v(3+p));
        waituntil(t(4)+ 1500 );
    end
    
    %sendLJTrigger(ljudObj,ljhandle,0);
    txt_trialEnd = 'End of trial, take a break...';
    preparestring( txt_trialEnd, 2 );
    t0 = drawpict( 2 );
    waituntil( t0 + 10000 );
    disp(['Trial number ' num2str(i)])
end
stop_cogent;