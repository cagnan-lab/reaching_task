%% Script to try LabJack


clear;
close all
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));
load('Tmp_keys')

% Callibration timings
tarTim = ...
    [0 5;  % Fixation
    5 10; % N
    10 15;% NW
    15 20;% W
    20 25;% SW
    25 30;% S
    30 35;% SE
    35 40;% E
    40 45;% NE
    ];
C = 0;
N = 0.75; S = -0.75;
E = 0.75; W = -0.75;

tarLoc = [...
    C C;% Fixation
    C N;% N
    W N;% NW
    W C;% W
    W S;% SW
    C S;% S
    E S;% SE
    E C;% E
    E N;% NE
    ];

% Setup the frame



disp('get ready!')
pause(2)
tic
tc = toc;
i = 1;
p = 2;
v = 0;

FigH   = figure('Color', ones(1, 3), 'Renderer', 'Painters');
axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
WindowAPI(FigH, 'Position', 'full');  % To fill monitor

th = text(0.5,0.5,'Start of new session!!!', 'FontSize', 25);
set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
pause
delete(th);

while toc<45
    tvec(i) = toc;
    
    % get a frame
    handpos(:,:,i) = getHandPos_ms();
    coder(i) = v;
    
    % This is where things are going to be drawn
    if (rem(round(toc,2),0.1)) && i>25
        
        if toc<tarTim(1,2)
            scatter(tarLoc(1,1),tarLoc(1,2),1000,'Marker','x','LineWidth',2)
            set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
            try
                f = matleap_frame_ms;
                handposition(i,:) = f.hands.stabilized_palm_position;
            catch
                handposition(i,:) = nan(1,3);
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
            v = 1;
        elseif toc>=tarTim(p,1) && toc<tarTim(p,2)
            scatter(tarLoc(p,1),tarLoc(p,2),1000,'filled');
            set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
            try
                f = matleap_frame_ms;
                handposition(i,:) = f.hands.stabilized_palm_position;
            catch
                handposition(i,:) = nan(1,3);
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
            v = p;
        elseif toc>=tarTim(p+1,1)
            p = p+1;
            v = p;
        end
        
    end
    
    xlim([-1 1]); ylim([-1 1]); drawnow;
    
    i = i+1;
    pause(0.01)
    disp(toc)
end




