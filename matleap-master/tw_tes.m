clear; close all
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));


disp('get ready!')
pause(2)
tic
tc = toc;
i = 1;
while toc<5
    tvec(i) = toc;
    % get a frame
    f=matleap_frame;
    try
        handpos(:,:,i) = vertcat(f.pointables.position);
    catch
        handpos(:,:,i) = nan(10,3);
    end
    
    i = i+1;
    pause(0.01)
    disp(toc)
end


for i = 1:10
    X = squeeze(handpos(i,1,:));
    Y = squeeze(handpos(i,2,:));
    Z = squeeze(handpos(i,3,:));
    
    plot3(X,Y,Z)
    hold on
end

Y = tvec;
X1 = squeeze(handpos(1,1,:));
X2 = squeeze(handpos(6,1,:));

X2(isnan(X1)) = []; Y(isnan(X1)) = []; X1(isnan(X1)) = [];
X1(isnan(X2)) = []; Y(isnan(X2)) = []; X2(isnan(X2)) = [];


% load('elastic_band')
figure
plot(tvec,squeeze(handpos(2,:,:)))

figure
pwelch(X1,100,[],100,100);
hold on
pwelch(X2,100,[],100,100);
xlim([4 48]); set(gca,'Xscale','log');
figure
mscohere(X1,X2,100,[],100,100)




