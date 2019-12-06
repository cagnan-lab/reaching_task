function [location, radius] = GenerateTargets()
% This function generates the location and the radius of the circle
% targets.
% Marielle Stam (2019)

% Target location:
E = [0.8 0];
NE = [0.6 0.6];
N = [0 0.8];
NW = [-0.6 0.6];
W = [-0.8 0];
SW = [-0.6 -0.6];
S = [0 -0.8];
SE = [0.6 -0.6];
location = [E; NE; N; NW; W; SW; S; SE];

% Target size
size = randi(2);
if size == 1
    radius = 2000;
else
    radius = 4000;
end
radius = 2000;          % Delete this to include variation in target size