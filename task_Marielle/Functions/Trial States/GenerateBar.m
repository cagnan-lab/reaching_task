function [bar] = GenerateBar()

% Main Bar:
mainbar = rectangle('Position', [-1 0.4 0.1 0.4], 'EdgeColor','k','FaceColor','w');
hold on;

% Filling Bars:
bar1 = rectangle('Position', [-1 0.4 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar2 = rectangle('Position', [-1 0.45 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar3 = rectangle('Position', [-1 0.5 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar4 = rectangle('Position', [-1 0.55 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar5 = rectangle('Position', [-1 0.6 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar6 = rectangle('Position', [-1 0.65 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar7 = rectangle('Position', [-1 0.7 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar8 = rectangle('Position', [-1 0.75 0.1 0.05], 'EdgeColor','w','FaceColor','w');
hold on;

bar = [bar1 bar2 bar3 bar4 bar5 bar6 bar7 bar8];

