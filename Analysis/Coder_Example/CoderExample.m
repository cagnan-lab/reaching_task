clear; close all
% Original Coder
fsamp= 2048;
coder = [repmat(1,1,fsamp/2) repmat(2,1,fsamp/4) repmat(3,1,fsamp) repmat(4,1,fsamp/8) repmat(5,1,fsamp) repmat(1,1,fsamp/2) repmat(2,1,fsamp/4) repmat(3,1,fsamp) repmat(4,1,fsamp/8) repmat(5,1,fsamp)];
tvec = linspace(0,size(coder,2)/fsamp,size(coder,2));
plot(tvec,coder);
hold on
% Coder to Voltage Map; (Pick these up from calibration stage)
CVM = [0.5 1 1.5 2 0.1];

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

% Find switching points
dampCoder = diff(ampCoder);
plot(tvec(2:end),dampCoder)
dzampCoder = abs((dampCoder-mean(dampCoder))./std(dampCoder)); % absolute because we dont care about direction

switchPoints = find(dzampCoder>3.5);
switchPoints = SplitVec(switchPoints,'consecutive');

% Ignore the first and last (artefacts of the filtering we did to simulate)
list = 1:size(switchPoints,2);
for i = list
    trialdef(1,i) = switchPoints{i}(1);
end

