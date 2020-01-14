function ScreenSetup()
% To set up the screen to full size. 

FigH   = figure('Color', ones(1,3), 'Renderer', 'Painters');
FigPos = get(FigH, 'Position');
axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
WindowAPI(FigH, 'Position', 'full');  % To fill monitor

set(FigH, 'MenuBar', 'none');
set(FigH, 'ToolBar', 'none');
set(gcf,'Position',[3840 19 1913 1034])
