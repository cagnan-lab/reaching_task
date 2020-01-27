function ft_data_cat = mergeFTTrials(datapath,seshnums,stagenames)
for sesh = seshnums
    trialdefcat = [];
    for stage = 1:numel(stagenames)
                try

        X = load([datapath '\TrialDefs\UserInputted\Pilot' stagenames{stage} '_MS_' num2str(sesh) '.mat']); % Can you make all of the trialdefs have a standard name or else it gets really tricky to load in!
        % This method will do for now, but its quite ugly!
            trialdef = X.([stagenames{stage} '_MS_' num2str(sesh)]);
            trialdef = trialdef';
            trialdef(:,3) = 0;
            trialdef(:,4) = stage;
            % column 1 is startinds; 2 is endinds; 3 is trigger offset; 4 is stage
            % code
            trialdefcat = [trialdefcat; trialdef];
                catch
                    warning([datapath '\TrialDefs\UserInputted\Pilot' stagenames{stage} '_MS_' num2str(sesh) '.mat' 'does not exist!'])
        end
    end
    
    % Load in FTdata
    load([datapath '\FTData\raw\ms_' num2str(sesh) '_raw.mat']);
    
    cfg= [];
    cfg.trl = trialdefcat;
    ft_data = ft_redefinetrial(cfg,ft_data);
    
    % Setup for concatanation
    if ~exist('ft_data_cat')
        ft_data_cat = ft_data;
    else
        cfg = [];
        cfg.keepsampleinfo = 'no';
        ft_data_cat = ft_appenddata(cfg, ft_data_cat, ft_data);
    end
end
