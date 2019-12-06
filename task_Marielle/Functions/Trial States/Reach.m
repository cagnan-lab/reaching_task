function [cross,cmp,cir,dirC,location] = Reach(sigma, std)

% Plotting compass
[cmp,dirC] = CompassGenerator(sigma, std);
    
% Set WHITE colour and line width of compass:
for i=1:length(cmp)
set(cmp(i),'LineStyle','none')
end 

% Plotting cross
cross = CrossGenerator();
for i=1:length(cross)
set(cross(i),'LineStyle','-','Color',[0 0 0],'linewidth',1)
end 

% Plotting Circles
[cir, location] = CirclePlot();

% Set BLACK colour and line width of circles:
for i=1:length(cir)
set(cir(i), 'MarkerEdgeColor','k', 'linewidth', 2)
end

drawnow
