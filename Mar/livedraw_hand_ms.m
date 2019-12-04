% Function to live draw the hand position (stabilized palm position used as
% input). 

close all; clear
load Tmp_keys
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));


disp('get ready!')
pause(2)
tic
tc = toc;
i = 1;

% Set up screen
        Fig_draw   = figure('Color', ones(1,3), 'Renderer', 'Painters');
        axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
%         WindowAPI(Fig_draw, 'Position', 'full'); 
        
while toc<8
    tvec(i) = toc; 
    % get a frame
    handposition(i,:) = AcquireLeap();

    if (rem(round(toc,2),0.1)) && i>25
       LiveDraw(handposition(i-20:end,:), XKey, YKey)
    end
    
    i = i+1;
    pause(0.01)
    disp(toc)
   
end

% figure(900)
% X = handposition(:,1);
% Y = handposition(:,2);
% Z = handposition(:,3);
% 
% plot3(X,Y,Z)
% xlabel('X'); ylabel('Y'); zlabel('Z');
% hold on
