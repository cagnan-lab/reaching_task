%clear; 
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
        f=matleap_frame_ms;
        handpos(:,:,i) = vertcat(f.pointables.position);
%         handpos(:,1,i) = (handpos(:,1,i)+tx)*R;
%         handpos(:,2,i) = (handpos(:,2,i)+ty)*R;
%         handpos(:,3,i) = (handpos(:,3,i)+tz)*R;
    catch
            handpos(:,:,i) = nan(5,3);
    end
    if (rem(round(toc,2),0.1)) && i>25
        disp(toc)  
%         X = (squeeze(handpos(1,1,:))+tx); 
%         Y = (squeeze(handpos(1,2,:))+ty);
%         Z = (squeeze(handpos(1,3,:))+tz);
%         HAND = [X Y Z]*R;
        scatter(squeeze(handpos([1],1,i-25:i)),squeeze(handpos([1],2,i-25:i)),[],'filled')
%         scatter(HAND(1),HAND(2),[],'filled')
%         xlim([-1 1]); ylim([-1 1])
        xlim([-300 300]);ylim([-300 300]); zlim([-300 300]);
    
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