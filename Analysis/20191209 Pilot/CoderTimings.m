clear; close all

calicoder = coder15;
posture = mean(calicoder(18760:23565));
reach = mean(calicoder(23950:26750));
motorprep = mean(calicoder(27200:30630));
motorexec = mean(calicoder(30970:33740));
other = 128000;
CVM = [posture reach motorprep motorexec other];  % Confirmation table

[decoder,trialdef] = codetimings(CVM,ampCoder)


% Switcher
ampCoder = CVM(coder); % This simulates the amplifier readout
ampCoder = circshift(ampCoder,fix(fsamp*0.005)); % Shift to simulate the predepolarization
ampCoder = lowpass(ampCoder,100,fsamp);
ampCoder = ampCoder + (0.01.*randn(1,size(coder,2))); % add some noise
plot(tvec,ampCoder)

% Now try to decode using simple absolute differences
ampDeCoder = abs(ampCoder-CVM'); % absolute Difference
[a,decoder] = min(ampDeCoder,[],1);
plot(tvec,decoder)

% Now make a trialdef variable that you can use to segment the data in
% fieldtrip
for cond = 1:numel(CVM) % loop through number of conditions
    X = find(decoder==cond); % find timings at which condition exists
    blocks = SplitVec(X,'consecutive');
        % Now loop through number of instances
        nmx = [];
        for bl = 1:numel(blocks)
            nmx(bl) = numel(blocks{bl});
            trialdef{cond}(:,bl) = [blocks{bl}(1) blocks{bl}(end)]; % i.e. take first and last samples of each block
        end
        trialdef{cond}(:,nmx<32) = []; % Remove very small blocks
end

% You can now use trialdef{cond} to construct your fieldtrip format data files.



%% The above method will suffice for simply blocking the data. The waverform of the switch confounds
% the exact timing of the decoded signal such that there is a delay from
% the actual start point. This wont matter if were not super keen on
% measuring something like reaction times. However, if the delay is fairly
% constant, then again we can just compensate for this in the calculations.
% I would stick with the above method for now

% % Find switching points
% dampCoder = diff(ampCoder);
% plot(tvec(2:end),dampCoder)
% dzampCoder = abs((dampCoder-mean(dampCoder))./std(dampCoder)); % absolute because we dont care about direction
% 
% switchPoints = find(dzampCoder>3.5);
% switchPoints = SplitVec(switchPoints,'consecutive');
% 
% % Ignore the first and last (artefacts of the filtering we did to simulate)
% list = 1:size(switchPoints,2);
% for i = list
%     trialdef(1,i) = switchPoints{i}(1);
% end

%%


% ---- When Z-score is > 2.5, a peak is recognized for trial MS_15
X15 = diff(coder15);
Z15 = abs((X15-mean(X15))./std(X15));       % These are the z-scores of coder13
peaks = find((Z15) > 2.5);


diffpeaks = diff(peaks);
index = find(diffpeaks>10);

posture     = peaks(1);                     % index that posture starts
reach_1     = peaks(index(1)+1);            % index that reach 1 starts
motorprep_1 = peaks(index(2)+1);            % index that motorprep 1 starts
reach_2     = peaks(index(3)+1);            % index that reach 2 starts
motorprep_2 = peaks(index(4)+1);            % index that motorprep 2 starts
reach_3     = peaks(index(5)+1);            % index that reach 3 starts
motorprep_3 = peaks(index(6)+1);            % index that motorprep 3 starts
reach_4     = peaks(index(7)+1);            % index that reach 4 starts
motorprep_4 = peaks(index(8)+1);            % index that motorprep 4 starts
reach_5     = peaks(index(9)+1);            % index that reach 5 starts
motorprep_5 = peaks(index(10)+1);           % index that motorprep 5 starts

timecoder = zeros(length(coder15),1);
timecoder(posture:reach_1) = 1;                     % 1 = posture hold
timecoder(reach_1:motorprep_1) = 2;                 % 2 = reach
timecoder(motorprep_1:(motorprep_1+2*2048)) = 3;    % 3 = motorprep
timecoder((motorprep_1+2*2048):reach_2) = 0;        % 0 = other
timecoder(reach_2:motorprep_2) = 2;               
timecoder(motorprep_2:(motorprep_2+2*2048)) = 3;
timecoder((motorprep_2+2*2048):reach_2) = 0;        
timecoder(reach_3:motorprep_3) = 2;               
timecoder(motorprep_3:(motorprep_3+2*2048)) = 3;
timecoder((motorprep_3+2*2048):reach_2) = 0;
timecoder(reach_4:motorprep_4) = 2;               
timecoder(motorprep_4:(motorprep_4+2*2048)) = 3;
timecoder((motorprep_4+2*2048):reach_2) = 0;
timecoder(reach_5:motorprep_5) = 2;               
timecoder(motorprep_5:(motorprep_5+2*2048)) = 3;
timecoder((motorprep_5+2*2048):end) = 0;

figure
plot(timeVec15,timecoder)

timercode = timecoder(posture:end);         % Get time CODER starting from posture hold
timervec15 = timeVec15(posture:end);        % Get time VECTOR starting from posture hold
timervec15 = timervec15 - timervec15(1);    % This to shift the graph so that it starts with posture
figure
subplot(2,1,1)
plot(MS_15_ML{1, 1}.tvec,MS_15_ML{1, 1}.coderSave(2:end))
title('MS 15 Coder from Matlab', 'FontSize', 25)
subplot(2,1,2)
plot(timervec15,timercode)
title('MS 15 Coder extracted from LabJack', 'FontSize', 25)
xlabel('Time [sec]', 'FontSize', 18)

% Show correlation between coder from Matlab AND LabJack:
[Ctime15,lagtime15] = xcorr(MS_15_ML{1, 1}.coderSave(2:end),timercode); 
figure
plot(lagtime15,Ctime15./max(Ctime15))
title('Correlation between coder Matlab and extracted coder LabJack', 'FontSize', 20)
xlabel('Lag in samples (fs = 2048)', 'FontSize', 18)
[a, b] = max(Ctime15./max(Ctime15));
sample = lagtime15(b);
lag = sample/fsample;           % Gives lag in seconds of correlation

% Show that sample frequency is equal to measured?
size(coder15,1)./fsample;
ANS = linspace(0,size(coder15,1)./fsample,size(coder15,1));
plot(timeVec15,ANS)

%% ----- Doing by eye just to confirm
posture15 = mean(coder15(18760:23565));

reach15_1 = mean(coder15(23950:26750));
motorprep15_1 = mean(coder15(27200:30630));
motorexec15_1 = mean(coder15(30970:33740));
reach15_2 = mean(coder15(47740:50910));
motorprep15_2 = mean(coder15(51290:55010));
motorexec15_2 = mean(coder15(55340:58090));
reach15_3 = mean(coder15(71920:75150));
motorprep15_3 = mean(coder15(75550:79180));
motorexec15_3 = mean(coder15(79480:82260));
reach15_4 = mean(coder15(95990:99250));
motorprep15_4 = mean(coder15(99650:103300));
motorexec15_4 = mean(coder15(103600:106400));
reach15_5 = mean(coder15(120100:123300));
motorprep15_5 = mean(coder15(123600:127500));
motorexec15_5 = mean(coder15(127800:130600));

reach15 = mean([reach15_1 reach15_2 reach15_3 reach15_4 reach15_5]);
motorprep15 = mean([motorprep15_1 motorprep15_2 motorprep15_3 motorprep15_4 motorprep15_5]);
motorexec = mean([motorexec15_1 motorexec15_2 motorexec15_3 motorexec15_4 motorexec15_5]);
other = 128000;
table = [posture15 reach15 motorprep15 motorexec other];  % Confirmation table

a = zeros(length(coder15),1);
b = zeros(length(coder15),1);
for i = 1:length(coder15)
[a(i),b(i)] = min(abs(coder15(i) - table));          % to make sure every point on the coder belongs to a state
end

figure
plot(b)

%%
z = zeros(length(coder13),1);
timer = zeros(length(coder13),1);
j = 1;
for i = 1:length(coder13)
    z = abs(zscore(coder13(j:i)));
    for k = 1:length(z)
        if z(k) > 4
            timer(i) = 1;
            j = i;
            z = zeros(length(coder13),1);
        end
    end
end

figure
plot(timer)
title('timer coder 13 all')
peaks = find(timer == 1);
find(peaks == 30790)

%% 13.01 17:15u

z = zeros(length(coder13),1);
timer = zeros(length(coder13),1);
j = 1;
for i = 1:length(coder13)
    code = coder13(j:i);
    z = abs(zscore(code));
    if z(end) > 4
        timer(i) = 1;
        j = i;
        z = zeros(length(coder13),1);
    end
end

figure
plot(timer)
title('timer coder 13 all')
peaks = find(timer == 1);
find(peaks == 30792)

%%
j = 1;
i = 31000;
z = abs(zscore(coder13(j:i)));

dz = diff(z)./diff(timeVec13(j:i));
figure(34)
plot(timeVec13(2:i),dz)
title('derivative z-values timeVec13');
