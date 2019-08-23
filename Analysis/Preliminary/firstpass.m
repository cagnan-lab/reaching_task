clear; close all
gitpath = 'C:\Users\timot\Documents\GitHub\';
datapath = 'D:\Data\OPM_Tremor_project\Pilot\';
% addpath([gitpath 'spm12']); spm eeg; close all
addpath(genpath([gitpath 'Spike-smr-reader']));


expname = 'pilot_220819';

trname = {'Rest_block_1_220819.smr','REST_EYES_1_220819.smr'};
trN = 2;

sp2data = ImportSMR([datapath expname '\EPhys\' trname{trN}]);
% Now convert to Fieldtrip format
ftdata = smr2FT(sp2data);

cfg = [];
cfg.length  = 1;
data_epoch    = ft_redefinetrial(cfg, ftdata);

cfg = [];
cfg.method = 'mtmfft';
cfg.taper      = 'dpss';
cfg.tapsmofrq  = 2;
% cfg.foi = [2:0.5:98];
[freq] = ft_freqanalysis(cfg, data_epoch);

powz = (freq.powspctrm - mean(freq.powspctrm,2))./std(freq.powspctrm,[],2);
figure
subplot(3,1,1)
plot(freq.freq,powz(1:6,:)); xlim([2 98])
legend(ftdata.label(1:6))

subplot(3,1,2)
plot(freq.freq,powz(7:8,:)); xlim([2 98])
legend(ftdata.label(7:8))

subplot(3,1,3)
plot(freq.freq,powz(10:12,:)); xlim([2 98])
legend(ftdata.label(10:12))


cfg = [];
cfg.method = 'wavelet';
cfg.channel      = 'OZ';
cfg.width      = 7;
cfg.foi          = 2:1:98;
cfg.toi          = 0:0.05:98 ;
cfg.pad       = 'nextpow2',;
[tfreq] = ft_freqanalysis(cfg, ftdata);

figure
imagesc(tfreq.time,tfreq.freq,(squeeze(tfreq.powspctrm(1,:,:))))
set(gca,'YDir','normal')
xlabel('Time'); ylabel('Frequency')