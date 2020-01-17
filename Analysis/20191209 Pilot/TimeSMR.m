function timevec = TimeSMR(SMR_data)

fsample = 2048;

for i = 1:length(SMR_data)
sample(i)  = length(SMR_data{i, 2}(1).imp.adc);
tend(i)    = sample(i)/fsample;
timeVec = linspace(0,tend(i),sample(i));
tvec{i} = timeVec;
end

naming = {'MS_2' 'MS_4' 'MS_5' 'MS_7' 'MS_8' 'MS_9' 'MS_10' 'MS_11' 'MS_12' 'MS_13' 'MS_14' 'MS_15' 'MS_16' 'MS_17'};
timevec = [naming; tvec]';