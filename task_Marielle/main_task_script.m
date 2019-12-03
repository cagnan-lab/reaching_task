clear; clc; close all;

%function condition = arrowGenerator_ms(condition)

%% Generate targets

% Target location:
E = [0.8 0];
NE = [0.6 0.6];
N = [0 0.8];
NW = [-0.6 0.6];
W = [-0.8 0];
SW = [-0.6 -0.6];
S = [0 -0.8];
SE = [0.6 -0.6];

% Target size
size = randi(2);
if size == 1
    radius = 0.15;
else
    radius = 0.25;
end
radius = 0.15;          % Delete this to include variation in target size

%% 

% Set list of cardinal dir
cardNames = {'E','NE','N','NW','W','SW','S','SE'};
% Setup the list of desired arrow directions:
vecAng = deg2rad([0 45 90 135 180 225 270 315]);
% Setup a vector of mean lengths for each direction
% This will be shifted around such that the target direction always has a
% mean of 1. 
dirC = randi(8);
disp(['The chosen direction is ' cardNames{dirC}])

% vecScl = [0.1 0.5 0.75 1 0.75 0.5 0.1 0];
sigma = 0.5;
vecScl = circ_vmpdf_ms(vecAng, vecAng(dirC), sigma)';

% This is the std of the length of each 
std = 0.1;
% sigma = vecScl.*sigma;
% If this could be variable then we can fix the randomness to be equivalent
% to the coefficient of variation i.e. smaller arrows have smaller variance

% Setup the distribution of lengths
% Choose direction
dirL = abs(vecScl + std.*randn(1,8));
% dirL = circshift(dirL,dirC-4);


%% Main experiment

for i = 1:4
    condition = i;
end

% ----- Experiment explanation before every condition. Show strings until pressing any key. 

%Give quick recap of instructions and wait for input
txt_instructions = {'Start of new session!!!';
    'In this session you are asked to rest, hold a posture, reach and point.';
    'When you see "You can rest", please REST your hands on your lap.';                 % We can swap these actions
    'When you see "Wing Beating Postural Hold", please HOLD POSTURE as explained.';
    'When you see the cross in the centre please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};

FigTwo   = figure('Color', ones(1,3), 'Renderer', 'Painters');
FigPos = get(FigTwo, 'Position');
axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
WindowAPI(FigTwo, 'Position', 'full');  % To fill monitor

% Waiting for key presses: matlab "pause"
for i=1:7
    ah = gca;
    th = text(1,1,txt_instructions{i}, 'FontSize', 25);
    set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    pause
    delete(th);
end
clf; 


%% ----- From here trials start

close all; clear
load Tmp_keys
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));

tic
i = 1;

% --- 1. REST
% Requires plot with text saying "please rest your arm". 

FigH   = figure('Color', ones(1, 3), 'Renderer', 'Painters');
axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
WindowAPI(FigH, 'Position', 'full');  % To fill monitor

th = text(0.5,0.5,'Please rest your arm', 'FontSize', 25);
% sendLJTrigger(ljudObj, ljhandle, v(3,1), channel); 
set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
pause(3)                    % Adjust this to the desired timings
delete(th);

% --- 2. POSTURE HOLD
% Requires plot (maybe image) of how to hold the posture (fingers pointing
% towards each other - wing beating). 

th = text(0.5,0.5,'Please hold the wing beating posture', 'FontSize', 25);
% sendLJTrigger(ljudObj, ljhandle, v(3,1), channel); 
set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
pause(3)                    % Adjust this to the desired timings
delete(th);

% --- 3. REACHING POSTURE
% I don't know. I can't find a way to plot the leapmotion scatter on top of the fixation cross. 

while toc < 10
    hold off 
       handposition(i,:) = AcquireLeap();
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
    
    scatter(0,0,1200,'x'); hold on
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
end
pause
clf;

%% --- 4. Plot compass and circles in one plot for MOTOR PREPARATION
    % Plotting compass and following target:
    U = dirL.*cos(vecAng);
    V = dirL.*sin(vecAng);

    % Set up figure and screen:
cmp = compass(U,V); hold on
    delete(findall(gcf,'type','text'));
    delete(findall(gcf,'type','a.GridAlpha'));
    xlim([-1 1]); ylim([-1 1])
    set(gca,'Units','normalized')
    set(gca,'Position',[0 0 1 1])
cir = zeros(8);
cir(1) = circle(E(1), E(2), radius); hold on; 
cir(2) = circle(NE(1), NE(2), radius); hold on; 
cir(3) = circle(N(1), N(2), radius); hold on; 
cir(4) = circle(NW(1), NW(2), radius); hold on; 
cir(5) = circle(W(1), W(2), radius); hold on; 
cir(6) = circle(SW(1), SW(2), radius); hold on; 
cir(7) = circle(S(1), S(2), radius); hold on; 
cir(8) = circle(SE(1), SE(2), radius); hold on; 
    % Set colours and line width of plot:
    for i=1:length(cmp)
    set(cmp(i),'Color',[0 0 0],'linewidth',2)
    set(cir(i), 'Color', [0 0 0], 'linewidth', 2)
    end 
    
pause(3)

% --- 5. MOTOR EXECUTION - changing the color of one arrow with according circle to green.
    set(cmp(dirC),'Color',[0 1 0],'linewidth',2)
    set(cir(dirC), 'Color', [0 1 0], 'linewidth', 2)

    
% ----- Functions used 

% Plotting circles:
function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off
end
% shg