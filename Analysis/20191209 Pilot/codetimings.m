function [decoder,SMRtrialdef,naming] = codetimings(CVM, ampCoder)

% ---- ampCoder = Coder coming from the amplifier of a movement/calibration trial (port #14)
% ---- CVM      = table extracted from trigger calibration measurement

stagedef{length(ampCoder)} = [];

for i = 1:length(ampCoder)
    ampCoder{i, 1} = ampCoder{i, 1}';
    % Try to decode using simple absolute differences
    ampDeCoder = abs(ampCoder{i, 1}-CVM'); % absolute Difference
    [~,decoder] = min(ampDeCoder,[],1);
    
    % Now make a trialdef variable that you can use to segment the data in
    % fieldtrip
    for trialstage = 1:numel(CVM) % loop through number of trial stages
        X = find(decoder==trialstage); % find timings at which trial stage exists
        blocks = SplitVec(X,'consecutive');
        
        % Try to merge blocks that are almost adjacent:
        %         for j = 1:length(blocks)-1
        %             if blocks{j+1,1}(1) - blocks{j,1}(end) < 200
        %                 blocks{j,1} = [blocks{j,1}', blocks{j+1,1}']';
        %             end
        %         end
        
        % Now loop through number of instances/stage repetitions SR
        nmx = [];
        for SR = 1:numel(blocks)
            nmx(SR) = numel(blocks{SR});
            trialdef{trialstage}(:,SR) = [blocks{SR}(1) blocks{SR}(end)]; % i.e. take first and last samples of each block
            % Make sure begin samples are not allocated to a trial stage:
            if trialdef{1,trialstage}(1) == 1
                trialdef{1,trialstage}(:,1) = [];
            end
        end
        % Remove very small blocks
        trialdef{trialstage}(:,nmx<32) = [];
    end
    stagedef{i} = trialdef;
end

naming = {'MS_7' 'MS_9' 'MS_10' 'MS_11' 'MS_13' 'MS_14' 'MS_15' 'MS_16' 'MS_17'};
SMRtrialdef = [naming; stagedef]';
