
function LeapScatter = LiveDraw(handposition, XKey, YKey)
% This one plots the leapmotion pointer on the screen. It takes the
% calibration keys from (calibration fx) and the current leapmotion
% coordinates in order to plot in screen space.
% Marielle Stam (2019)

disp(toc)
Xleap = squeeze(handposition(1:20,1));
Yleap = squeeze(handposition(1:20,2));
[Xscreen, Yscreen] = applyTransform_ms(Xleap, Yleap, XKey, YKey);
% Live draw plot on full screen with screen coordinates:
scatter(Xscreen, Yscreen,[],'filled')
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
xlim([-1 1]); ylim([-1 1]);
drawnow;

end

% In script:
%             if (rem(round(toc,2),0.1)) && i>25
%                 disp(toc)
%                 Xleap(i) = squeeze(handposition(i,1));
%                 Yleap(i) = squeeze(handposition(i,2));
%                 [Xscreen(i), Yscreen(i)] = applyTransform_ms(Xleap(i), Yleap(i), XKey, YKey);
%                 % Live draw plot on full screen with screen coordinates:
%                 scatter(Xscreen(i-20:i), Yscreen(i-20:i),[],'filled')
%                 set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
%                 xlim([-1 1]); ylim([-1 1]);
%                 drawnow;
%             end