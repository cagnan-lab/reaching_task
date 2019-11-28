clear; close all
tic
t = 1;
%% Setup MATLEAP
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));

% This sets up the display. Ideally we want something that is full screen
% and the axes take up the entirety of the screen.
% figure;
% set(gcf, 'Position', get(0, 'Screensize'));
disp('  Create a figure:');
FigH   = figure('Color', ones(1, 3), 'Renderer', 'Painters');
FigPos = get(FigH, 'Position');
axes('Visible', 'off', 'Units', 'normalized', 'Position', [0, 0, 1, 1]);
WindowAPI(FigH, 'Position', 'full');  % To fill monitor
shg
axes; xlim([0 2000]); ylim([0 1200]);

% This is our "target" position.
txy = [170  369 -297];

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
    
    handpos(:,:,t) = getHandPos();
    
    xy(:,t) = squeeze(handpos(1,1:3,t)); % This is a much faster way of getting the mouse location
    % Eventually we can replace this with the matleap call to bring in the
    % leapmotion data
    
    % Every 20th of a second we draw. We wait until after 1000 samples have
    % been recorded to start plotting
    if  rem(toc,0.05)<0.01 && (size(xy,2)>2000)
%         distx = sqrt((txy(1)-xy(1,end-2000:1:end)).^2+(txy(2)-xy(2,end-2000:1:end))); % Euclid dist
        distx = sqrt((txy(1)-xy(1,end-2000:1:end)).^2+(txy(2)-xy(2,end-2000:1:end)).^2 +(txy(3)-xy(3,end-2000:1:end)).^2); % Euclid dist
        [dum cind] = min(abs(distx - disttab')); % compare with lookup table. (note the inverse on distab- this makes a
        % nice table you can
        % search for minimums.
        % THIS:
%         scatter(-xy(1,end-2000:1:end),xy(2,end-2000:1:end),(1./sqrt(distx))*5e3,cmap(cind,:),'filled'); % Now plot scatter
        %% OR THIS
        scatter3(xy(1,end-2000:1:end),xy(2,end-2000:1:end),xy(3,end-2000:1:end),(1./sqrt(distx))*5e3,cmap(cind(end),:),'filled');
%         xlim([0 2000]); ylim([0 1200]);
        drawnow limitrate
    end
    
    tvec(t) = toc;
    t = t+1;
    pause(0.001)
end

disp(sprintf('Test yielded sampling rate of %3.1f Hz',1/mean(diff(tvec))))