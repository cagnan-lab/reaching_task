clear; close all; clc;

%%% what do we want:
% get ready:2s
% rest: 20sec
% point centre #1: 20 sec
% point targets: alternate 4 targets (5sec*4) + 4 centres (5sec*4) =40sec
% point centre #2: 5 sec
%%% note: point centre #1 and #2 to alternate

%% Setup LabJack for triggers
% [ljasm,ljudObj,ljhandle] = setup_LabJack();

% v=reshape(linspace(0.5,3,24),3,8); % 3x8 targets (2 sizes + 1 command x 8 positions) = 24;%

% Reaching Task Master Script
[dpath,gpath] = add_ReachingTask_paths();
% Setup Images
baseTar = {
    [gpath '/reaching_task/task_images/targets1/fixation_cross_targets.bmp'];...
    [gpath '/reaching_task/task_images/targets1/0_0_0_0_targets.bmp'];...
    };
selTar = {
    {[gpath '/reaching_task/task_images/ind_targets/ind_tar_10000000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_01000000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00100000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00010000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00001000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00000100.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00000010.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00000001.png']};...
    
    {[gpath '/reaching_task/task_images/ind_targets/ind_tar_20000000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_02000000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00200000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00020000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00002000.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00000200.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00000020.png'];...
    [gpath '/reaching_task/task_images/ind_targets/ind_tar_00000002.png']};...
    };
% indTar = {
%     [gpath '/reaching_task/task_images/indicators/1_0_0_0_indicator.bmp'];...
%     [gpath '/reaching_task/task_images/indicators/0_1_0_0_indicator.bmp'];...
%     [gpath '/reaching_task/task_images/indicators/0_0_1_0_indicator.bmp'];...
%     [gpath '/reaching_task/task_images/indicators/0_0_0_1_indicator.bmp'];...
%     };

% Timer
tic


%% Show strings until pressing any key

% Give quick recap of instructions and wait for input
txt_instructions = {'Start of first session!!!';
    'In this session you are asked to rest, reach and point.';
    'When you see the cross in the centre please REST.';
    'When you see a cross surrounded by red targets please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};

figure('menubar','none', 'position', [200 200 900 600]);

% Waiting for key presses: matlab "pause"
for i=1:5
    ah = gca;
    th = text(1,1,txt_instructions{i}, 'FontSize', 25);
    set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    pause
    delete(th);
end


%% Start main experiment

% Setup number of trials
ntrials = 2;
% Setup random vector of targets
tarlist = randi(12,1,ntrials);

t_target = zeros(3,2);      % As long as there are amount of targets and as much as there are trials
t_center = zeros(3,2);
t_base = zeros(1,2);        % As much as there are trials

for i = 1:ntrials
    
    % restst = [20 5]; ?
    ah = gca;
    th = text(1,1,['Trial ' num2str(i) '. Get ready to reach!!!'], 'FontSize', 40);
    set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    pause(2)                    % Display for 5 sec
    delete(th);

    % Fixation Cross (for Rest)
    img_base = baseTar{1,1}; 
    imshow(img_base);           % Display fixation cross
    t_base(1,i) = toc;
    pause(2)                    % Display fixation point for 5 sec
    clf;                        % Clear image from figure
    
    for trn = 1:3                       % amount of targets displayed
        
        % Center Target for Starting position
        img_center = baseTar{2,1}; 
        imshow(img_center);
        t_center(trn,i) = toc;
        pause(2 + 1.*(2.*randn));       % Adding variation in the waiting above 6 sec ??
        
%         sendLJTrigger(ljudObj,ljhandle,v(sz,p));
        
        % Target Display
        sz  =  randi(2);                % target size either small (2) or big (1inftria)
        p   =  randi(8);                % target position one out of 8 positions (45 degrees angles)
        img_target = selTar{sz}{p};     % Random target Choice
        imshow(img_target)
        t_target(trn,i) = toc;
        pause(2)                        % Display for 4 sec
        clf;
        
%         sendLJTrigger(ljudObj,ljhandle,v(3,2));

%         sz_p{1, i} = [0 0 t_base];               % Timing of base target
%         sz_p                                     % Timing of center target
         sz_p{trn, i} = [sz p];        % To know which targets are shown each trial
         % trial.a = [1 8 i]; gives struct with i working!
    end
clf;
%     sendLJTrigger(ljudObj,ljhandle,v(3,3));

ah = gca;
th = text(1,1,'End of trial, take a break...', 'FontSize', 40);
set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');

    disp(['Trial number ' num2str(i)])
    disp(['Elapsed time after trial ' num2str(i) ' is ' num2str(toc)])

pause               % Continue to next trial when participant presses a key
delete(th);

end

toc