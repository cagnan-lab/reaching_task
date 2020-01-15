% This script is to analyse TRIAL MS_8 & TRIAL MS_15 accelerometer data. Using INDEX FINGER of LeapMotion.

clear; close all; clc;

addpath('C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Spike-smr-reader\smrReader');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\fieldtrip-20191208');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\Leapmotion Data\ms_pilot_test_firstHalf');  % LeapMotion Matlab

SMR_data = LoadSMR();
SMR_data = struct2cell(SMR_data);
% LeapMotion Matlab:
MS_8_ML = load('TrialDatams_pilot_test_firstHalf_block2_posture.mat');  % MS_8_ML = Posture With Tremor LeapMotion Data of Matlab
MS_8_ML = struct2cell(MS_8_ML);
MS_15_ML = load('TrialDatams_pilot_test_firstHalf_block2_cond2.mat');   % MS_15_ML = Block2Condition2 With Tremor LeapMotion Data of Matlab
MS_15_ML = struct2cell(MS_15_ML);
MS_7_ML = load('TrialDatams_pilot_test_firstHalf_block1_cond2.mat');   % MS_7_ML = Block1Condition2 Without Tremor LeapMotion Data of Matlab
MS_7_ML = struct2cell(MS_7_ML);
MS_2_ML = load('TrialDatams_pilot_test_firstHalf_block1_rest.mat');   % MS_2_ML = rest Without Tremor LeapMotion Data of Matlab
MS_2_ML = struct2cell(MS_2_ML);
MS_17_ML = load('TrialDatams_pilot_test_firstHalf_block4_cond4.mat');   % MS_17_ML = Block4Condition4 With Tremor LeapMotion Data of Matlab
MS_17_ML = struct2cell(MS_17_ML);
MS_16_ML = load('TrialDatams_pilot_test_firstHalf_block3_cond3.mat');   % MS_16_ML = Block3Condition3 With Tremor LeapMotion Data of Matlab
MS_16_ML = struct2cell(MS_16_ML);
MS_13_ML = load('TrialDatams_pilot_test_firstHalf_block1_cond1.mat');   % MS_13_ML = Block1Condition1 With ET Tremor LeapMotion Data of Matlab
MS_13_ML = struct2cell(MS_13_ML);


%% Definition channels:
%       EEG:    EMG:                LeapMotion:     Accelerometer:  Mark:
%       1. Fz   10. EMG1 (flexor)   12. Z           16. AcY         19. Mark
%       2. Cz   11. EMG2 (extensor) 13. Y           17. AcX
%       3. Oz                       14. Coder       18. AcZ
%       4. O1                       15. X
%       5. O2
%       6. C3
%       7. C4
%       8. F3
%       9. F4

% Accelerometer & LeapMotion Amplifier:
names = {'Z','Y','Coder','X','AcY','AcX','AcZ'};
for i = 1:7
    MS_8_AC(:,i) = SMR_data{5}(11+i).imp.adc;        % SMR_data{5} = MS_8 = holding posture with fake tremor
end

for i = 1:7
    MS_15_AC(:,i) = SMR_data{12}(11+i).imp.adc;        % SMR_data{12} = MS_15 = block2condition2 with tremor
end

for i = 1:7
    MS_7_AC(:,i) = SMR_data{4}(11+i).imp.adc;        % SMR_data{4} = MS_7 = block1condition2 without tremor
end

for i = 1:7
    MS_2_AC(:,i) = SMR_data{1}(11+i).imp.adc;        % SMR_data{1} = MS_2 = rest without tremor
end

for i = 1:7
    MS_17_AC(:,i) = SMR_data{14}(11+i).imp.adc;        % SMR_data{14} = MS_17 = block4condition4 with tremor
end

for i = 1:7
    MS_16_AC(:,i) = SMR_data{13}(11+i).imp.adc;        % SMR_data{13} = MS_16 = block3condition3 with tremor
end

for i = 1:7
    MS_13_AC(:,i) = SMR_data{10}(11+i).imp.adc;        % SMR_data{10} = MS_13 = block1condition1 with ET tremor
end
MS_13_AC = MS_13_AC(1:157697,:);


fsample = 2048;
tend8    = size(MS_8_AC,1)./fsample;
timeVec8 = linspace(0,tend8,size(MS_8_AC,1));
tend15    = size(MS_15_AC,1)./fsample;
timeVec15 = linspace(0,tend15,size(MS_15_AC,1));
tend7    = size(MS_7_AC,1)./fsample;
timeVec7 = linspace(0,tend7,size(MS_7_AC,1));
tend2    = size(MS_2_AC,1)./fsample;
timeVec2 = linspace(0,tend2,size(MS_2_AC,1));
tend17    = size(MS_17_AC,1)./fsample;
timeVec17 = linspace(0,tend17,size(MS_17_AC,1));
tend16    = size(MS_16_AC,1)./fsample;
timeVec16 = linspace(0,tend16,size(MS_16_AC,1));
tend13    = size(MS_13_AC,1)./fsample;
timeVec13 = linspace(0,tend13,size(MS_13_AC,1));

%%

% Setting Amplifier Variables Names MS_8:
LMx8 = MS_8_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy8 = MS_8_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz8 = MS_8_AC(:,1);         % LeapMotion Amplifier channel 12.
coder8 = MS_8_AC(:,3);
ACx8 = MS_8_AC(:,6);         % Accelerometer channel 17.
ACy8 = MS_8_AC(:,5);         % Accelerometer channel 16.
ACz8 = MS_8_AC(:,7);         % Accelerometer channel 18.

% Setting Amplifier Variables Names MS_15:
LMx15 = MS_15_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy15 = MS_15_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz15 = MS_15_AC(:,1);         % LeapMotion Amplifier channel 12.
coder15 = MS_15_AC(:,3);
ACx15 = MS_15_AC(:,6);         % Accelerometer channel 17.
ACy15 = MS_15_AC(:,5);         % Accelerometer channel 16.
ACz15 = MS_15_AC(:,7);         % Accelerometer channel 18.

% Setting Amplifier Variables Names MS_7:
LMx7 = MS_7_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy7 = MS_7_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz7 = MS_7_AC(:,1);         % LeapMotion Amplifier channel 12.
coder7 = MS_7_AC(:,3);
ACx7 = MS_7_AC(:,6);         % Accelerometer channel 17.
ACy7 = MS_7_AC(:,5);         % Accelerometer channel 16.
ACz7 = MS_7_AC(:,7);         % Accelerometer channel 18.

% Setting Amplifier Variables Names MS_2:
LMx2 = MS_2_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy2 = MS_2_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz2 = MS_2_AC(:,1);         % LeapMotion Amplifier channel 12.
coder2 = MS_2_AC(:,3);
ACx2 = MS_2_AC(:,6);         % Accelerometer channel 17.
ACy2 = MS_2_AC(:,5);         % Accelerometer channel 16.
ACz2 = MS_2_AC(:,7);         % Accelerometer channel 18.

% Setting Amplifier Variables Names MS_17:
LMx17 = MS_17_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy17 = MS_17_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz17 = MS_17_AC(:,1);         % LeapMotion Amplifier channel 12.
coder17 = MS_17_AC(:,3);
ACx17 = MS_17_AC(:,6);         % Accelerometer channel 17.
ACy17 = MS_17_AC(:,5);         % Accelerometer channel 16.
ACz17 = MS_17_AC(:,7);         % Accelerometer channel 18.

% Setting Amplifier Variables Names MS_16:
LMx16 = MS_16_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy16 = MS_16_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz16 = MS_16_AC(:,1);         % LeapMotion Amplifier channel 12.
coder16 = MS_16_AC(:,3);
ACx16 = MS_16_AC(:,6);         % Accelerometer channel 17.
ACy16 = MS_16_AC(:,5);         % Accelerometer channel 16.
ACz16 = MS_16_AC(:,7);         % Accelerometer channel 18.

% Setting Amplifier Variables Names MS_13:
% RECORDING TOO LONG - CUT AT 77 SECONDS
LMx13 = MS_13_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy13 = MS_13_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz13 = MS_13_AC(:,1);         % LeapMotion Amplifier channel 12.
coder13 = MS_13_AC(:,3);
ACx13 = MS_13_AC(:,6);         % Accelerometer channel 17.
ACy13 = MS_13_AC(:,5);         % Accelerometer channel 16.
ACz13 = MS_13_AC(:,7);         % Accelerometer channel 18.

% Setting LeapMotion Matlab Variables Names:
Index_X = MS_8_ML{1, 1}.handposition(2,1,:);
timeVecML8 = MS_8_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X = zeros([1 length(Index_X)]);
Index_Y = zeros([1 length(Index_X)]);
Index_Z = zeros([1 length(Index_X)]);
for i = 1:length(Index_X)
    Index_X(i) = MS_8_ML{1, 1}.handposition(2,1,i);
    Index_Y(i) = MS_8_ML{1, 1}.handposition(2,2,i);
    Index_Z(i) = MS_8_ML{1, 1}.handposition(2,3,i);
end

% Setting LeapMotion Matlab Variables Names MS_15:
Index_X15 = MS_15_ML{1, 1}.handposition(2,1,:);
timeVecML15 = MS_15_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X15 = zeros([1 length(Index_X15)]);
Index_Y15 = zeros([1 length(Index_X15)]);
Index_Z15 = zeros([1 length(Index_X15)]);
for i = 1:length(Index_X15)
    Index_X15(i) = MS_15_ML{1, 1}.handposition(2,1,i);
    Index_Y15(i) = MS_15_ML{1, 1}.handposition(2,2,i);
    Index_Z15(i) = MS_15_ML{1, 1}.handposition(2,3,i);
end

% Setting LeapMotion Matlab Variables Names MS_7:
Index_X7 = MS_7_ML{1, 1}.handposition(2,1,:);
timeVecML7 = MS_7_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X7 = zeros([1 length(Index_X7)]);
Index_Y7 = zeros([1 length(Index_X7)]);
Index_Z7 = zeros([1 length(Index_X7)]);
for i = 1:length(Index_X7)
    Index_X7(i) = MS_7_ML{1, 1}.handposition(2,1,i);
    Index_Y7(i) = MS_7_ML{1, 1}.handposition(2,2,i);
    Index_Z7(i) = MS_7_ML{1, 1}.handposition(2,3,i);
end

% Setting LeapMotion Matlab Variables Names:
Index_X2 = MS_2_ML{1, 1}.handposition(2,1,:);
timeVecML2 = MS_2_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X2 = zeros([1 length(Index_X2)]);
Index_Y2 = zeros([1 length(Index_X2)]);
Index_Z2 = zeros([1 length(Index_X2)]);
for i = 1:length(Index_X2)
    Index_X2(i) = MS_2_ML{1, 1}.handposition(2,1,i);
    Index_Y2(i) = MS_2_ML{1, 1}.handposition(2,2,i);
    Index_Z2(i) = MS_2_ML{1, 1}.handposition(2,3,i);
end

% Setting LeapMotion Matlab Variables Names MS_17:
Index_X17 = MS_17_ML{1, 1}.handposition(2,1,:);
timeVecML17 = MS_17_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X17 = zeros([1 length(Index_X17)]);
Index_Y17 = zeros([1 length(Index_X17)]);
Index_Z17 = zeros([1 length(Index_X17)]);
for i = 1:length(Index_X17)
    Index_X17(i) = MS_17_ML{1, 1}.handposition(2,1,i);
    Index_Y17(i) = MS_17_ML{1, 1}.handposition(2,2,i);
    Index_Z17(i) = MS_17_ML{1, 1}.handposition(2,3,i);
end

% Setting LeapMotion Matlab Variables Names MS_16:
Index_X16 = MS_16_ML{1, 1}.handposition(2,1,:);
timeVecML16 = MS_16_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X16 = zeros([1 length(Index_X16)]);
Index_Y16 = zeros([1 length(Index_X16)]);
Index_Z16 = zeros([1 length(Index_X16)]);
for i = 1:length(Index_X16)
    Index_X16(i) = MS_16_ML{1, 1}.handposition(2,1,i);
    Index_Y16(i) = MS_16_ML{1, 1}.handposition(2,2,i);
    Index_Z16(i) = MS_16_ML{1, 1}.handposition(2,3,i);
end

% Setting LeapMotion Matlab Variables Names MS_13:
Index_X13 = MS_13_ML{1, 1}.handposition(2,1,:);
timeVecML13 = MS_13_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Index_X13 = zeros([1 length(Index_X13)]);
Index_Y13 = zeros([1 length(Index_X13)]);
Index_Z13 = zeros([1 length(Index_X13)]);
for i = 1:length(Index_X13)
    Index_X13(i) = MS_13_ML{1, 1}.handposition(2,1,i);
    Index_Y13(i) = MS_13_ML{1, 1}.handposition(2,2,i);
    Index_Z13(i) = MS_13_ML{1, 1}.handposition(2,3,i);
end

%% Plotting one and other

% Plotting LeapMotion Amplifier Data per Trial:
figure(231)
subplot(3,1,1)
plot(timeVec15, LMx15-nanmean(LMx15), 'r', timeVec15, coder15, 'b');
title('MS 15 (trail tremor): LeapMotion Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec15, LMy15-nanmean(LMy15), 'r', timeVec15, coder15, 'b');
title('MS 15 (trail tremor): LeapMotion Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec15, LMz15-nanmean(LMz15), 'r', timeVec15, coder15, 'b');
title('MS 15 (trail tremor): LeapMotion Amplifier Z-Coordinate')
xlabel('Time')

figure(232)
subplot(3,1,1)
plot(timeVec7, LMx7-nanmean(LMx7), 'r', timeVec7, coder7, 'b');
title('MS 7 (trial no tremor): LeapMotion Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec7, LMy7-nanmean(LMy7), 'r', timeVec7, coder7, 'b');
title('MS 7 (trial no tremor): LeapMotion Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec7, LMz7-nanmean(LMz7), 'r', timeVec7, coder7, 'b');
title('MS 7 (trial no tremor): LeapMotion Amplifier Z-Coordinate')
xlabel('Time')

figure(233)
subplot(3,1,1)
plot(timeVec17, LMx17-nanmean(LMx17), 'r', timeVec17, coder17, 'b');
title('MS 17 (trial tremor): LeapMotion Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec17, LMy17-nanmean(LMy17), 'r', timeVec17, coder17, 'b');
title('MS 17 (trial tremor): LeapMotion Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec17, LMz17-nanmean(LMz17), 'r', timeVec17, coder17, 'b');
title('MS 17 (trial tremor): LeapMotion Amplifier Z-Coordinate')
xlabel('Time')

figure(213)
subplot(3,1,1)
plot(timeVec13, LMx13-nanmean(LMx13), 'r', timeVec13, coder13, 'b');
title('MS 13 (trial ET tremor): LeapMotion Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec13, LMy13-nanmean(LMy13), 'r', timeVec13, coder13, 'b');
title('MS 13 (trial ET tremor): LeapMotion Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec13, LMz13-nanmean(LMz13), 'r', timeVec13, coder13, 'b');
title('MS 13 (trial ET tremor): LeapMotion Amplifier Z-Coordinate')
xlabel('Time')

% Plotting Accelerometer Amplifier Data per Trial:
figure(234)
subplot(3,1,1)
plot(timeVec15, ACx15-nanmean(ACx15), 'k', timeVec15, coder15, 'b');
title('MS 15 (trial tremor): Accelerometer Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec15, ACy15-nanmean(LMy15), 'k', timeVec15, coder15, 'b');
title('MS 15 (trial tremor): Accelerometer Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec15, ACz15-nanmean(LMz15), 'k', timeVec15, coder15, 'b');
title('MS 15 (trial tremor): Accelerometer Amplifier Z-Coordinate')
xlabel('Time')

figure(235)
subplot(3,1,1)
plot(timeVec17, ACx17-nanmean(ACx17), 'k', timeVec17, coder17, 'b');
title('MS 17 (trial tremor): Accelerometer Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec17, ACy17-nanmean(LMy17), 'k', timeVec17, coder17, 'b');
title('MS 17 (trial tremor): Accelerometer Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec17, ACz17-nanmean(LMz17), 'k', timeVec17, coder17, 'b');
title('MS 17 (trial tremor): Accelerometer Amplifier Z-Coordinate')
xlabel('Time')

figure(235)
subplot(3,1,1)
plot(timeVec7, ACx7-nanmean(ACx7), 'k', timeVec7, coder7, 'b');
title('MS 7 (trial tremor): Accelerometer Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec7, ACy7-nanmean(LMy7), 'k', timeVec7, coder7, 'b');
title('MS 7 (trial tremor): Accelerometer Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec7, ACz7-nanmean(LMz7), 'k', timeVec7, coder7, 'b');
title('MS 7 (trial tremor): Accelerometer Amplifier Z-Coordinate')
xlabel('Time')

figure(226)
subplot(3,1,1)
plot(timeVec13, ACx13-nanmean(ACx13), 'k', timeVec13, coder13, 'b');
title('MS 13 (trial ET tremor): Accelerometer Amplifier X-Coordinate')
subplot(3,1,2)
plot(timeVec13, ACy13-nanmean(LMy13), 'k', timeVec13, coder13, 'b');
title('MS 13 (trial ET tremor): Accelerometer Amplifier Y-Coordinate')
subplot(3,1,3)
plot(timeVec13, ACz13-nanmean(LMz13), 'k', timeVec13, coder13, 'b');
title('MS 13 (trial ET tremor): Accelerometer Amplifier Z-Coordinate')
xlabel('Time')

%% Finding cross-correlations for amplifier data

% MS_7:
[Cx7,lagx7] = xcorr((ACx7-nanmean(ACx7)),(LMx7-nanmean(LMx7)));
[Cy7,lagy7] = xcorr((ACy7-nanmean(ACy7)),(LMy7-nanmean(LMy7)));
[Cz7,lagz7] = xcorr((ACz7-nanmean(ACz7)),(LMz7-nanmean(LMz7)));
figure(5)
subplot(3,1,1)
plot(lagx7,Cx7./max(Cx7))
title('MS 7: Cross Correlation of X-Coordinates')
subplot(3,1,2)
plot(lagy7,Cy7./max(Cy7))
title('MS 7: Cross Correlation of Y-Coordinates')
subplot(3,1,3)
plot(lagz7,Cz7./max(Cz7))
title('MS 7: Cross Correlation of Z-Coordinates')

[~, Ix] = max(abs(Cx7));
[~, Iy] = max(abs(Cy7));
[~, Iz] = max(abs(Cz7));
tx7 = lagx7(Ix);
ty7 = lagy7(Iy);
tz7 = lagz7(Iz);
t7 = [tx7 ty7 tz7];

% MS_15:
[Cx15,lagx15] = xcorr((ACx15-nanmean(ACx15)),(LMx15-nanmean(LMx15)));
[Cy15,lagy15] = xcorr((ACy15-nanmean(ACy15)),(LMy15-nanmean(LMy15)));
[Cz15,lagz15] = xcorr((ACz15-nanmean(ACz15)),(LMz15-nanmean(LMz15)));
figure(7)
subplot(3,1,1)
plot(lagx15,Cx15./max(Cx15))
title('MS 15: Cross Correlation of ACx with LM X-Coordinates')
subplot(3,1,2)
plot(lagy15,Cy15./max(Cy15))
title('MS 15: Cross Correlation of ACy with LM Y-Coordinates')
subplot(3,1,3)
plot(lagz15,Cz15./max(Cz15))
title('MS 15: Cross Correlation of ACz with LM Z-Coordinates')

[~, Ix] = max(abs(Cx15));
[~, Iy] = max(abs(Cy15));
[~, Iz] = max(abs(Cz15));
tx15 = lagx15(Ix);
ty15 = lagy15(Iy);
tz15 = lagz15(Iz);
t15 = [tx15 ty15 tz15];

% MS_17:
[Cx17,lagx17] = xcorr((ACx17-nanmean(ACx17)),(LMx17-nanmean(LMx17)));
[Cy17,lagy17] = xcorr((ACy17-nanmean(ACy17)),(LMy17-nanmean(LMy17)));
[Cz17,lagz17] = xcorr((ACz17-nanmean(ACz17)),(LMz17-nanmean(LMz17)));
figure(11)
subplot(3,1,1)
plot(lagx17,Cx17./max(Cx17))
title('MS 17: Cross Correlation of X-Coordinates')
subplot(3,1,2)
plot(lagy17,Cy17./max(Cy17))
title('MS 17: Cross Correlation of Y-Coordinates')
subplot(3,1,3)
plot(lagz17,Cz17./max(Cz17))
title('MS 17: Cross Correlation of Z-Coordinates')

[~, Ix] = max(abs(Cx17));
[~, Iy] = max(abs(Cy17));
[~, Iz] = max(abs(Cz17));
tx17 = lagx17(Ix);
ty17 = lagy17(Iy);
tz17 = lagz17(Iz);
t17 = [tx17 ty17 tz17];

% MS_16:
[Cx16,lagx16] = xcorr((ACx16-nanmean(ACx16)),(LMx16-nanmean(LMx16)));
[Cy16,lagy16] = xcorr((ACy16-nanmean(ACy16)),(LMy16-nanmean(LMy16)));
[Cz16,lagz16] = xcorr((ACz16-nanmean(ACz16)),(LMz16-nanmean(LMz16)));
figure(14)
subplot(3,1,1)
plot(lagx16,Cx16./max(Cx16))
title('MS 16: Cross Correlation of X-Coordinates')
subplot(3,1,2)
plot(lagy16,Cy16./max(Cy16))
title('MS 16: Cross Correlation of Y-Coordinates')
subplot(3,1,3)
plot(lagz16,Cz16./max(Cz16))
title('MS 16: Cross Correlation of Z-Coordinates')

[~, Ix] = max(abs(Cx16));
[~, Iy] = max(abs(Cy16));
[~, Iz] = max(abs(Cz16));
tx16 = lagx16(Ix);
ty16 = lagy16(Iy);
tz16 = lagz16(Iz);
t16 = [tx16 ty16 tz16];

% MS_13:
[Cx13,lagx13] = xcorr((ACx13-nanmean(ACx13)),(LMx13-nanmean(LMx13)), 'biased');
[Cy13,lagy13] = xcorr((ACy13-nanmean(ACy13)),(LMy13-nanmean(LMy13)), 'biased');
[Cz13,lagz13] = xcorr((ACz13-nanmean(ACz13)),(LMz13-nanmean(LMz13)), 'biased');
figure(14)
subplot(3,1,1)
plot(lagx13,Cx13./max(Cx13))
title('MS 13: Cross Correlation of X-Coordinates')
subplot(3,1,2)
plot(lagy13,Cy13./max(Cy13))
title('MS 13: Cross Correlation of Y-Coordinates')
subplot(3,1,3)
plot(lagz13,Cz13./max(Cz13))
title('MS 13: Cross Correlation of Z-Coordinates')

[~, Ix] = max(abs(Cx13));
[~, Iy] = max(abs(Cy13));
[~, Iz] = max(abs(Cz13));
tx13 = lagx13(Ix);
ty13 = lagy13(Iy);
tz13 = lagz13(Iz);
t13 = [tx13 ty13 tz13];

lag_sec = [t13(3) t15(3) t16(3) t17(3)]./fsample;
mean_lag = mean(lag_sec);
std_lag = std(lag_sec);

% Plotting the course of Time Vector Resolution of LeapMotion Matlab data
% Shows that rest&posture are not good, all other trials fine resolution!
% TRY RESAMPLING TO GET SAME TIME SAMPLING OVER ENTIRE TRIAL
figure(8461)
plot(1./diff(timeVecML8)); hold on
plot(1./diff(timeVecML15)); hold on
plot(1./diff(timeVecML7)); hold on
plot(1./diff(timeVecML2));
title('Derivative of LeapMotion Matlab data Time Vector', 'FontSize', 20)
ylabel('Resolution of the Time Vector', 'FontSize', 17)
legend('MS 8 = posture', 'MS 15 = trail', 'MS 7 = trial', 'MS 2 = rest')


%% Trying to find a way to extract the exact timings of coders

figure
plot(timeVec15, coder15, 'b'); hold on
plot(timeVec15(2:end),diff(coder15))
title('MS 15 Coder', 'FontSize', 20)
xlabel('Time', 'FontSize', 17)
legend('Coder', 'Derivative Coder')

figure
plot(timeVec15(2:end), diff(LMx15-nanmean(LMx15)))

% SEE CODER TIMINGS!!

%%
% Finding peaks to shift for lags:
t_int = [0 12];                                                 % Time Interval
idx = find((timeVec8 >= t_int(1)) & (timeVec8 <= t_int(2)));      % Indices Correspoinding To Time Interval
% For X:
[LM_max,LMx_locs] = max(LMx(idx));
[AC_max,ACx_locs] = max(ACx(idx));
xlag = LMx_locs - ACx_locs;
% For Y:
[LM_max,LMy_locs] = max(LMy(idx));
[AC_max,ACy_locs] = max(ACy(idx));
ylag = LMy_locs - ACy_locs;
% For Z:
[LM_max,LMz_locs] = max(LMz(idx));
[AC_max,ACz_locs] = max(ACz(idx));
zlag = LMz_locs - ACz_locs;

% Correct for lag... not good because only works for X:
figure(142)
subplot(3,1,1)
plot(timeVec8(1:end-xlag), (LMx(1+xlag:end)-mean(LMx)), 'r'); hold on
plot(timeVec8, (ACx-mean(ACx)), 'k');
title('X-coordinate');
legend('LeapMotion', 'Accelerometer');
subplot(3,1,2)
plot(timeVec8(1:end-ylag), (LMy(1+ylag:end)-mean(LMy)), 'r'); hold on
plot(timeVec8, (ACy-mean(ACxy)), 'k');
title('Y-coordinate');
subplot(3,1,3)
plot(timeVec8(1:end-zlag), (LMx(1+zlag:end)-mean(LMz)), 'r'); hold on
plot(timeVec8, (ACz-mean(ACz)), 'k');
title('Z-coordinate');





