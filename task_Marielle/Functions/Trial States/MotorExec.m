function MotorExec(cmp, cir, dirC,flagExec)
% function to plot the Motor Execution part of the task. 
% Set green colour of arrow and target. Also set line width of compass:
set(cmp(:),'Color',[0 1 0],'linewidth',2)
if flagExec == 1
    set(cir(dirC),'MarkerEdgeColor','g', 'linewidth', 2)
end
drawnow;