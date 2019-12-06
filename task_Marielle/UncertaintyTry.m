% Wauw very ugly, but it allows us to change the sigma and std to values
% for us to determine how large the uncertainty of the task is.

clear; clc; close all;
% Very Certain:
sigma   = 1.3;
std     = 0.1;
% Not so Certain:
% sigma     = 1;
% std       = 0.15;
i = 0;

while i < 20
    figure(1)
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.7, 0.96]);
    [cmp,cir,dirC] = Reach(sigma, std);
    MotorPrep(cmp,cir)
    pause()
    
    set(cmp(:),'Color',[0 1 0],'linewidth',2)
    set(cir(dirC),'MarkerEdgeColor','g', 'linewidth', 2)
    drawnow;

    pause()
    
    clf;
    i = i+1;
end
close all;

