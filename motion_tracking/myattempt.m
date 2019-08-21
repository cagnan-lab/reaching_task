clear; close all
v = VideoReader('C:\Users\Tim\Documents\Work\Cagnan_Project\reaching_task_piloting\videos\trial_converted_6ofps.mp4');
v.CurrentTime = 60;

vidFrame = readFrame(v);
vidFrame = vidFrame.*2;
currAxes = axes;
image(vidFrame, 'Parent', currAxes);

% Perspective Correction
[tVidFrame,perspTrans] = correctPerspective(vidFrame);

% Define Target Masks
for tarnum = 1:4
    [tarBW{tarnum},maskedRGBImage{tarnum},tarCentre{tarnum},tarRef{tarnum}] = createTargetMask(tVidFrame);
end

v.CurrentTime = 65;
vidFrame = readFrame(v);
vidFrame = vidFrame.*2;
currAxes = axes;
image(vidFrame, 'Parent', currAxes);

tVidFrame = correctPerspective(vidFrame,perspTrans);
% Define Pointer Masks
[BW,maskedRGBImage,Iref] = createMask(vidFrame,0.15);


tline = nan(2,60); scz = (60:-1:1).*1;
ip = 0;
vidTime = NaN;
while hasFrame(v)
    ip = ip + 1;
    vidFrame = readFrame(v).*2;
    vidTime(ip) = v.CurrentTime;
    %% Apply Perspective Correction
    vidFrame = correctPerspective(vidFrame,perspTrans);
    
    %% Determine Markers
    tarTrig(:,ip) = searchMarkers(vidFrame,tarBW);
    
    %% Motion Tracking
    [BW,maskedRGBImage,Iref] = createMask(vidFrame,0.15,Iref);
    subplot(1,2,1)
    image(vidFrame, 'Parent', gca);
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

save('testrun','tline','vidTime','tarTrig','tarBW','tarCentre')

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
figure(3)
dists = [];
for tar = 1:4
dists(:,tar) = sqrt((tarCentre{tar}(2)-Z(:,1)).^2 +  (tarCentre{tar}(1)-Z(:,2)).^2);
subplot(2,2,tar)
Q = dists(:,tar);
Q = (Q - min(Q))./(max(Q)-min(Q));

scatter(tline(1,:),tline(2,:),1./Q,'filled')
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
for tc = 1:6
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
for tc = 3:6
    for seg = 1:numel(segInds{tc})
        ip = segInds{tc}{seg};
        tseg = linspace(0,numel(ip)./fsamp,numel(ip));
        try
            rt(seg,tc-2) = tseg(find(distsC(ip,tc-2)<2,1,'first'));
        catch
            rt(seg,tc-2) = NaN;
        end
    end
end