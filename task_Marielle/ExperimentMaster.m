clear; clc; close all;
%% Main experiment
%% Setup Paths for experiment
addpath([cd '\labjack_commands'])
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\WindowsAPI')
% addpath('C:\Users\timot\Documents\Work\MATLAB ADDONS\WindowAPI')
addpath(genpath([cd '/task_Marielle']))
addpath([cd '\testData'])
addpath([cd '\leapmotion\worksforMar\LeapSDK'])

%% Specify Subject Specific ID
id = 'MS';

%% Calibrate the LeapMotion to Screen Space
% basic_8pnt_calibration(id)

% Determine random order of conditions:
condition = randperm(4);
% condition = [3 4];
ntrials = 5; % Number of reaching trials


for block = 1:4
    block_id = [id '_block' num2str(block)];
    %PostureHold(block_id,15)
    %Rest(block_id,15)
    runBlock_FillingVariant(condition(block),block_id,ntrials)
    
%     pause()
    
end
