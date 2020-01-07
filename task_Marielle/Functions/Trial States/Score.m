function th = Score(holdScore,ntrials)
if nargin>2
    th.String = [num2str(holdScore) ' out of ' num2str(ntrials) ' correct'];
else
    th = text(1.2,0.8,[num2str(holdScore) ' out of ' num2str(ntrials) ' correct'], 'FontSize', 25);
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
end
hold on;
drawnow

