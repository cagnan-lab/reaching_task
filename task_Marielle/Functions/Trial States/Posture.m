function Posture()

th = text(0.5,0.5,'Please hold your hand at the height of your nose, fingers pointing towards each other', 'FontSize', 25);
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
drawnow