clear; clc; close all;
%% Main experiment
%% Setup Paths for experiment
addpath([cd '/labjack_commands'])
% addpath('C:\Users\marie\OneDrive\Documenten\Oxford\WindowsAPI')
addpath('C:\Users\timot\Documents\Work\MATLAB ADDONS\WindowAPI')

addpath(genpath([cd '/task_Marielle']))
addpath([cd '/testData'])
addpath([cd '\leapmotion\worksforMar\LeapSDK'])
%% Specify Subject Specific ID
id = 'TW';

%% Calibrate the LeapMotion to Screen Space
%basic_8pnt_calibration(id)

% Determine random order of conditions:
condition = 1:4; %randperm(2);                % Make 4 if go before you know is included
% % condition = [3 4];
ntrials = 3; % Number of reaching trials


for block = 1:4
    block_id = [id '_block' num2str(block)];
    runBlock_FillingVariant(condition(block),block_id,ntrials)
    Rest(block_id)
    pause()
    WingBeating(block_id)
end
