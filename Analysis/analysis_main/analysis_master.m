R.path.datapath = 'C:\DATA';
R.path.expname = 'OPM_pilot';
R.path.seshname = '04_03_OPM';
R.path.subcode = 'MS';



rep = 3;
cond = 1;
blockpart = []; % '_PosturalHold','_Rest'
% Get LeapMotion (at acquistion PC) data
leapFN = [R.path.datapath '\' R.path.expname '\StimuliPCLocal\' R.path.seshname ...
    '\' R.path.subcode '\' R.path.subcode '_Condition_' num2str(cond) '_Rep_' ...
    num2str(rep) blockpart '\Data'];
leapAqData = importLeapMotion(leapFN);

C:\DATA\OPM_pilot\OPM_Aquisition\OPM_pilot\sub-MS\ses-001\meg
sub-MS_ses-001_task-Cond1_run-003_meg
opmFN = [R.path.datapath '\' R.path.expname '\OPM_Aquisition\' R.path.seshname ...
    '\sub-' R.path.subcode '\meg\sub-' R.path.subcode '_ses-001_task-Cond' num2str(cond)...
    '_run-00' num2str(rep) '_meg.bin']

