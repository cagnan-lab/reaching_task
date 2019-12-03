% Function to live draw the hand position (stabilized palm position used as
% input). 

close all
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));


disp('get ready!')
pause(2)
tic
tc = toc;
i = 1;
gca; shg

% Set up screen
        FigH   = figure('Color', ones(1, 3), 'Renderer', 'Painters');
        FigPos = get(FigH, 'Position');
        axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
        WindowAPI(FigH, 'Position', 'full'); 
        
while toc<8
    tvec(i) = toc;
    % get a frame
    try
        f = matleap_frame_ms;
        handposition(i,:) = f.hands.stabilized_palm_position;
    catch
            handposition(i,:) = nan;
    end
    if (rem(round(toc,2),0.1)) && i>25
        disp(toc)  
        Xleap(i) = squeeze(handposition(i,1));
        Yleap(i) = squeeze(handposition(i,2));
        [Xscreen(i), Yscreen(i)] = applyTransform_ms(Xleap(i), Yleap(i), XKey, YKey);
        % Live draw plot on full screen with screen coordinates:
        scatter(Xscreen(i-20:i), Yscreen(i-20:i),[],'filled')
        set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
        xlim([-1 1]); ylim([-1 1]);
            drawnow;
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
