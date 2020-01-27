function timeFreqAnalysis(R)


for cond = 1:numel(R.expSet.seshnames)
    
    for stage = 1:numel(R.expSet.stagenames)
        load([R.paths.datapath '\FTData\processed\' R.expSet.prefix '_trialDefined_' R.expSet.seshnames{cond} '.mat'],'ftdata_pp');
        
        cfg = [];
        cfg.trials  = find(ftdata_pp.trialinfo==stage);
        cfg.method =  'wavelet';
        cfg.width      = 7;
        cfg.foi        = 6:0.5:30;
        cfg.toi          =  -0:0.05:0.5;
        freqbs = ft_freqanalysis(cfg,ftdata_pp);
        
        cfg.toi          =  0.5:0.05:2;
        freq = ft_freqanalysis(cfg,ftdata_pp);
        
        figure((stage*10)+cond)
        for i = 1:numel(ftdata_pp.label)
            subplot(3,6,i)
            imagesc(freq.time,freq.freq,squeeze(freq.powspctrm(i,:,:))-nanmean(squeeze(freqbs.powspctrm(i,:,:)),2))
            hold on
            xlabel('Time'); ylabel('Hz'); title(freq.label{i})
             set(gca,"YDir",'normal')
        end
    end
end
legend(R.expSet.seshnames)

