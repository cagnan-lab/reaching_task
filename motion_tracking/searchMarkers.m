function [tarTrig] = searchMarkers(RGB,tarBW)
% This function just masks and then looks for either red or green
% coloration
for tar = 1:numel(tarBW)
    mask = tarBW{tar};
    maskedRGBImage = RGB;
    R = single(RGB(:,:,1));
    R(~mask(:)) = NaN;
    R = nanmean(R(:))/256;
 
    G = single(RGB(:,:,2));
    G(~mask(:)) = NaN;
    G = nanmean(G(:))/256;
    
    if R>G
        tarTrig(tar) = 0;
    else
        tarTrig(tar) = 1;
    end
end

