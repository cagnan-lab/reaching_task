clear; close all; clc;

% Add paths!
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Spike-smr-reader\smrReader');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\fieldtrip-20191208');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\Leapmotion Data\ms_pilot_test_firstHalf');  % LeapMotion Matlab

% Amplifier data (SMR):
SMR_data = LoadSMR();
SMR_timevec = TimeSMR(SMR_data);
SMR_coder = CoderSMR(SMR_data);
CVM = calicoder(SMR_coder);          % This function requires manually extract timings to determine # trial stages

% Define type of trial:
Rest = [1,3,9];
Posture = [2,5];
Movement = [4, 6:8, 10:14];

% Decoder only for Movement Trials:
[decoder,SMRtrialdef] = codetimings(CVM, SMR_coder(Movement,2));

% Needed because coding is not yet perfect:
naming = {'MS_7' 'MS_9' 'MS_10' 'MS_11' 'MS_13' 'MS_14' 'MS_15' 'MS_16' 'MS_17'};
for i = 1:length(naming)
load(['C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot\PilotMotorPrep_' naming{1, i}], ['MotorPrep_' naming{1, i}]);
end


% Matlab data (ML):
ML_data = LoadML();

