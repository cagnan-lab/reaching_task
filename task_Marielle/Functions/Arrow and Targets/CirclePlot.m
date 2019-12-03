function cir = CirclePlot()
% Plots 8 circle targets.

% Generating possible targets on plot
[location, radius] = GenerateTargets();

cir = zeros(8);
cir(1) = circle(location(1,1), location(1,2), radius); hold on; 
cir(2) = circle(location(2,1), location(2,2), radius); hold on; 
cir(3) = circle(location(3,1), location(3,2), radius); hold on; 
cir(4) = circle(location(4,1), location(4,2), radius); hold on; 
cir(5) = circle(location(5,1), location(5,2), radius); hold on; 
cir(6) = circle(location(6,1), location(6,2), radius); hold on; 
cir(7) = circle(location(7,1), location(7,2), radius); hold on; 
cir(8) = circle(location(8,1), location(8,2), radius); hold on; 
