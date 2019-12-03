clear; clc; close all;
%% Main experiment
%% Setup Paths for experiment
addpath([cd '/labjack_commands'])
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\WindowsAPI')
addpath(genpath([cd '/task_Marielle']))
addpath([cd '\leapmotion\worksforMar\LeapSDK'])
%% Specify Subject Specific ID
id = 'MS';

%% Calibrate the LeapMotion to Screen Space
%basic_8pnt_calibration(id)

% Determine random order of conditions:
condition = randperm(2);                % Make 4 if go before you know is included

for block = 1:4
    runBlock(condition(block),id)
end
