clear; close all

vadd = 'D:\Data\OPM_Tremor_project\Pilot\pilot_220819\Video\MAH07814.mp4';
% Target locations for MAH07814:
frameTars = [245.5 124.2 210.4 47.8 95.5 220 84 58];
markTars = [27.18 247.1]; % first is fixation cross 2) is pointer frame


% % vadd = 'D:\Data\OPM_Tremor_project\Pilot\pilot_220819\Video\MAH07815.mp4';
% % % Target locations for MAH07815:
% % frameTars = [260 139 225.2 62.7 110.4 234.3 99 88];
% % markTars = [42.1 235.5]; % first is fixation cross 2) is pointer frame

% % vadd = 'D:\Data\OPM_Tremor_project\Pilot\pilot_220819\Video\MAH07816.mp4';
% % % Target locations for MAH07816:
% % frameTars = [245.5 124.2 210.4 47.8 95.5 220 84 58];
% % markTars = [27.18 247.1]; % first is fixation cross 2) is pointer frame


v = VideoReader(vadd);
v.CurrentTime = markTars(1);
vidFrame = readFrame(v);
vidFrame = vidFrame.*1.5;
currAxes = axes;
image(vidFrame, 'Parent', currAxes);

% Perspective Correction
[tVidFrame,perspTrans] = correctPerspective(vidFrame);


% Define Target Masks
for tarnum = 1:8
    v.CurrentTime = frameTars(tarnum);
    vidFrame = readFrame(v);
    vidFrame = vidFrame.*1.5;
    currAxes = axes;
    image(vidFrame, 'Parent', currAxes);
    tVidFrame = correctPerspective(vidFrame,perspTrans);
    
    [tarBW{tarnum},maskedRGBImage{tarnum},tarCentre{tarnum},tarRef{tarnum}] = createTargetMask(tVidFrame);
end

% Define Pointer Masks
v.CurrentTime = markTars(2);
vidFrame = readFrame(v);
vidFrame = vidFrame.*1.5;
[BW,maskedRGBImage,Iref] = createMask(vidFrame,0.15);


tline = nan(2,60); scz = (60:-1:1).*1;
ip = 0;
vidTime = NaN;
% Set time to marker
v.CurrentTime = markTars(1);

while hasFrame(v)
    ip = ip + 1;
    vidFrame = readFrame(v).*1.5;
    vidTime(ip) = v.CurrentTime;
    %% Apply Perspective Correction
    tVidFrame = correctPerspective(vidFrame,perspTrans);
    
    %% Determine Markers
    tarTrig(:,ip) = searchMarkers(tVidFrame,tarBW,tarRef);
    
    %% Motion Tracking
    [BW,maskedRGBImage,Iref] = createMask(tVidFrame,0.1,Iref);
    subplot(1,2,1)
    image(tVidFrame, 'Parent', gca);
    subplot(1,2,2)
    img = image(maskedRGBImage, 'Parent', gca); hold on;
    [I,J] = find(BW);
    if ~any([isempty(I) isempty(J)])
        [a Itop] = min(I);
        tline(:,ip) = [I(Itop) J(Itop)];
    else
        tline(:,ip) = NaN; % missing data
    end
    tlineTrunc = tline(:,end-59:end);
    s = scatter(tlineTrunc(2,:),tlineTrunc(1,:),scz,[1 0 0],'filled');
    %         currAxes.Visible = 'off';
    pause(1/v.FrameRate);
    delete(img); delete(s);
    disp(ip)
end

% save('MAH07814','tline','vidTime','tarTrig','tarBW','tarCentre')
% save('MAH07815','tline','vidTime','tarTrig','tarBW','tarCentre','tarRef')
% save('MAH07816','tline','vidTime','tarTrig','tarBW','tarCentre','tarRef')

load('MAH07814','tline','vidTime','tarTrig','tarBW','tarCentre')
% load('MAH07815','tline','vidTime','tarTrig','tarBW','tarCentre','tarRef')
% load('MAH07816','tline','vidTime','tarTrig','tarBW','tarCentre','tarRef')
% 


fsamp = 1./mean(diff(vidTime));
% Decode the triggers
tcode = decodeTrig(tarTrig);
% Find Projection
XY = tline;
XY(:,isnan(XY(1,:))) = [];
XY(:,isnan(XY(2,:))) = [];

[XYproj,S,V] = svd(XY','econ');
XY = tline(1,:);
XY(~isnan(XY)) = XYproj(:,1);

figure(2)
a(1) = subplot(3,1,1)
plot(vidTime./60,tcode);
xlabel('Time'); ylabel('Trigger')
% a(2) = subplot(3,1,2)
% % plot(vidTime./60,tline(1,:)); hold on; plot(vidTime./60,tline(2,:)); hold on;
% plot(vidTime./60,XY);
%
% subplot(3,1,3)
% scatter(tline(1,:),tline(2,:))
%


%% Find distances
Z = tline';
figure(3)
dists = [];
for tar = 1:8
    dists(:,tar) = sqrt((tarCentre{tar}(2)-Z(:,1)).^2 +  (tarCentre{tar}(1)-Z(:,2)).^2);
    subplot(2,4,tar)
    Q = dists(:,tar);
    Q = (Q - min(Q))./(max(Q)-min(Q));
    
    scatter(tline(2,:),tline(1,:),1./Q,'filled')
    hold on
end

% calibrate to screen height
cmPerPixel = 60./perspTrans.tardim(1,2);
distsC = dists.*cmPerPixel
figure(2)
a(2) = subplot(3,1,2);
% plot(vidTime./60,tline(1,:)); hold on; plot(vidTime./60,tline(2,:)); hold on;
plot(vidTime./60,distsC)
xlabel('Time'); ylabel('Distance from Target (cm)'); legend({'N','E','S','W'})

a(3) = subplot(3,1,3)
% plot(vidTime./60,tline(1,:)); hold on; plot(vidTime./60,tline(2,:)); hold on;
plot(vidTime./60,1./distsC);
xlabel('Time'); ylabel('Inverse Distance from Target (cm^-1)'); legend({'N','E','S','W'})

linkaxes(a,'x')

segInds = {};
for tc = 1:8
    vcodes = find(tcode == tc);
    segends = vcodes(find(diff(vcodes)>1));
    %     segsts = sort(vcodes(end-find(diff(vcodes(end:-1:1))<-1)));
    pip = vcodes(1);
    for seg = 1:numel(segends)
        segInds{tc}{seg} = pip:segends(seg);
        pip = vcodes(find(vcodes==segends(seg))+1);
    end
end

rt = nan(4,4);
for tc = 1:8
    for seg = 1:numel(segInds{tc})
        ip = segInds{tc}{seg};
        tseg = linspace(0,numel(ip)./fsamp,numel(ip));
        try
            rt(seg,tc) = tseg(find(distsC(ip,tc)<30,1,'first'));
        catch
            rt(seg,tc) = NaN;
        end
    end
end