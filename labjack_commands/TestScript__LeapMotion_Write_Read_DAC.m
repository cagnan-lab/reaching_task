clear; close all
%% Always make sure this is at the top of your script as it sets up the labjack for analogue output.
% make sure the LJTick DIOA is plugged into FI04 on the main board.
[ljasm,ljudObj,ljhandle] = setup_LabJack();

% You can then use the assembly, object and handle for calling labjack
% functions later on in the script (to write to output)

% I have written the following function to make writing easy. Just input
% the control voltages in the order of channels given within the function.
% Test Voltages
V(1) = 2; % send 0.5v to DAC0
V(2) = 1.5; % send 1v to DAC1
V(3) = 2; % send 1.5v to DACA
V(4) = 2.5; % send 2v to DACB

% Now write
ljudObj = sendLJ4DACOut(ljudObj,ljhandle,V);

%% Now were going to use a loop and another function (read) to check if the analogue
% outputs will work:
% Read from AIN3 (labelled FIO3)- you should wire from your output DAC to
% this channel.

[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));

i =1;tic;
t = 0;
while t<30
    t(i)= toc;
    
    allPos(:,:,i) = getHandPos();
    X = squeeze(allPos(2,1,i));
    Y = squeeze(allPos(2,2,i));
    Z = squeeze(allPos(2,3,i));
    
    % Rescale
    minmax = [-120 120];
    V(1) = 0;
    V(2) = rescaleLeap(X,[-250 250]);
    V(3) = rescaleLeap(Y,[-150 350]);
    V(4) = rescaleLeap(Z,[-250 250]);
    
    % Now send to LabJack; V(1) = coder; V(2-4) = XYZ leap
    ljudObj = sendLJ4DACOut(ljudObj,ljhandle,V);
    
    v(i) = readLJ4DACIn(ljudObj,ljhandle,3);
    
    if rem(i,20) == 0
        plot(t,v)
        xlim([t(i)-10 t(i)])
        drawnow
    end
    i = i+1;
end
fsamp = 1./mean(diff(t));
save([cd '/testData/Hand'], 'allPos');