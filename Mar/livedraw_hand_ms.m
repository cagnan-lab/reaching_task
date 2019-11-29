% Function to live draw the hand position (stabilized palm position used as
% input). 
function handpos = livedraw_hand_ms
close all
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));


disp('get ready!')
pause(2)
tic
tc = toc;
i = 1;
gca; shg
while toc<8
    tvec(i) = toc;
    % get a frame
    try
        f = matleap_frame_ms;
        handpos(i,:) = f.hands.stabilized_palm_position;
    catch
            handpos(i,:) = nan(1,3);
    end
    if (rem(round(toc,2),0.1)) && i>25
        disp(toc)  
        scatter(squeeze(handpos(i-25:i,1)),squeeze(handpos(i-25:i,2)),[],'filled')
        xlim([-300 300]);ylim([-300 300]);
            drawnow
    end
    
    i = i+1;
    pause(0.01)
    disp(toc)
   
end


% 
% for i = 1:5
% X = squeeze(handpos(i,1,:));
% Y = squeeze(handpos(i,2,:));
% Z = squeeze(handpos(i,3,:));
% 
% plot3(X,Y,Z)
% xlabel('X'); ylabel('Y'); zlabel('Z');
% hold on
% end
