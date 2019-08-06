function gitpath = add_ReachingTask_paths()
if strcmp(getenv('COMPUTERNAME'),'SFLAP-2')
    gitpath = 'C:\Users\Tim\Documents\Work\GIT';
    mapath = 'C:\Users\Tim\Documents\MATLAB_ADDONS';
    
elseif strcmp(getenv('COMPUTERNAME'),'FREE')
    gitpath = 'C:\Users\twest\Documents\Work\Github';
    mapath = 'C:\Users\twest\Documents\Work\MATLAB ADDONS';
elseif strcmp(getenv('COMPUTERNAME'),'DESKTOP-94CEG1L')
    gitpath = 'C:\Users\timot\Documents\GitHub';
    mapath = 'C:\Users\timot\Documents\Work\MATLAB ADDONS';
end

addpath(genpath([gitpath '\reaching_task']))
addpath([mapath '\Cogent2000v1.33\Samples'])
addpath([mapath '\Cogent2000v1.33\Toolbox'])
addpath([mapath '\TWtools'])