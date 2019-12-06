function cross = CrossGenerator()

vecAng = deg2rad([0 90 180 270]);

% Setup the distribution of lengths
dirL = 0.07;

% Inputs for the compass plot
U = dirL.*cos(vecAng);
V = dirL.*sin(vecAng);

% Plotting compass in existing figure
cross = compass(U,V);
delete(findall(gcf,'type','text'));
delete(findall(gcf,'type','a.GridAlpha'));
xlim([-1 1]); ylim([-1 1])
set(gca,'Units','normalized')
set(gca,'Position',[0 0 1 1])
ph = allchild(gca);
set(ph(end),'FaceColor','none')