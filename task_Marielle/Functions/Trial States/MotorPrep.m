function MotorPrep(cmp,cir)
% function to plot the Motor Preparation part of the task. 
% Set black colour and line width of compass:
for i=1:length(cmp)
set(cmp(i),'LineStyle','-','Color',[0 0 0],'linewidth',2)
end 
drawnow
% % Plotting Circles
% % CirclePlot()
% 
% % % Set black colour and line width of circles:
% % for i=1:length(cir)
% % set(cir(i), 'Color', [0 0 0], 'linewidth', 2)
% % end 