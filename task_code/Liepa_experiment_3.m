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

%% Setup LabJack for triggers
[ljasm,ljudObj,ljhandle] = setup_LabJack();

v = [0.5 0.7 0.9 1 1.2 1.5 1.7 2 2.2 2.5 2.7 3]; % (1) At rest; (2) sd01; (3) sd02; (4) sd03; (5) sd04; (6) sd05; (7) sd06; (8) sd07 (9) sd08; (10) sd09; (11) sd10; (12) sd11;

% Setup Images

selTar = {
    [gpath '\reaching_task\task_Liepa\fixation_cross.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_01.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_02.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_03.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_04.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_05.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_06.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_07.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_08.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_09.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_10.bmp'];...
    [gpath '\reaching_task\task_Liepa\spiral_drawing_11.bmp'];...
     };
 
% Setup LabJack for triggers
[ljasm,ljudObj,ljhandle] = setup_LabJack();

% Setup Display
% config_display(1, 6, [0 0 0], [1 1 1], 'Helvetica', 50, 4, 24);
config_display(0,6, [1 1 1],[0 0 0])
config_keyboard( 100, 5, 'nonexclusive')
config_log( 'reachingTask.log' ); % Configur     e log file
start_cogent;

%% Welcome String
txt_welcomeStr = 'Start of first session!!!';
preparestring( txt_welcomeStr, 2 ); % Put word in buffer 2
% Draw Welcome Text
t0 = drawpict( 2 );
waituntil( t0 + 2000 );
    clearpict( 2 );

% Give quick recap of instructions and wait for input
txt_instructions = {'In this session you are asked to rest, reach and point to trace the spiral.';
    'When you see the cross in the centre please REST.';
    'When you see a cross and a black line please REACH.';
    'As the spiral starts to form, please REACH and trace it as accurately as you can!';
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

% SHow Fixation Cross
clearpict( 1 );
loadpict( selTar{1}, 1 );
t = drawpict( 1 ); % Display fixation cross
sendLJTrigger(ljudObj,ljhandle,v(1));

waituntil( t + 3000 );

% Loads Picture and Shows
N = 2; % This is the number of images you want to load
for p = 2:12
clearpict( 1 );
loadpict( selTar{p}, 1 );
t = drawpict( 1 ); % Display fixation cross
sendLJTrigger(ljudObj,ljhandle,v(p));
waituntil( t + 500 );
end

stop_cogent;




