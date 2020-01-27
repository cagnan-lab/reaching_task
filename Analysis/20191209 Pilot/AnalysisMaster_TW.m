clear; close all
R = add_ReachingTask_paths([1 2]);

%% Setup data organization
% R.expSet.seshnums = {[7,9,14,15,17],[10,11,13,16]}; % choose sessions (divide in conditions)
% R.expSet.seshnames = {'Low Prec','High Prec'}; % condition names
% R.expSet.prefix = 'PrecCTRT';

R.expSet.seshnums = {[7,10,13,14,15],[9,11,16,17]}; % choose sessions (divide in conditions)
R.expSet.seshnames = {'GAYK','GBYK'}; % condition names
R.expSet.prefix = 'ExecCTRT';

R.expSet.stagenames = {'MotorPrep','MotorExec'}; % names of stages of experiment of interest

%% Choose steps to execute:
% (1) Data loading and conversion
% (2) Trial decoding
% (3) Data preprocessing and trial definition
% (4) Steady state spectral analysis
pipelineSteps = [3,4,5];


%% Execute Steps
for ps = pipelineSteps 
    switch ps
        case 1 % Load Data and Save to Fieldtrip format
            
            SMR2FT_flag = 1;
            FTSave_flag = 1;
            SMR_data = LoadSMR_TW(R,1,1);
            
        case 2 % Decoding
            % This is a good place to do the decoding
            % CVM = calicoder(SMR_coder);          % This function requires manually extract timings to determine # trial stages
            
        case 3 % Make Data Structure
            % But for now just use the user defined trialdefs
            % Compile the trialdef structure to be used for fieldtrip redefine trial
            makeDataSets(R)
        case 4 % Steady State Spectral Analyses
            steadyStateSpectralAnalysis(R)
        case 5 % Time Frequency
            timeFreqAnalysis(R)
    end
end