function R = add_ReachingTask_paths(pathtypes)
% Loads paths. Can choose which pathtypes you want: 1) stimuli paths; 2)
% analysis paths. e.g. add_ReachingTask_paths([1 2]) will load dependencies
% for both types.
if strcmp(getenv('COMPUTERNAME'),'SFLAP-2')
    R.paths.gitpath = 'C:\Users\Tim\Documents\Work\GIT\';
    R.paths.mapath = 'C:\Users\Tim\Documents\MATLAB_ADDONS\';
elseif strcmp(getenv('COMPUTERNAME'),'FREE')
    R.paths.gitpath = 'C:\Users\twest\Documents\Work\Github\';
    R.paths.mapath = 'C:\Users\twest\Documents\Work\MATLAB ADDONS\';
elseif strcmp(getenv('COMPUTERNAME'),'DESKTOP-94CEG1L')
    R.paths.gitpath = 'C:\Users\timot\Documents\GitHub\';
    R.paths.mapath = 'C:\Users\timot\Documents\Work\MATLAB ADDONS\';
    R.paths.datapath = 'D:\Data\OPM_Tremor_project\Pilot\MariellePilot_091219\';
    spmpath = [R.paths.gitpath '\spm12'];
else
    R.paths.gitpath = '/Users/mariellestam/Documents/TU Delft/Oxford/MATLAB/';
    R.paths.mapath = '/Users/mariellestam/Documents/TU Delft/Oxford/MATLAB/';
    datapath = [];
end

for i = pathtypes
    switch i
        case 1        % Task Design Paths
            addpath([R.paths.mapath 'Cogent2000v1.33/Samples'])
            addpath([R.paths.mapath 'Cogent2000v1.33/Toolbox'])
            addpath([R.paths.mapath 'SplitVec'])
            addpath([R.paths.mapath 'matleap-master'])
            
            addpath(genpath([R.paths.mapath 'boundedline-pkg']))
            
            addpath([R.paths.mapath 'TWtools'])
            % addpath(spmpath); spm eeg; close all
        case 2
            addpath([R.paths.gitpath 'fieldtrip'])
            addpath(genpath([R.paths.gitpath 'reaching_task']))
            addpath(genpath([R.paths.gitpath 'Spike-smr-reader']));
        
    end
end
