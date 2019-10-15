clear; close all
% gitpath = 'C:\Users\timot\Documents\GitHub\';
% addpath([gitpath 'spm12']); spm eeg; close all
[datapath,gitpath] = add_ReachingTask_paths();

expname = 'pilot_220819';

datafile = {'Rest_block_1_220819.smr','REST_EYES_1_220819.smr'};
dataN = 2;

sp2data = ImportSMR([datapath expname '\EPhys\' datafile{dataN}]);
% Now convert to Fieldtrip format
ftdata = smr2FT(sp2data);
trdef = [2 83; 85 148; 150 228;230 291; 294 352];
basedef = [0 15; 90 100; 150 160; 230 240; 290 310];
trname = {'Eyes Open/closed','Rest to Posture','Rest to Posture Tremor','Rest to reach','Rest to reach Tremor'};
for tr = 1:size(trdef,1)
    
    cfg = [];
    cfg.toilim    = trdef(tr,:);
    tr_data    = ft_redefinetrial(cfg,ftdata);
    
    cfg = [];
    cfg.length  = 1;
    data_epoch    = ft_redefinetrial(cfg,tr_data);
    
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.taper      = 'dpss';
    cfg.tapsmofrq  = 2;
    % cfg.foi = [2:0.5:98];
    [freq] = ft_freqanalysis(cfg, data_epoch);
    
    powz = (freq.powspctrm - mean(freq.powspctrm,2))./std(freq.powspctrm,[],2);
    powz = powz - min(powz,[],2);
    figure(tr*10)
    subplot(3,1,1)
    plot(freq.freq,powz(1:6,:));
    legend(ftdata.label(1:6),'Location','SouthWest'); xlabel('log Frequency'); ylabel('log power')
    xlim([2 98]);
    set(gca, 'YScale', 'log', 'XScale', 'log')
    
    subplot(3,1,2)
    plot(freq.freq,powz(7:8,:));
    legend(ftdata.label(7:8),'Location','SouthWest'); xlabel('log Frequency'); ylabel('log power')
    set(gca, 'YScale', 'log', 'XScale', 'log')
    xlim([2 98]);
    
    subplot(3,1,3)
    plot(freq.freq,powz(10:12,:));
    legend(ftdata.label(10:12),'Location','SouthWest')
    xlim([2 98]); xlabel('log Frequency'); ylabel('log power')
    set(gca, 'YScale', 'log', 'XScale', 'log')
    
    set(gcf,'Position',[474   126   323   797])
    
    cfg = [];
    cfg.method = 'wavelet';
    cfg.channel      = 'OZ';
    cfg.width      = 7;
    cfg.foi          = 2:1:98;
    cfg.toi          = trdef(tr,1):0.05:trdef(tr,2);
    cfg.pad       = 'nextpow2';
    [tfreq] = ft_freqanalysis(cfg, tr_data);
    
    X = squeeze(tfreq.powspctrm(1,:,:));
    base = nanmedian(X(:,tfreq.time>basedef(tr,1) & tfreq.time<basedef(tr,2)),2);
    X = X./base;
    
    figure((tr*10)+1)
    imagesc(tfreq.time,tfreq.freq,log10(X))
    set(gca,'YDir','normal')
    xlabel('Time'); ylabel('Frequency');caxis([0 2.5]);
    title(cfg.channel)
    set(gcf,'Position',[1271         132         560         420])
end