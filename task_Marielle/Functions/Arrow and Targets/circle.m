function h = circle(x,y,r)
% This generates circles in a plot. 

% Plotting circles:
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit);
hold off
end