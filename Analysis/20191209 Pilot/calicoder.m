function CVM = calicoder(SMR_coder)

% CVM: coder for trial stages
% 1 = Postural Hold
% 2 = Reach
% 3 = Motor Preparation
% 4 = Motor Execution
% 5 = Other not distinguishable.. 

calicoder = SMR_coder{12,2};      % Take MS_15 as calibration trial for coder:
% plot(calicoder)

% Extract trial stages of first stage repetition from plot:
posture = mean(calicoder(18750:23650));
reach = mean(calicoder(23820:26810));
motorprep = mean(calicoder(27130:30680));
motorexec = mean(calicoder(30890:33740));
% hold = mean(calicoder(34130:42040));
% back = mean(calicoder(42540:47180));
other = 128000;

% CVM = [posture reach motorprep motorexec hold back]; 
CVM = [posture reach motorprep motorexec other]; 