function data = LoadML();

MS_4_ML = load('TrialDatams_pilot_test_firstHalf_block1_posture.mat');  % MS_4_ML = Posture Tremor ?? LeapMotion Data of Matlab
MS_4_ML = struct2cell(MS_4_ML);  
MS_5_ML = load('TrialDatams_pilot_test_firstHalf_block1_rest.mat');   % MS_5_ML = rest Tremor ?? LeapMotion Data of Matlab
MS_5_ML = struct2cell(MS_5_ML);                                       
% Can also be MS_2_ML
MS_7_ML = load('TrialDatams_pilot_test_firstHalf_block1_cond2.mat');   % MS_7_ML = Block1Condition2 Without Tremor LeapMotion Data of Matlab
MS_7_ML = struct2cell(MS_7_ML); 
% Can also be MS_8_ML
MS_8_ML = load('TrialDatams_pilot_test_firstHalf_block2_posture.mat');  % MS_8_ML = Posture With Tremor LeapMotion Data of Matlab
MS_8_ML = struct2cell(MS_8_ML);                                         
% Can also be MS_4_ML
MS_9_ML = load('TrialDatams_pilot_test_firstHalf_block2_cond4.mat');  % MS_9_ML = Block2Condition4 NO Tremor LeapMotion Data of Matlab
MS_9_ML = struct2cell(MS_9_ML);
MS_10_ML = load('TrialDatams_pilot_test_firstHalf_block3_cond1.mat');   % MS_10_ML = Block3Condition1 NO Tremor LeapMotion Data of Matlab
MS_10_ML = struct2cell(MS_10_ML);
MS_11_ML = load('TrialDatams_pilot_test_firstHalf_block4_cond3.mat');   % MS_11_ML = Block1Condition1 NO Tremor LeapMotion Data of Matlab
MS_11_ML = struct2cell(MS_11_ML);
MS_13_ML = load('TrialDatams_pilot_test_firstHalf_block1_cond1.mat');   % MS_13_ML = Block1Condition1 With ET Tremor LeapMotion Data of Matlab
MS_13_ML = struct2cell(MS_13_ML);
MS_15_ML = load('TrialDatams_pilot_test_firstHalf_block2_cond2.mat');   % MS_15_ML = Block2Condition2 With Tremor LeapMotion Data of Matlab
MS_15_ML = struct2cell(MS_15_ML);
MS_16_ML = load('TrialDatams_pilot_test_firstHalf_block3_cond3.mat');   % MS_16_ML = Block3Condition3 With Tremor LeapMotion Data of Matlab
MS_16_ML = struct2cell(MS_16_ML);
MS_17_ML = load('TrialDatams_pilot_test_firstHalf_block4_cond4.mat');   % MS_17_ML = Block4Condition4 With Tremor LeapMotion Data of Matlab
MS_17_ML = struct2cell(MS_17_ML);


SMR = {MS_4_ML MS_5_ML MS_7_ML MS_8_ML MS_9_ML MS_10_ML MS_11_ML MS_13_ML MS_15_ML MS_16_ML MS_17_ML};
naming = {'MS_4' 'MS_5' 'MS_7' 'MS_8' 'MS_9' 'MS_10' 'MS_11' 'MS_13' 'MS_15' 'MS_16' 'MS_17'};
data = [naming; SMR]';