% This script is to analyse TRIAL MS_8 accelerometer data. Using WRIST of LeapMotion.

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

fsample = 2048;
tend    = size(MS_8_AC,1)./fsample;
timeVec = linspace(0,tend,size(MS_8_AC,1));

% Setting Amplifier Variables Names:
LMx = MS_8_AC(:,4);         % LeapMotion Amplifier channel 15.
LMy = MS_8_AC(:,2);         % LeapMotion Amplifier channel 13.
LMz = MS_8_AC(:,1);         % LeapMotion Amplifier channel 12.
coder = MS_8_AC(:,3);
ACx = MS_8_AC(:,6);         % Accelerometer channel 17.
ACy = MS_8_AC(:,5);         % Accelerometer channel 16.
ACz = MS_8_AC(:,7);         % Accelerometer channel 18.

% Setting LeapMotion Matlab Variables Names:
Wrist_X = MS_8_ML{1, 1}.handposition(7,1,:);
timeVecML = MS_8_ML{1, 1}.tvec;                 % Time Vector of the LeapMotion Matlab Data
Wrist_X = zeros([1 length(Wrist_X)]);
Wrist_Y = zeros([1 length(Wrist_X)]);
Wrist_Z = zeros([1 length(Wrist_X)]);
for i = 1:length(Wrist_X)
    Wrist_X(i) = MS_8_ML{1, 1}.handposition(7,1,i);
    Wrist_Y(i) = MS_8_ML{1, 1}.handposition(7,2,i);
    Wrist_Z(i) = MS_8_ML{1, 1}.handposition(7,3,i);
end

%% Plotting one and other

figure(241)
subplot(2,1,1)
plot(timeVecML, Wrist_X-nanmean(Wrist_X), 'r');
title('LeapMotion Matlab WRIST X-Coordinate')
subplot(2,1,2)
plot(timeVec, ACx-nanmean(ACx), 'k');
title('Accelerometer Amplifier X-Coordinate')
xlabel('Time')

figure(242)
subplot(2,1,1)
plot(timeVecML, Wrist_Y-nanmean(Wrist_Y), 'r');
title('LeapMotion Matlab WRIST Y-Coordinate')
subplot(2,1,2)
plot(timeVec, ACy-nanmean(ACy), 'k');
title('Accelerometer Amplifier Y-Coordinate')
xlabel('Time')

figure(243)
subplot(2,1,1)
plot(timeVecML, Wrist_Z-nanmean(Wrist_Z), 'r');
title('LeapMotion Matlab WRIST Z-Coordinate')
subplot(2,1,2)
plot(timeVec, ACy-nanmean(ACz), 'k');
title('Accelerometer Amplifier Z-Coordinate')
xlabel('Time')


% Subtracting the mean and plot:
figure(4823)
subplot(3,1,1)
plot(timeVec, LMx-mean(LMx), 'r', timeVec, ACx-mean(ACx), 'k')
xlabel('Time')
ylabel('X-Coordinate')
subplot(3,1,2)
plot(timeVec, LMy-mean(LMy), 'r', timeVec, ACy-mean(ACy), 'k')
xlabel('Time')
ylabel('Y-Coordinate')
subplot(3,1,3)
plot(timeVec, LMz-mean(LMz), 'r', timeVec, ACz-mean(ACz), 'k')
xlabel('Time')
ylabel('Z-Coordinate')

% Finding peaks to shift for lags:
t_int = [0 12];                                                 % Time Interval
idx = find((timeVec >= t_int(1)) & (timeVec <= t_int(2)));      % Indices Correspoinding To Time Interval
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

% % Correct for lag... not good because only works for X:
% figure(142)
% subplot(3,1,1)
% plot(timeVec(1:end-xlag), (LMx(1+xlag:end)-mean(LMx)), 'r'); hold on
% plot(timeVec, (ACx-mean(ACx)), 'k');
% title('X-coordinate');
% legend('LeapMotion', 'Accelerometer');
% subplot(3,1,2)
% plot(timeVec(1:end-ylag), (LMy(1+ylag:end)-mean(LMy)), 'r'); hold on
% plot(timeVec, (ACy-mean(ACxy)), 'k');
% title('Y-coordinate');
% subplot(3,1,3)
% plot(timeVec(1:end-zlag), (LMx(1+zlag:end)-mean(LMz)), 'r'); hold on
% plot(timeVec, (ACz-mean(ACz)), 'k');
% title('Z-coordinate');





