function [tarTrig] = searchMarkers(RGB,tarBW,tarRef)
% This function just masks and then looks for either red or green
% coloration
for tar = 1:numel(tarBW)
    mask = tarBW{tar};
   
    R = double(RGB(:,:,1));
    R(~mask(:)) = NaN;
    R = nanmean(R(:))/256;
    
    G = double(RGB(:,:,2));
    G(~mask(:)) = NaN;
    G = nanmean(G(:))/256;
    
    B= double(RGB(:,:,3));
    B(~mask(:)) = NaN;
    B = nanmean(G(:))/256;
    
    D = norm([R G B] - (double(squeeze(tarRef{tar}))./256)');
    
    if (D) < 0.2
        tarTrig(tar) = 1;
    else
        tarTrig(tar) = 0;
    end
end

