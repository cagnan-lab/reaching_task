clear
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));


disp('get ready!')
pause(5)
tic
tc = toc;
i = 1;
while toc<20
    tvec(i) = toc;
    % get a frame
    f=matleap_frame;
    
    handpos(:,:,i) = vertcat(f.pointables.position);
    i = i+1;
    pause(0.01)
    disp(toc)
end


for i = 1:5
X = squeeze(handpos(i,1,:));
Y = squeeze(handpos(i,2,:));
Z = squeeze(handpos(i,3,:));

plot3(X,Y,Z)
hold on
end
