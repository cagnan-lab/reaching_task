clear; clc; close all;
%% Main experiment
%% Setup Paths for experiment
% addpath([cd '\labjack_commands'])
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\WindowsAPI')
% addpath('C:\Users\Tim\Documents\MATLAB_ADDONS\WindowAPI')
addpath(genpath([cd '/task_Marielle']))
addpath([cd '\testData'])
addpath([cd '\leapmotion\worksforMar\LeapSDK'])
desktoppath =winqueryreg('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 'Desktop');

%% Specify Subject Specific ID
subcode = 'MS';

subjectpath = ([desktoppath '\OPM\' subcode]);
mkdir([subjectpath '\' subcode '_Calibration'])

fileSUBCODE = fopen([desktoppath '\OPM\SUBCODE.txt'],'w');
fprintf(fileSUBCODE,subcode);
fclose(fileSUBCODE);

%% Configuration file
tracking        = '0';          % 0 = Index Finger Tip, 1 = Palm Pos, (2 = Stab Palm Pos)	bool
labjack         = '0';          % 1 = Connected, 0 = Not Connected                          bool
tick            = '0';          % 1 = Connected, 0 = Not Connected                          bool
pointervisible  = '1';          % 1 = Visible, 0 = Not Visible                              bool
reaches         = '20';         % Amount of Reaches per Trial                               int
% uncertainty     = '2';          % 0 = one Arrow, 1 = four Arrows, 2 = eight Arrows          bool
condinfo        = '5';          % Seconds of showing Condition Information                  float
breakreaches    = '10';         % Amount of Continuous Reaches before break                 int
breakwait       = '5';          % Seconds of break after 10 reaches                         float
posturalhold    = '10';         % Seconds of PosturalHold Task                              float
rest            = '10';         % Seconds of Rest Task                                      float
posturestart    = '5';          % Seconds of Postural Hold before Trials                    float
reachwait       = '2.5';        % Seconds of Reach Wait                                     float
prepwait        = '2.5';        % Seconds of Motor Preparation Wait                         float
delaywait       = '3.5';        % Seconds of Motor Execution Wait GBYK                      float
holdwait        = '4';          % Seconds of Motor Execution Wait GAYK                      float
colorduration   = '1.5';        % Time in which balloon turns green if right position       float
% balloonsize     = '20';         % In case we want adjustable balloon size at some point     float

confpath = ([subjectpath '\Configuration']);
mkdir(confpath)
configuration(confpath, tracking, labjack, tick, pointervisible, reaches, condinfo, breakreaches, breakwait, posturalhold, rest, posturestart, reachwait, prepwait, delaywait, holdwait, colorduration)

%% Calibrate the LeapMotion to Screen Space
uiopen([cd '\Unity Builds\11.03\Calibration\Calibration.exe'],1)
close all;

%% Run Conditions

for rep = 1:2
    % Determine random order of conditions:
    condition = randperm(4);
    
    for block = 1:4
        cond = condition(block);
        
        % Save Condition in Configuration: 
        fileCONDITION = fopen([confpath '\CONDITION.txt'],'w');
        fprintf(fileCONDITION,num2str(cond));
        fclose(fileCONDITION);
        
        % Made ConditionID path
        currid = [subcode '_Condition_' num2str(cond) '_Rep_' num2str(rep)];
        fileCURRID = fopen([confpath '\CURRID.txt'],'w');
        fprintf(fileCURRID,currid);
        fclose(fileCURRID);
        
        disp(['Press to start Condition ', num2str(cond)])
        pause
        uiopen([cd '\Unity Builds\11.03\ConditionsBetter\AllConditionsBetter.exe'],1)
        close all;
        
        trialComments = input('Any comments?:    ','s');
        fileCOMMENTS = fopen([subjectpath '\' CURRID '\' subcode '_TrialComments.txt'],'w');
        fprintf(fileCOMMENTS,trialComments);
        fclose(fileCOMMENTS);
        
        pause
        clear CURRID
    end
end
