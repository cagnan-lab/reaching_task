function steadyStateSpectralAnalysis(R)


for cond = 1:numel(R.expSet.seshnames)
    cmap = linspecer(2);
    for stage = 1:numel(R.expSet.stagenames)
        load([R.paths.datapath '\FTData\processed\' R.expSet.prefix '_trialDefined_' R.expSet.seshnames{cond} '.mat'],'ftdata_pp');
        
        cfg = [];
        cfg.trials  = find(ftdata_pp.trialinfo==stage);
        cfg.method =  'mtmfft';
        cfg.taper = 'dpss';
        cfg.foilim = [4 70];
        cfg.tapsmofrq  = 2;
        cfg.keeptrials  = 'yes'
        freq = ft_freqanalysis(cfg,ftdata_pp);
        
        figure(stage)
        for i = 1:numel(ftdata_pp.label)
            subplot(3,6,i)
            X = squeeze(mean(freq.powspctrm(:,i,:),1));
            Xvar = squeeze(std(freq.powspctrm(:,i,:),1)); %./sqrt(size(freq.powspctrm,1));
            inds = find(freq.freq>=10 & freq.freq<=14);
            
            E(i,stage,cond) = mean(squeeze(mean(freq.powspctrm(:,i,inds),1)));
            V(i,stage,cond) = mean(squeeze(std(freq.powspctrm(:,i,inds),1)));
            
            boundedline(freq.freq,X,Xvar,'cmap',cmap(cond,:),'alpha')
            
%             plot(freq.freq,freq.powspctrm(i,:));
            hold on
            xlabel('Hz'); ylabel(freq.label{i})
%             set(gca,"YScale","log",'XScale',"log")
        end
    end
end
legend(R.expSet.seshnames)


% Cohen's D
X(1) = E(7,1,1);
X(2) = E(7,1,2);
% pooled var
VP = (V(7,1,:));



