clear; close all
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));


disp('get ready!')
pause(2)
tic
tc = toc;
i = 1;
gca; shg
while toc<15
    tvec(i) = toc;
    % get a frame
    try
        f=matleap_frame;
        handpos(:,:,i) = vertcat(f.pointables.position);
    catch
            handpos(:,:,i) = nan(5,3);
    end
    if (rem(round(toc,2),0.1)) && i>25
        disp(toc)  
        scatter3(squeeze(handpos([1],1,i-25:i)),squeeze(handpos([1],3,i-25:i)),squeeze(handpos([1],2,i-25:i)),linspace(10,150,26),'filled')
        xlim([-300 300]);ylim([-300 300]); zlim([-300 300]);
                drawnow
    end
    
    i = i+1;
    pause(0.01)
    disp(toc)
   
end


for i = 1:5
X = squeeze(handpos(i,1,:));
Y = squeeze(handpos(i,2,:));
Z = squeeze(handpos(i,3,:));

plot3(X,Y,Z)
xlabel('X'); ylabel('Y'); zlabel('Z');
hold on
end
