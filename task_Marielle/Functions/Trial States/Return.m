function Return(cmp, bar, cir, dirC)

% Set target circle back to black edge color:
set(cir(dirC),'MarkerEdgeColor','k','MarkerFaceAlpha',0);

% Remove arrows from middle:
delete(cmp)

% Remove filling bar:
set(bar(1:8),'FaceColor','w');

% Plotting cross
cross = CrossGenerator();
for i=1:length(cross)
set(cross(i),'LineStyle','-','Color',[0 0 0],'linewidth',1)
end 

drawnow;