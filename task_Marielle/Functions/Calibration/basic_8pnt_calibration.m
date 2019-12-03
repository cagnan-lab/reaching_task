function basic_8pnt_calibration(id)

clear; close all;


[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));

% Callibration timings
tarTim = ...
    [0 5;  % Fixation
    5 10; % N
    10 15;% NW
    15 20;% W
    20 25;% SW
    25 30;% S
    30 35;% SE
    35 40;% E
    40 45;% NE
    ];
C = 0;
N = 0.75; S = -0.75;
E = 0.75; W = -0.75;

tarLoc = [...
    C C;% Fixation
    C N;% N
    W N;% NW
    W C;% W
    W S;% SW
    C S;% S
    E S;% SE
    E C;% E
    E N;% NE
    ];

% Setup the frame
ScreenSetup()

disp('Make sure sensor can see all targets... hit any button to start calibration')
pause

disp('get ready!')
pause(2)
gca
tic
tc = toc;
i = 1;
gca; shg
p = 2;
v = 0;

while toc<45
    tvec(i) = toc;
    
    % get a frame
    handpos(:,:,i) = getHandPos();
    coder(i) = v;

    % This is where things are going to be drawn
    if (rem(round(toc,2),0.1)) && i>25
        
        if toc<tarTim(1,2)
            scatter(tarLoc(1,1),tarLoc(1,2),1000,'Marker','x','LineWidth',2)
            set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
            v = 1;
            
        elseif toc>=tarTim(p,1) && toc<tarTim(p,2)
            scatter(tarLoc(p,1),tarLoc(p,2),1000,'filled');
            set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[]);
            v = p;
            
        elseif toc>=tarTim(p+1,1)
            p = p+1;
            v = p;
            
        end
        xlim([-1 1]); ylim([-1 1]); drawnow;
        
    end
    
    i = i+1;
    pause(0.01)
    disp(toc)
    
end

for i = 1:5
    X = squeeze(handpos(i,1,:)); 
    Y = squeeze(handpos(i,2,:));
    Z = squeeze(handpos(i,3,:));
    
    plot3(X,Z,Y)                            % I think this would visualize it the best.
    xlabel('X'); ylabel('Z'); zlabel('Y');
    hold on
end

%%

% Get index fingerdisp(['Mean Sample Rate was ' sprintf(mean(diff(tvec)))])

i = 2;
X = squeeze(handpos(i,1,:));
Y = squeeze(handpos(i,2,:));
Z = squeeze(handpos(i,3,:));
    
% subplot(2,1,1)
% plot(tvec,X,tvec,Y)
% subplot(2,1,2)
% plot(tvec,coder)
% % W = 4; E = 8
% ind = NaN(250,9);
% for i = 1:size(ind,2)
%     ind(1:length(find(coder==i)),i) = find(coder==i);
% end

FIX_ind = find(coder==1);
N_ind   = find(coder==2);
NW_ind  = find(coder==3);
W_ind   = find(coder==4);
SW_ind  = find(coder==5);
S_ind   = find(coder==6);
SE_ind  = find(coder==7);
E_ind   = find(coder==8);
NE_ind  = find(coder==9);

XWestLeap = mean([      nanmean(X(W_ind(1)+60:max(W_ind)))          % + 60 indices because transfer time from point to point
                        nanmean(X(NW_ind(1)+60:max(NW_ind)))        % rmmissing to correct for when hand is out of camera sight
                        nanmean(X(SW_ind(1)+60:max(SW_ind))) ]);
XEastLeap = mean([      nanmean(X(E_ind(1)+60:max(E_ind)))
                        nanmean(X(NE_ind(1)+60:max(NE_ind)))
                        nanmean(X(SE_ind(1)+60:max(SE_ind))) ]);
YSouthLeap = mean([     nanmean(Y(S_ind(1)+60:max(S_ind)))
                        nanmean(Y(SW_ind(1)+60:max(SW_ind)))
                        nanmean(Y(SE_ind(1)+60:max(SE_ind))) ]);
YNorthLeap = mean([     nanmean(Y(N_ind(1)+60:max(N_ind)))
                        nanmean(Y(NW_ind(1)+60:max(NW_ind)))
                        nanmean(Y(NE_ind(1)+60:max(NE_ind))) ]);
[XKey,YKey] = getTransform([W E S N],[XWestLeap XEastLeap YSouthLeap YNorthLeap]);
save([cd 'testData/Keys_' id],'XKey','YKey');

% Maybe we could implement the [0,0] (= fix) coordinate in the getTransform as well?
% I have the feeling we're missing out on the calibration points that we
% don't use. 


[XFix, YFix]        	= applyTransform(nanmean(X(FIX_ind(1)+60:max(FIX_ind))), nanmean(Y(FIX_ind(1)+60:max(FIX_ind))), XKey, YKey);
[XNorth,YNorth]         = applyTransform(nanmean(X(N_ind(1)+60:max(N_ind))), nanmean(Y(N_ind(1)+60:max(N_ind))), XKey, YKey);
[XNorthWest,YNorthWest] = applyTransform(nanmean(X(NW_ind(1)+60:max(NW_ind))), nanmean(Y(NW_ind(1)+60:max(NW_ind))) ,XKey, YKey);
[XWest,YWest]           = applyTransform(nanmean(X(W_ind(1)+60:max(W_ind))), nanmean(Y(W_ind(1)+60:max(W_ind))), XKey, YKey);
[XSouthWest,YSouthWest] = applyTransform(nanmean(X(SW_ind(1)+60:max(SW_ind))), nanmean(Y(SW_ind(1)+60:max(SW_ind))),XKey,YKey);
[XSouth,YSouth]         = applyTransform(nanmean(X(S_ind(1)+60:max(S_ind))), nanmean(Y(S_ind(1)+60:max(S_ind))),XKey,YKey);
[XSouthEast,YSouthEast] = applyTransform(nanmean(X(SE_ind(1)+60:max(SE_ind))), nanmean(Y(SE_ind(1)+60:max(SE_ind))),XKey,YKey);
[XEast,YEast]           = applyTransform(nanmean(X(E_ind(1)+60:max(E_ind))), nanmean(Y(E_ind(1)+60:max(E_ind))),XKey,YKey);
[XNorthEast,YNorthEast] = applyTransform(nanmean(X(NE_ind(1)+60:max(NE_ind))), nanmean(Y(NE_ind(1)+60:max(NE_ind))),XKey,YKey);

% Next work out the degree of error for prediction
X_error = mean([abs(XFix) abs(XNorth) abs(XSouth) abs(XWest-W) abs(XNorthWest-W) abs(XSouthWest-W) abs(XEast-E) abs(XNorthEast-E) abs(XSouthEast-E)]); 
Y_error = mean([abs(YFix) abs(YWest) abs(YEast) abs(YNorth-N) abs(YNorthEast-N) abs(YNorthWest-N) abs(YSouth-S) abs(YSouthEast-S) abs(YSouthWest-S)]);
save('Error', 'X_error', 'Y_error');

