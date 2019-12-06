function th = Score(scr,ntrial,th)
if nargin>2
    th.String = [num2str(scr) ' out of ' num2str(ntrial) ' correct'];
else
    th = text(1.2,-0.8,[num2str(scr) ' out of ' num2str(ntrial) ' correct'], 'FontSize', 25);
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
end
drawnow
