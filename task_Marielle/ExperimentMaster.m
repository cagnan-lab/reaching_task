clear; clc; close all;
%% Main experiment
%% Setup Paths for experiment
addpath([cd '\labjack_commands'])
% addpath('C:\Users\marie\OneDrive\Documenten\Oxford\WindowsAPI')
addpath('C:\Users\timot\Documents\Work\MATLAB ADDONS\WindowAPI')
addpath(genpath([cd '/task_Marielle']))
addpath([cd '\testData'])
addpath([cd '\leapmotion\worksforMar\LeapSDK'])

%% Specify Subject Specific ID
id = 'TIMSCOMPUTER';

%% Calibrate the LeapMotion to Screen Space
% basic_8pnt_calibration(id)

% Determine random order of conditions:
condition = randperm(4);
condition = 4; %[3 4];
ntrials = 5; % Number of reaching trials


for block = 1:4
%     PostureHold(id,block,15)
%     close all;
%     pause
%     Rest(id,block,15)
%     close all;
%     pause
    runBlock_FillingVariant(condition(block),id,block,ntrials)
    close all;
    pause

%     pause()
    
end
