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
labjack         = '0';          % 1 = Connected, 0 = Not Connected              bool
tick            = '0';          % 1 = Connected, 0 = Not Connected              bool
pointervisible  = '1';          % 1 = Visible, 0 = Not Visible                  bool 
reaches         = '5';          % Amount of Reaches per Trial                   int
condinfo        = '2';          % Seconds of showing Condition Information      float
posturalhold    = '10';         % Seconds of PosturalHold Task                  float
rest            = '10';         % Seconds of Rest Task                          float 
posturestart    = '2';          % Seconds of Postural Hold before Trials        float
reachwait       = '2.5';        % Seconds etc... 
prepwait        = '2.5';
delaywait       = '3.5';
holdwait        = '4';
colorduration   = '3';          % Seconds of
% balloonsize     = '20';

confpath = ([subjectpath '\Configuration']);
mkdir(confpath)
configuration(confpath, labjack, tick, pointervisible, reaches, condinfo, posturalhold, rest, posturestart, reachwait, prepwait, delaywait, holdwait, colorduration)

%% Calibrate the LeapMotion to Screen Space
uiopen([cd '\Unity Builds\Calibration\Calibration.exe'],1)
close all;
pause

%% Run Conditions

for rep = 1:2
    % Determine random order of conditions:
    condition = randperm(4);
    
    for block = 1:4
        cond = condition(block);
        % Made ConditionID path
        CURRID = [subcode '_Condition_' num2str(cond) '_Rep_' num2str(rep)];
        fileID = fopen([confpath '\CURRID.txt'],'w');
        fprintf(fileID,CURRID);
        fclose(fileID);
        pause 
%         %     PostureHold(id,block,15)
        uiopen([cd '\Unity Builds\PosturalHold\PosturalHold.exe'],1)
        close all;
        pause
%         %     Rest(id,block,15) 
        uiopen([cd '\Unity Builds\Rest\Rest.exe'],1)
        close all;
        pause
        
        if cond == 1
            uiopen([cd '\Unity Builds\Condition 1\Condition 1.exe'],1)
        elseif cond == 2
            uiopen([cd '\Unity Builds\Condition 2\Condition 2.exe'],1)
        elseif cond == 3
            uiopen([cd '\Unity Builds\Condition 3\Condition 3.exe'],1)
        elseif cond == 4
            uiopen([cd '\Unity Builds\Condition 4\Condition 4.exe'],1)
        end
        
        trialComments = input('Any comments?:    ','s');
        fileCOMMENTS = fopen([subjectpath '\' CURRID '\' subcode '_TrialComments.txt'],'w');
        fprintf(fileCOMMENTS,trialComments);
        fclose(fileCOMMENTS);
                
        pause
        clear CURRID
    end
end
