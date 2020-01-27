function ft_data = FT2SMR(SMR_data,names,fsample)
X = [];
for ch = 1:numel(SMR_data)-1
    X(:,ch) = SMR_data(ch).imp.adc;
end

tend    = size(X,1)./fsample;
timeVec = linspace(0,tend,size(X,1));

ft_data.label           = names;
ft_data.fsample         = fsample;
ft_data.trial{1}        = X';
ft_data.time{1}         = timeVec;