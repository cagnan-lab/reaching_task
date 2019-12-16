clear; clc; close all;
%% Main experiment
%% Setup Paths for experiment
addpath([cd '\labjack_commands'])
% addpath('C:\Users\marie\OneDrive\Documenten\Oxford\WindowsAPI')
addpath('C:\Users\Tim\Documents\MATLAB_ADDONS\WindowAPI')
addpath(genpath([cd '/task_Marielle']))
addpath([cd '\testData'])
% addpath([cd '\leapmotion\worksforMar\LeapSDK'])

%% Specify Subject Specific ID
id = 'ms_pilot_test_firstHalf';

%% Calibrate the LeapMotion to Screen Space
% basic_8pnt_calibration(id)

% Determine random order of conditions:
condition = randperm(4);
ntrials = 5; % Number of reaching trials


for block = 1:8
    PostureHold(id,block,60)
    close all;
    pause
    Rest(id,block,60)
    close all;
    pause
    runBlock_FillingVariant(condition(block),id,block,ntrials)
    close all;
    pause

%     pause()
    
end
