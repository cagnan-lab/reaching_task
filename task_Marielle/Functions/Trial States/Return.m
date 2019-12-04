function Return(cmp, cir, dirC)

% Set target circle back to black edge color:
set(cir(dirC),'MarkerEdgeColor','k','MarkerFaceAlpha',0);

% Remove arrows from middle:
for i=1:length(cmp)
    set(cmp(i),'LineStyle','none');
end

drawnow;