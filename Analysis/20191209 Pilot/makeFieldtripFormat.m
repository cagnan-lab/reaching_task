% This script is to analyse EEG data.

clear; close all; clc;

addpath('C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Spike-smr-reader\smrReader');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\fieldtrip-20191208');

SMR_data = LoadSMR();
SMR_data = struct2cell(SMR_data);

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

names = {'Fz','Cz','Ox','O1','O2','C3','C4','F3','F4'};
% ,'EMG1','EMG2','Z','Y','Coder','X','AcX','AcY','AcZ','Mark'};
for i = 1:9
    MS_8(:,i) = SMR_data{5}(i).imp.adc;        % SMR_data{5} = MS_8 = holding posture with fake tremor
end

fsample = 2048;
tend    = size(MS_8,1)./fsample;
timeVec = linspace(0,tend,size(MS_8,1));

ft_data.label           = names;
ft_data.fsample         = fsample;
ft_data.trial{1}        = MS_8';
ft_data.time{1}         = timeVec;

% figure(1)
% plot(ft_data.time{1},ft_data.trial{1}')
% xlabel('time (s)');
% ylabel('channel amplitude (uV)');

%%

% ---- Define Trials of 1 second:
cfg.trial = [];
cfg.trial.length = 1;
ft_data = ft_redefinetrial(cfg.trial,ft_data);

% ---- Apply filters:
cfg.preproc              = [];
% Low Pass Filter at 1 Hz:
cfg.preproc.lpfilter    = 'yes';
cfg.preproc.lpfreq      = 100;                          
% Remove line noise frequencies (is this meant to do now or later?):
cfg.preproc.dftfilter   = 'yes';                         
cfg.preproc.dftfreq     = [50 100 150];               
cfg.preproc.demean      = 'yes';
%     % The following settings are usefull for identifying EOG artifacts:
% cfg.preproc.bpfilter    = 'yes';
% cfg.preproc.bpfilttype  = 'but';
% cfg.preproc.bpfreq      = [2 15];
% cfg.preproc.bpfiltord   = 4;
% cfg.preproc.rectify     = 'yes';
ft_data_preproc = ft_preprocessing(cfg.preproc,ft_data);

% figure(2)
% plot(ft_data_preproc.time{1},ft_data_preproc.trial{1}')
% title('Processed signals plotted against time');
% xlabel('time (s)');
% ylabel('channel amplitude (uV)');

% ---- Visualize signals to clean:
cfg.artifact            = [];
% cfg.artifact.method     = 'trial';        % For individual expection 
ft_data_artifact = ft_rejectvisual(cfg.artifact, ft_data_preproc);

save('C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\Analysis\20191209 Pilot\CleanSignal', 'ft_data_artifact');

%% Visualize clean data:

cfg.browser = [];
cfg.browser.viewmode = 'vertical';
ft_databrowser(cfg.browser, ft_data_artifact);

%% 

% ---- Resampling to 2.5 times Nyquist Freq:
cfg.resample                = [];
cfg.resample.resamplefs     = 256;
cfg.resample.detrend        = 'yes';        % Say 'no' if looking at evoked fields
ft_data_resampled = ft_resampledata(cfg.resample, ft_data_artifact);        % Function requires SPT !

%%

% ---- Time-Frequency Spectral Analysis

cfg.freq            = [];
cfg.freq.method     = 'mtmfft';
cfg.freq.taper      = 'hanning';
cfg.freq.foilim     = [1 60];
ft_data_freq        = ft_freqanalysis(cfg.freq, ft_data_resampled);

figure(1)
subplot(3,3,1)
plot(ft_data_freq.powspctrm(1,:))
title('Channel Fz')
subplot(3,3,2)
plot(ft_data_freq.powspctrm(2,:))
title('Channel Cz')
subplot(3,3,3)
plot(ft_data_freq.powspctrm(3,:))
title('Channel Oz')
subplot(3,3,4)
plot(ft_data_freq.powspctrm(4,:))
title('Channel O1')
subplot(3,3,5)
plot(ft_data_freq.powspctrm(5,:))
title('Channel O2')
subplot(3,3,6)
plot(ft_data_freq.powspctrm(6,:))
title('Channel C3')
subplot(3,3,7)
plot(ft_data_freq.powspctrm(7,:))
title('Channel C4')
subplot(3,3,8)
plot(ft_data_freq.powspctrm(8,:))
title('Channel F3')
subplot(3,3,9)
plot(ft_data_freq.powspctrm(9,:))
title('Channel F4')
