clear; close all; clc;

R = add_ReachingTask_paths([1 2]);

%% Setup data organization
% R.expSet.seshnums = {[7,9,14,15,17],[10,11,13,16]}; % choose sessions (divide in conditions)
% R.expSet.seshnums = {[9,17],[11,16]}; % Only GBYK sessions
% R.expSet.seshnames = {'Low Prec','High Prec'}; % condition names
% R.expSet.prefix = 'PrecCTRT';

R.expSet.seshnums = {[7,10,13,14,15],[9,11,16,17]}; % choose sessions (divide in conditions)
R.expSet.seshnames = {'GAYK','GBYK'}; % condition names
R.expSet.prefix = 'ExecCTRT';

R.expSet.stagenames = {'MotorPrep','MotorExec','transition'}; % names of stages of experiment of interest

%% Choose steps to execute:
% (1) Data loading and conversion
% (2) Trial decoding
% (3) Data preprocessing and trial definition
% (4) Steady state spectral analysis
pipelineSteps = [1,3,4,5];



%% Execute Steps
for ps = pipelineSteps 
    switch ps
        case 1 % Load Data and Save to Fieldtrip format
            
            SMR2FT_flag = 1;
            FTSave_flag = 1;
            SMR_data = LoadSMR_TW(R,1,1);
            %ML_data = LoadML(R);
            
        case 2 % Decoding
            % This is a good place to do the decoding
            % CVM = calicoder(SMR_coder);          % This function requires manually extract timings to determine # trial stages
            
        case 3 % Make Data Structure
            % But for now just use the user defined trialdefs
            % Compile the trialdef structure to be used for fieldtrip redefine trial
            makeDataSets_MS(R)
        case 4 % Steady State Spectral Analyses
            steadyStateSpectralAnalysis(R)
        case 5 % Time Frequency
            timeFreqAnalysis(R)
    end
end

%%

% Add paths!
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Spike-smr-reader\smrReader');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\fieldtrip-20191208');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\Leapmotion Data\ms_pilot_test_firstHalf');  % LeapMotion Matlab

% Amplifier data (SMR):
SMR_data_MS = LoadSMR();
SMR_timevec = TimeSMR(SMR_data_MS);
SMR_coder = CoderSMR(SMR_data_MS);
CVM = calicoder(SMR_coder);          % This function requires manually extract timings to determine # trial stages

% Matlab data (ML):
ML_data = LoadML();

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

naming1 = {'MS_10' 'MS_11' 'MS_13' 'MS_14' 'MS_15'};
for i = 1:length(naming1)
load(['C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot\PilotMotorExec_' naming1{1, i}], ['MotorExec_' naming1{1, i}]);
end

