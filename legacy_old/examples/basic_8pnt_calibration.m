clear; close all
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));

% Callibration timings
tarTim = ...
    [0 5;  % Fixation
    5 10; % N
    10 15;% NW
    15 20;% W
    20 25;% SW
    25 30;% S
    35 40;% SE
    45 50;% E
    50 55;% NE
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
figure(2);
xlim([-1 1]); ylim([-1 1])
set(gcf,'color','w');
set(gcf, 'MenuBar', 'none');
set(gcf, 'ToolBar', 'none');
set(gcf, 'Units', 'normalized');
set(gcf, 'outerposition', [0 0 1 1]);
set(gca, 'visible', 'off');
% disp('  Create a figure:');
% FigH   = figure('Color', ones(1, 3), 'Renderer', 'Painters');
% FigPos = get(FigH, 'Position');
% axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
%    TextH = text(0.5, 0.5, ' Demo: WindowAPI ', ...
%       'Units',    'normalized', ...
%       'FontSize', 20, ...
%       'HorizontalAlignment', 'center', ...
%       'BackgroundColor',     [0.4, 0.9, 0.0], ...
%       'Margin',   12);
% xlim([-1 1]); ylim([-1 1])
%    WindowAPI(FigH, 'Position', 'full');  % To fill monitor
%    WindowAPI(FigH, 'maximize'); % To maximize


disp('Make sure sensor can see all targets... hit any button to continue calibration')
pause




disp('get ready!')
pause(2)
gca
tic
tc = toc;
i = 1;
gca; shg
p = 2;

while toc<55
    tvec(i) = toc;
    
    % get a frame
    handpos(:,:,i) = getHandPos();
    
    % This is where things are going to be drawn
    if (rem(round(toc,2),0.1)) && i>25
        
        if toc<tarTim(1,2)
            scatter(tarLoc(1,1),tarLoc(1,2),1000,'Marker','x','LineWidth',2)
            set(gca,'xcolor','none'); set(gca,'ycolor','none');
        elseif toc>=tarTim(p,1) && toc<tarTim(p,2)
            scatter(tarLoc(p,1),tarLoc(p,2),1000,'filled');
            set(gca,'xcolor','none'); set(gca,'ycolor','none');
        elseif toc>=tarTim(p+1,1)
            p = p+1;
        end
        
        xlim([-1 1]); ylim([-1 1]); drawnow;
        
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
    hold on
end


