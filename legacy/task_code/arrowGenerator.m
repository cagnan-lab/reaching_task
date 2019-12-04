clear; clc; close all;

%% Generate Arrows

% Set list of cardinal dir
cardNames = {'E','NE','N','NW','W','SW','S','SE'};
% Setup the list of desired arrow directions:
vecAng = wrapToPi( deg2rad([0 45 90 135 180 225 270 315]));
% Setup a vector of mean lengths for each direction
% This will be shifted around such that the target direction always has a
% mean of 1. 
dirC = 1; %randi(8);
disp(['The chosen direction is ' cardNames{dirC}])

% vecScl = [0.1 0.5 0.75 1 0.75 0.5 0.1 0];
sigma = 0.5;
vecScl = circ_vmpdf(vecAng, vecAng(dirC), sigma)';

% This is the std of the length of each 
std = 0.1;
% sigma = vecScl.*sigma;
% If this could be variable then we can fix the randomness to be equivalent
% to the coefficient of variation i.e. smaller arrows have smaller variance

% Setup the distribution of lengths
% Choose direction
dirL = abs(vecScl + sigma.*randn(1,8));
% dirL = circshift(dirL,dirC-4);

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

%% Main experiment

% ----- Experiment explanation. Show strings until pressing any key. 

%Give quick recap of instructions and wait for input
txt_instructions = {'Start of first session!!!';
    'In this session you are asked to rest, hold a posture, reach and point.';
    'When you see the cross in the centre please REST.';
    'When you see a cross surrounded by red targets please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};

figure(2);
xlim([-1 1]); ylim([-1 1])
    set(gcf,'color','w');
    set(gcf, 'MenuBar', 'none');   
    set(gcf, 'ToolBar', 'none');
    set(gcf, 'Units', 'normalized');
    set(gcf, 'outerposition', [0 0 1 1]);
    set(gca, 'visible', 'off');

% Waiting for key presses: matlab "pause"
for i=1:5
    ah = gca;
    th = text(1,1,txt_instructions{i}, 'FontSize', 25);
    set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    pause
    delete(th);
end
clf; 

%% ----- From here trials start

% 1. REST
% Requires plot with text saying "please rest your arm". 

% 2. POSTURE HOLD
% Requires plot (maybe image) of how to hold the posture (fingers pointing
% towards each other). 

% 3. REACHING POSTURE
scatter(0,0,1200,'x');
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);    
pause
clf;

% 4. Plot compass and circles in one plot for MOTOR PREPARATION
    % Plotting compass and following target:
    U = dirL.*cos(vecAng);
    V = dirL.*sin(vecAng);

    % Set up figure and screen:
    axis equal
    xlim([-2 2]); ylim([-1 1])
    set(gca,'Units','normalized')
    set(gca,'Position',[0 0 1 1])
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]) 

cmp = compass(U,V); hold on
    delete(findall(gcf,'type','text'));
    delete(findall(gcf,'type','a.GridAlpha'));
    xlim([-2 2]); ylim([-1 1])
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

% 5. MOTOR EXECUTION
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

