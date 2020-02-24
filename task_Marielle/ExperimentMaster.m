% clear; clc; close all;
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
    mkdir([desktoppath '\OPM\Calibration_' subcode])

for i = 1:4
    mkdir([desktoppath '\OPM\Condition_' num2str(i) '_' subcode])
end

%% Calibrate the LeapMotion to Screen Space
% uiopen([cd '\Unity Builds\New folder\Point and Shoot.exe'],1)

for rep = 1:2
    % Determine random order of conditions:
    condition = [1 2 3 4]; %randperm(4);
    
    for block = 1; %:4
        cond = condition(block);
        % Made ID file
        ID = [subcode '_cond' num2str(cond) '_rep' num2str(rep)];
        fileID = fopen([desktoppath '\OPM\CURRID.txt'],'w');
        fprintf(fileID,ID);
        fclose(fileID);
        
        %     PostureHold(id,block,15)
        close all;
        pause
        %     Rest(id,block,15)
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
        
        pause
        blockComments = input('Any comments?:    ','s');
        fileID = fopen([desktoppath '\OPM\Condition_' num2str(i) '_' subcode '\blockComments_' ID '.txt'],'w');
        fprintf(fileID,ID);
        fclose(fileID);
        pause
        clear ID
    end
end
