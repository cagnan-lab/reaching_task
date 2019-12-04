function [cmp,cir,dirC] = Reach(sigma, std)

% Plotting compass
[cmp,dirC] = CompassGenerator(sigma, std);
    
% Set WHITE colour and line width of compass:
for i=1:length(cmp)
set(cmp(i),'LineStyle','none')
end 

% Plotting Circles
cir = CirclePlot();

% Set BLACK colour and line width of circles:
for i=1:length(cir)
set(cir(i), 'MarkerEdgeColor','k', 'linewidth', 2)
end

drawnow

% For when the old CirclePlot is still used (the not-scatter):
% for i=1:length(cir)
% set(cir(i), 'Color', [0 0 0], 'linewidth', 2)
% end