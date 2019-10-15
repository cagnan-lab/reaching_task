clear; close all
% gitpath = 'C:\Users\timot\Documents\GitHub\';
% addpath([gitpath 'spm12']); spm eeg; close all
[datapath,gitpath] = add_ReachingTask_paths();

expname = 'pilot_220819';

datafile = {'main_experiment_LH_220819.smr'};
dataN = 1;

sp2data = ImportSMR([datapath expname '\EPhys\' datafile{dataN}]);
% Now convert to Fieldtrip format
ftdata = smr2FT(sp2data);
trdef = [92 110; 112 205; 211 230; 232 318; 376 395; 396 492; 493 513; 514 603; 652 673; 673 763; 771 790; 790 875];
bsedf = [70 90;  70 90  ; 190 210; 190 210; 355 375; 355 375; 473 493; 473 493; 632 652; 632 652; 751 771; 751 771];
trname = {'Rest1'
          'Reaching1'
          'Rest2'
          'Reaching2'
          'PD_Rest1'
          'PD_Reaching1'
          'PD_Rest2'
          'PD_Reaching2'
          'ET_Rest1'
          'ET_Reaching1'
          'ET_Rest2'
          'ET_Reaching2'
          };
      
      
for tr = 1:size(trdef,1)
    
    % Trial Data
    cfg = [];
    cfg.toilim    = trdef(tr,:);
    tr_data    = ft_redefinetrial(cfg,ftdata);
    
    cfg = [];
    cfg.length  = 1;
    data_epoch    = ft_redefinetrial(cfg,tr_data);
    
    
    % Base Data
        cfg = [];
    cfg.toilim    = bsedf(tr,:);
    bs_data    = ft_redefinetrial(cfg,ftdata);
    
    cfg = [];
    cfg.length  = 1;
    bs_epoch    = ft_redefinetrial(cfg,bs_data);

    
    
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
    cfg.toi          = bsedf(tr,1):0.05:bsedf(tr,2);
    cfg.pad       = 'nextpow2';
    [tfreq_base] = ft_freqanalysis(cfg, bs_data);    
    
    cfg = [];
    cfg.method = 'wavelet';
    cfg.channel      = 'OZ';
    cfg.width      = 7;
    cfg.foi          = 2:1:98;
    cfg.toi          = trdef(tr,1):0.05:trdef(tr,2);
    cfg.pad       = 'nextpow2';
    [tfreq] = ft_freqanalysis(cfg, tr_data);
    
    X = squeeze(tfreq.powspctrm(1,:,:));
    base = nanmedian(squeeze(tfreq_base.powspctrm(1,:,:)),2);
    X = X./base;
    
    figure((tr*10)+1)
    imagesc(tfreq.time,tfreq.freq,log10(X))
    set(gca,'YDir','normal')
    xlabel('Time'); ylabel('Frequency');caxis([0 2]);
    title(cfg.channel)
    set(gcf,'Position',[1271         132         560         420])
end