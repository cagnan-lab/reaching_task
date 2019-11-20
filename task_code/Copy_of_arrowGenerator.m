clear; clc; close all;

ntrials = 3;
ntargets = 15;
ntotaltargets = ntrials * ntargets;

%% Generate Arrows

% Set list of cardinal directions
cardNames = {'E','NE','N','NW','W','SW','S','SE'};
% Setup the list of desired arrow directions:
vecAng = deg2rad([0 45 90 135 180 225 270 315]);
% Setup a vector of mean lengths for each direction
% This will be shifted around such that the target direction always has a
% mean of 1. 
dirC = zeros(ntotaltargets,1);
for j = 1:ntotaltargets
    dirC(j) = randi(8);
end
disp(['The chosen direction is ' cardNames{dirC}])

% vecScl = [0.1 0.5 0.75 1 0.75 0.5 0.1 0];
vecScl = circ_vmpdf(vecAng, vecAng(dirC), 0.25)';

% This is the std of the length of each 
sigma = 0.5;
sigma = vecScl.*sigma;
% If this could be variable then we can fix the randomness to be equivalent
% to the coefficient of variation i.e. smaller arrows have smaller variance

% Setup the distribution of lengths
% Choose direction
dirL = abs(vecScl + sigma.*randn(1,8));
% dirL = circshift(dirL,dirC-4);

%% Generate targets

% Target location:
E = [1.6 0];
NE = [1.1 0.7];
N = [0 0.8];
NW = [-1.1 0.7];
W = [-1.6 0];
SW = [-1.1 -0.7];
S = [0 -0.8];
SE = [1.1 -0.7];

for i = 1:ntotaltrials
if dirC(i) == 1
    dirC(i) = E;
elseif dirC(i) == 2
    dirC(i) = NE;
elseif dirC(i) == 3
    dirC(i) = N;
elseif dirC(i) == 4
    dirC(i) = NW;
elseif dirC(i) == 5
    dirC(i) = W;
elseif dirC(i) == 6
    dirC(i) = SW;
elseif dirC(i) == 7
    dirC(i) = S;
elseif dirC(i) == 8
    dirC(i) = SE;
end
end

% Target size
size = randi(2);
if size == 1
    radius = 0.15;
else
    radius = 0.25;
end


%% Main experiment

% ----- Experiment explanation. Show strings until pressing any key. 

% Give quick recap of instructions and wait for input
txt_instructions = {'Start of first session!!!';
    'In this session you are asked to rest, reach and point.';
    'When you see the cross in the centre please REST.';
    'When you see a cross surrounded by red targets please REACH.';
    'When you see a green target please POINT as accurately as you can!';
    'Good luck!'};

figure('units','normalized','outerposition',[0 0 1 1]);
xlim([-1 1]); ylim([-1 1])
    set(gcf,'color','w');
    set(gcf, 'MenuBar', 'none');   
    set(gcf, 'ToolBar', 'none');
    set(gca, 'Units', 'normalized');
    set(gca, 'Position', [0 0 1 1]);

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

% ----- From here trials start

% Rest posture
scatter(0,0,900,'x');
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);    
pause
clf;

% Plotting compass and following target:
U = dirL.*cos(vecAng);
V = dirL.*sin(vecAng);
    axis equal
compass(U,V); 
    delete(findall(gcf,'type','text'));
pause(2); 
clf;
    xlim([-2 2]); ylim([-1 1])
    set(gca,'Units','normalized')
    set(gca,'Position',[0 0 1 1])
circle(dirC(1), dirC(2), radius);
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])             

function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off
end
% shg