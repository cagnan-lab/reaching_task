% Wauw very ugly, but it allows us to change the sigma and std to values
% for us to determine how large the uncertainty of the task is. 


sigma   = 1.5;
std     = 0.01;
i = 0;

while i < 3
    figure(1)
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 0.7, 0.96]);
    [cmp,cir,dirC] = Reach(sigma, std);
    MotorPrep(cmp,cir)
    pause()
    MotorExec(cmp, cir, dirC)
    pause()
    clf;
    i = i+1;
end
close all;
    
