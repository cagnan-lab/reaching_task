close all; clear all
% load('C:\Users\Tim\Documents\Work\GIT\reaching_task\testData\ms_pilot_test_firstHalf\TrialDatams_pilot_test_firstHalf_block2_cond2.mat')
% load('C:\Users\Tim\Documents\Work\GIT\reaching_task\testData\ms_pilot_test_firstHalf\TrialDatams_pilot_test_firstHalf_block2_cond4.mat')
% load('C:\Users\Tim\Documents\Work\GIT\reaching_task\testData\ms_pilot_test_firstHalf\TrialDatams_pilot_test_firstHalf_block2_posture.mat')
load('C:\Users\Tim\Documents\Work\GIT\reaching_task\testData\ms_pilot_test_firstHalf\TrialDatams_pilot_test_firstHalf_block3_cond1.mat')

 %Timings of 1) posture = 15; 2) reach; 3) prep; 4) exec; 5) hold; 6) return

coder = unique(trialData.coderSave(2:end));

for i = 1:size(coder,2)
    inds = find(trialData.coderSave==coder(i));
    codT(inds) = i;
end

% yyaxis left
plot(trialData.tvec,squeeze(trialData.handposition(2,:,:)))

yyaxis right
plot(trialData.tvec,codT(2:end));

for ax = 1:3
    X = squeeze(trialData.handposition(2,ax,:));
    [Y(ax,:),Tx] = resample(squeeze(trialData.handposition(2,ax,:)),trialData.tvec)
end


consecSeg = SplitVec(find(codT==4),'consecutive');
    