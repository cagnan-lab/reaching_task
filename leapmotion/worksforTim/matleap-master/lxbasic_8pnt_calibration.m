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
disp('  Create a figure:');
FigH   = figure('Color', ones(1, 3), 'Renderer', 'Painters');
FigPos = get(FigH, 'Position');
axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
%    TextH = text(0.5, 0.5, ' Demo: WindowAPI ', ...
%       'Units',    'normalized', ...
%       'FontSize', 20, ...
%       'HorizontalAlignment', 'center', ...
%       'BackgroundColor',     [0.4, 0.9, 0.0], ...
%       'Margin',   12);
% xlim([-1 1]); ylim([-1 1])
WindowAPI(FigH, 'Position', 'full');  % To fill monitor
%    WindowAPI(FigH, 'maximize'); % To maximize


disp('Make sure sensor can see all targets... hit any button to continue calibration')
pause


try
    
    disp('get ready!')
    pause(2)
    gca
    tic
    tc = toc;
    i = 1;
    gca; shg
    p = 2;
    v = 0;
    while toc<45
        tvec(i) = toc;
        % get a frame
        handpos(:,:,i) = getHandPos();
        coder(i) = v;
        % This is where things are going to be drawn
        if (rem(round(toc,2),0.1)) && i>25
            
            if toc<tarTim(1,2)
                scatter(tarLoc(1,1),tarLoc(1,2),1000,'Marker','x','LineWidth',2)
                set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
                v = 1;
            elseif toc>=tarTim(p,1) && toc<tarTim(p,2)
                scatter(tarLoc(p,1),tarLoc(p,2),1000,'filled');
                set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
                v = p;
            elseif toc>=tarTim(p+1,1)
                p = p+1;
                v = p;
            end
            xlim([-1 1]); ylim([-1 1]); drawnow;
        end
        
        i = i+1;
        pause(0.01)
        disp(toc)
        
        
    end
catch
    close all
end

for i = 1:5
    X = squeeze(handpos(i,1,:));
    Y = squeeze(handpos(i,2,:));
    Z = squeeze(handpos(i,3,:));
    
    plot3(X,Y,Z)
    hold on
end

%%
% Get index fingerdisp(['Mean Sample Rate was ' sprintf(mean(diff(tvec)))])

i = 2;
X = squeeze(handpos(i,1,:));
Y = squeeze(handpos(i,2,:));
Z = squeeze(handpos(i,3,:));
    
subplot(2,1,1)
plot(tvec,X,tvec,Y)
subplot(2,1,2)
plot(tvec,coder)
% W = 4; E = 8
ind = find(coder==4);
mean(X(ind))

[XKey,YKey] = getTransform([-0.75 0.75 -0.75 0.75],[-16 86 302 233]);
[X,Y] = applyTransform(-16,268,XKey,YKey);

% Next work out the degree of error for prediction


% W = [-16 268]
% E = [86 265]
% W -> E
AppXRange = 0.75 - -0.75;
LeapXRange = 86 - -16;

xL = -16;
xS = (xL- -16)*(AppXRange/LeapXRange) + -0.75

% As expression
x = (AppXRange/LeapXRange)*(1- -16);
xS = xL*x + -0.75


% N = [35 302]
% S = [37 233]
% S -> N
AppYRange = 0.75 - -0.75;
LeaYRange = 302 - 233;

yL = 233;
yS = (yL - 233)*(AppYRange/LeaYRange) + -0.75
