function SMRcoder = CoderSMR(SMR_data)

for i = 1:length(SMR_data)
coder{i}  = SMR_data{i, 2}(14).imp.adc;
end

naming = {'MS_2' 'MS_4' 'MS_5' 'MS_7' 'MS_8' 'MS_9' 'MS_10' 'MS_11' 'MS_12' 'MS_13' 'MS_14' 'MS_15' 'MS_16' 'MS_17'};
SMRcoder = [naming; coder]';