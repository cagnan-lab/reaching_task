function [] = makeDataSets(R)


for cond = 1:numel(R.expSet.seshnames)
    % merge trials from seshnums and stagenames
    ftdata_cat = mergeFTTrials(R.paths.datapath,R.expSet.seshnums{cond},R.expSet.stagenames);
    
    % Downsample to 512
    cfg = [];
    cfg.resamplefs = 512;
    ftdata_cat = ft_resampledata(cfg,ftdata_cat);
    
    % Preprocess to remove artefacts
    cfg = [];
    % cfg.method = 'channel';
    % cfg.latency = 'minperiod';
    ftdata_cat_rv = ft_rejectvisual(cfg,ftdata_cat);
    
    % Preprocess
    cfg = [];
    cfg.preproc              = [];
    % Low Pass Filter at 1 Hz:
    cfg.preproc.lpfilter    = 'yes';
    cfg.preproc.lpfreq      = 150;
    % Remove line noise frequencies (is this meant to do now or later?):
    cfg.preproc.dftfilter   = 'yes';
    cfg.preproc.dftfreq     = [50 100 150];
    cfg.preproc.demean      = 'yes';
    ftdata_pp= ft_preprocessing(cfg,ftdata_cat_rv);
    
    cfg = [];
    cfg.trials = find(ftdata_pp.trialinfo==1)';
    tmpdata = ft_selectdata(cfg,ftdata_pp)
    
    cfg = [];
    ft_databrowser(cfg,tmpdata)
    
    % SaveData
    mkdir([R.paths.datapath '\FTData\processed\'])
    save([R.paths.datapath '\FTData\processed\' R.expSet.prefix '_trialDefined_' R.expSet.seshnames{cond} '.mat'],'ftdata_pp');
    
end