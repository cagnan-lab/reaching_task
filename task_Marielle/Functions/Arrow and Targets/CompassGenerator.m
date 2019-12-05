
function [cmp,dirC] = CompassGenerator(sigma, std)
% function CompassGenerator
% This function generates the plot including the arrows and targets.  
% The arrows include von Mises length and direction which serve as an input 
% for the compass plot. Sigma and STD can be varied (in the main script) to 
% determine the level of uncertainty in the task.  
% Marielle Stam (2019)

% Set list of cardinal dir
cardNames = {'E','NE','N','NW','W','SW','S','SE'};
% Setup the list of desired arrow directions:
vecAng = deg2rad([0 45 90 135 180 225 270 315]);

% Choose direction
dirC = randi(8);
disp(['The chosen direction is ' cardNames{dirC}])

% Setup a vector of mean lengths for each direction
% This will be shifted around such that the target direction always has a
% mean of 1. 
vecScl = circ_vmpdf_ms(vecAng, vecAng(dirC), sigma)';
% Setup the distribution of lengths
dirL = abs(vecScl + std.*randn(1,8));

% Inputs for the compass plot
U = dirL.*cos(vecAng);
V = dirL.*sin(vecAng);

% Plotting compass in existing figure
cmp = compass(U,V); hold on
    delete(findall(gcf,'type','text'));
    delete(findall(gcf,'type','a.GridAlpha'));
    xlim([-1 1]); ylim([-1 1])
    set(gca,'Units','normalized')
    set(gca,'Position',[0 0 1 1])

    
    
