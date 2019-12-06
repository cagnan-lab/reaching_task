function PostureHold(id,block,duration)
ScreenSetup()

% Labjack Setup
[ljasm,ljudObj,ljhandle] = setup_LabJack();
% Leapmotion setup
% % load([cd '/testData/Keys_' id],'XKey','YKey');
load([cd '/testData/Keys_MS'],'XKey','YKey');
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));
% LeapMotion minmaxs (effective range of tracking- for voltage scaling)
minmax(:,1) = [-250 250];
minmax(:,2) = [-150 350];
minmax(:,3) = [-250 250];

clf;
v = 1.5;
i = 1;
coder = 1.5;
tic
while toc <= duration
    % Keep track of time
    handposition(:,:,i) = AcquireLeap();           % Acquires stabilized palm position data
    tvec(i) = toc;
    X = squeeze(handposition(2,1,i));
    Y = squeeze(handposition(2,2,i));
    Z = squeeze(handposition(2,3,i));
    V(1) = coder;
    V(2) = rescaleLeap(X,minmax(:,1));
    V(3) = rescaleLeap(Y,minmax(:,2));
    V(4) = rescaleLeap(Z,minmax(:,3));
    sendLJ4DACOut(ljudObj,ljhandle,V);
    
    th = text(0.5,0.5,'Please HOLD your hand at the height of your nose, fingers pointing towards each other', 'FontSize', 25);
    set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    drawnow
    
    i = i + 1;
    % Test LabJack recorder
    v(i)  = getLJMeasurement(ljudObj,ljhandle,3);
    coderSave(i) = coder;
end

clf;

mkdir([cd '\testData\' id])
postureData.tvec = tvec;
postureData.coderSave = coderSave;
postureData.handposition = handposition;
postureData.id = id;
save([cd '\testData\' id '\TrialData' id '_block' num2str(block) '_posture'],'postureData');
