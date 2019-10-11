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
ftdata.trial{1}(strncmp('LabJ',ftdata.label,4),:) = ftdata.trial{1}(strncmp('LabJ',ftdata.label,4),:)./1e5; % Rescale the
ftdata.trial{1}(strncmp('EMG',ftdata.label,3),:) = abs(ftdata.trial{1}(strncmp('EMG',ftdata.label,3),:)); % Rectify EMG
% % Preprocessing
% cfg = [];
% cfg.lpfilter = 'yes';
% cfg.lpfreq = 48;
% ftdata = ft_preprocessing(cfg,ftdata);

% Experimental Definitions
expdef = [92 110; 112 205; 211 230; 232 318; 376 395; 396 492; 493 513; 514 603; 652 673; 673 763; 771 790; 790 875];
bsedf = [70 90;  70 90  ; 190 210; 190 210; 355 375; 355 375; 473 493; 473 493; 632 652; 632 652; 751 771; 751 771];
expname = {'Rest1'
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

% Trial Properties
fsamp =  ftdata.fsample;
preonset = fsamp.*(200/1000); % 250ms preonset
postonset = fsamp.*(800/1000); % 500ms post


for exp = 2:size(expdef,1)
    bs = 3.17;
    trind = find(strncmp('LabJ',ftdata.label,4));
%         trind = find(strncmp('Acc',ftdata.label,3));

%     expsel = [2 4 6 8 10 12];
    expsel = [2 4];
    for rep = 1:size(expsel,2)
        % Trial Data
        cfg = [];
        cfg.toilim    = expdef(expsel(rep),:);
        tr_data    = ft_redefinetrial(cfg,ftdata);
        
        % used for triggers based on cue presentation
        triggers = round(tr_data.trial{1}(trind,:),1);
        triggers = triggers-bs;
        trsegs = SplitVec(find(triggers>0.5),'consecutive');
        
        % Used for triggers based on accelerometers
%         [U,S] = svd(tr_data.trial{1}(trind,:)','econ');
%         triggers = U;
        
        trdef = [];
        for i = 1:size(trsegs,2)
            trdef(i,:) = [trsegs{i}(1)-floor(preonset) trsegs{i}(1)+floor(postonset) -preonset];
        end
        trdef(trdef(:,1)<0,:) = [];
        
        cfg = [];
        cfg.trl  = trdef;
        data_epoch(rep)    = ft_redefinetrial(cfg,tr_data);
    end
    cfg =[];
    %     cfg.keepsampleinfo='no'
%     data_ap = ft_appenddata(cfg, data_epoch(1), data_epoch(2), data_epoch(3), data_epoch(4), data_epoch(5), data_epoch(6));
    data_ap = ft_appenddata(cfg, data_epoch(1), data_epoch(2));
    % Base Data
    cfg = [];
    cfg.toilim    = bsedf(exp,:);
    bs_data    = ft_redefinetrial(cfg,ftdata);
    
    cfg = [];
    cfg.length  = 1;
    bs_epoch    = ft_redefinetrial(cfg,bs_data);
    
    % Plot ERP
    X = [];
    for tr = 1:numel(data_ap.trial)
        X(:,tr) = data_ap.trial{tr}(5,:);
    end
    figure
    boundedline(data_ap.time{1},mean(X,2),std(X,[],2)./sqrt(size(X,2)))
    
    % Now compute Spectra
    cfg = [];
    cfg.method = 'mtmfft';
    cfg.taper      = 'dpss';
    cfg.tapsmofrq  = 2;
    % cfg.foi = [2:0.5:98];
    [freq] = ft_freqanalysis(cfg, data_ap);
    
    powz = (freq.powspctrm - mean(freq.powspctrm,2))./std(freq.powspctrm,[],2);
    powz = powz - min(powz,[],2);
    figure(exp*10)
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
    cfg.channel      = 'C3';
    cfg.width      = 7;
    cfg.foi          = 2:1:98;
    cfg.toi          = bsedf(exp,1):0.05:bsedf(exp,2);
    cfg.pad       = 'nextpow2';
    [tfreq_base] = ft_freqanalysis(cfg, bs_data);
    
    cfg = [];
    cfg.method = 'wavelet';
    cfg.channel      = {'C3','EMG1'};
    cfg.width      = 3;
    cfg.foi          = 2:1:98;
    cfg.toi          = 'all';
    cfg.pad       = 'nextpow2';
% %     cfg.output = 'powandcsd';
    [tfreq] = ft_freqanalysis(cfg, data_ap);
    
    X = squeeze(tfreq.powspctrm(1,:,:));
    base = nanmedian(squeeze(tfreq_base.powspctrm(1,:,:)),2);
    X = X./base;
    
    figure((exp*10)+1)
    imagesc(tfreq.time,tfreq.freq,log10(X))
    set(gca,'YDir','normal')
    xlabel('Time'); ylabel('Frequency');caxis([0 1]); %ylim([2 48])
    title(cfg.channel)
    set(gcf,'Position',[1271         132         560         420])
    
% %     % Recompute spectra for Coherence
% %     cfg = [];
% %     cfg.method = 'mtmfft';
% %     cfg.taper      = 'dpss';
% %     cfg.tapsmofrq  = 5;
% %     cfg.output = 'powandcsd';
% %     [freq] = ft_freqanalysis(cfg, data_ap);
% %     
% %     
% %     cfg = [];
% %     %     cfg.channel    = {'C3','EMG1'};
% %     cfg.method  = 'coh';
% %     %     cfg.complex     = 'imag';
% %     coh = ft_connectivityanalysis(cfg,freq);
% %     
% %     figure((exp*10)+3)
% %     plot(coh.freq,coh.cohspctrm(40,:))
% % 
% % % Compute Time Varying Coherence
% %     cfg = [];
% %     cfg.channelcmb    = {'C3','EMG1'};
% %     cfg.method  = 'coh';
% % %     cfg.complex     = 'imag';
% %     coht = ft_connectivityanalysis(cfg,tfreq);
% %     
% %      figure((exp*10)+3)
% %      X = squeeze(coht.cohspctrm)
% %     imagesc(coht.time,coht.freq,X)
% %     set(gca,'YDir','normal')
% %     xlabel('Time'); ylabel('Frequency');caxis([0 1]); ylim([2 48])
% %     title('C3 - EMG1 Wavelet Coherence')
% %     set(gcf,'Position',[1271         132         560         420])
   
end