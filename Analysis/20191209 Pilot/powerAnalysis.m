clear; close all
R = add_ReachingTask_paths([1 2]);

%% Setup data organization
% R.expSet.seshnums = {[7,9,14,15,17],[10,11,13,16]}; % choose sessions (divide in conditions)
% R.expSet.seshnames = {'Low Prec','High Prec'}; % condition names
% R.expSet.prefix = 'PrecCTRT';

R.expSet.seshnums = {[7,10,13,14,15],[9,11,16,17]}; % choose sessions (divide in conditions)
R.expSet.seshnames = {'GAYK','GBYK'}; % condition names
R.expSet.prefix = 'ExecCTRT';

R.expSet.stagenames = {'MotorPrep','MotorExec'}; % names of stages of experiment of interest

%% GAYK
cond = 1; stage = 1;
load([R.paths.datapath '\FTData\processed\' R.expSet.prefix '_trialDefined_' R.expSet.seshnames{cond} '.mat'],'ftdata_pp');

cfg = [];
cfg.trials  = find(ftdata_pp.trialinfo==stage);
cfg.method =  'mtmfft';
cfg.taper = 'dpss';
cfg.foi        = [4:1:70];
cfg.tapsmofrq  = 2;
cfg.keeptrials  = 'yes'
freq = ft_freqanalysis(cfg,ftdata_pp);

X = squeeze(mean(freq.powspctrm(:,7,:),1));
XV = squeeze(std(freq.powspctrm(:,7,:),1));

%% GBYK
cond = 2; stage = 1;
load([R.paths.datapath '\FTData\processed\' R.expSet.prefix '_trialDefined_' R.expSet.seshnames{cond} '.mat'],'ftdata_pp');

cfg = [];
cfg.trials  = find(ftdata_pp.trialinfo==stage);
cfg.method =  'mtmfft';
cfg.taper = 'dpss';
cfg.foi        = [4:1:70];
cfg.tapsmofrq  = 2;
cfg.keeptrials  = 'yes'
freq = ft_freqanalysis(cfg,ftdata_pp);

Y = squeeze(mean(freq.powspctrm(:,7,:),1));
YV = squeeze(std(freq.powspctrm(:,7,:),1));
foi = find(freq.freq>=10 & freq.freq<=14);

% Adjust effect size
Y(foi) = Y(foi).*1.3;

% Estimate Cohen's D
(mean(X(foi))-mean(Y(foi)))./mean([YV(foi); XV(foi)])

% make N realizations
for n = 1:200
    XREP(:,n) = (XV.*randn(size(X,1),1))+X;
    YREP(:,n) = (YV.*randn(size(Y,1),1))+Y;
end

figure
 plot(freq.freq,XREP(:,1:5:end)','b')
 hold on
 plot(freq.freq,YREP(:,1:5:end)','r')
grid on
 ylim([0 0.7])
xlabel('Hz'); ylabel('Power')

plot(freq.freq(foi),repmat(0.5,size(foi)),'Color','k','LineWidth',4)

alphaL = NaN; tL = NaN;
for n = 2:150
    for rep = 1:50
        rind = randi(200,1,n);
        XSamp = mean(XREP(foi,rind),1);
        YSamp = mean(YREP(foi,rind),1);
        
        [h,p,ci,stats] = ttest(XSamp,YSamp);
        alphaL(rep) = p;
        tL(rep) = stats.tstat;
    end
    alphaLR(n) = mean(alphaL);
    tLR(n) = mean(tL);
    rejRate(n) = (sum(alphaL>0.01)./size(tL,2));
    
    
end

figure
plot(1:150,alphaLR)
xlabel('Sample Size')
ylabel('T-test significance Level')
yyaxis right
plot(1:150,rejRate)
ylabel('False Rejection Rate')
grid on
xlim([1 75])