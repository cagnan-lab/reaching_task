clear; close all
tic
t = 1;
% This sets up the display. Ideally we want something that is full screen
% and the axes take up the entirety of the screen.
figure;
set(gcf, 'Position', get(0, 'Screensize'));
shg
axes; xlim([0 2000]); ylim([0 1200]);

% This is our "target" position.
txy = [250 850];

% This sets up the colormap
n = 128;
cmap(:,1) = linspace(1,0,n);  %// Red from 1 to 0
cmap(:,2) = linspace(0,1,n);  %// Green from 0 to 1
cmap(:,3) = zeros(n,1);   %// Blue all zero
% This is the lookup table for the distances
% we use this to set each colour (n=128) to a distance.
% The actual distances are then compared to this in order
% to find the right colour.
disttab = linspace(1,1200,128);

%% This is the main loop
while toc<20
    xy(:,t) = get(0, 'PointerLocation'); % This is a much faster way of getting the mouse location
    % Eventually we can replace this with the matleap call to bring in the
    % leapmotion data
    
    % Every 20th of a second we draw. We wait until after 1000 samples have
    % been recorded to start plotting
    if  rem(toc,0.05)<0.01 && (size(xy,2)>1000)
        distx = sqrt((txy(1)-xy(1,end-1000:1:end)).^2+(txy(2)-xy(2,end-1000:1:end)).^2); % Euclid dist
        [dum cind] = min(abs(distx - disttab')); % compare with lookup table. (note the inverse on distab- this makes a
        % nice table you can
        % search for minimums.
        % THIS:
%         scatter(xy(1,end-1000:1:end),xy(2,end-1000:1:end),(1./sqrt(distx))*5e3,cmap(cind,:),'filled'); % Now plot scatter
        %% OR THIS
        scatter(txy(1),txy(2),(1./sqrt(distx(end)))*5e4,cmap(cind(end),:),'filled');
        xlim([0 2000]); ylim([0 1200]);
        drawnow limitrate
    end
    
    tvec(t) = toc;
    t = t+1;
    pause(0.001)
end

disp(sprintf('Test yielded sampling rate of %3.1f Hz',1/mean(diff(tvec))))