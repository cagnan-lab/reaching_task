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

U = dirL.*cos(vecAng);
V = dirL.*sin(vecAng);
compass(U,V)
% shg