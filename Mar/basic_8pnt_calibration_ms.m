clear; close all
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
    35 40;% SE
    45 50;% E
    50 55;% NE
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
figure(1);
xlim([-1 1]); ylim([-1 1])
set(gcf,'color','w');
set(gcf, 'MenuBar', 'none');
set(gcf, 'ToolBar', 'none');
set(gcf, 'Units', 'normalized');
set(gcf, 'outerposition', [0 0 1 1]);
set(gca, 'visible', 'off');

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

while toc<55
    tvec(i) = toc;
    
    % get a frame
    handpos(:,:,i) = getHandPos_ms();
    
    % This is where things are going to be drawn
    if (rem(round(toc,2),0.1)) && i>25
        
        if toc<tarTim(1,2)
            scatter(tarLoc(1,1),tarLoc(1,2),1000,'Marker','x','LineWidth',2)
            set(gca,'xcolor','none'); set(gca,'ycolor','none');
        elseif toc>=tarTim(p,1) && toc<tarTim(p,2)
            scatter(tarLoc(p,1),tarLoc(p,2),1000,'filled');
            set(gca,'xcolor','none'); set(gca,'ycolor','none');
        elseif toc>=tarTim(p+1,1)
            p = p+1;
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

fix_index   = find(tvec < tarTim(1,2));
N_index     = find(tvec < tarTim(2,2) & tvec > tarTim(2,1));
NW_index    = find(tvec < tarTim(3,2) & tvec > tarTim(3,1));
W_index     = find(tvec < tarTim(4,2) & tvec > tarTim(4,1)); 
SW_index    = find(tvec < tarTim(5,2) & tvec > tarTim(5,1));
S_index     = find(tvec < tarTim(6,2) & tvec > tarTim(6,1));
SE_index    = find(tvec < tarTim(7,2) & tvec > tarTim(7,1));
E_index     = find(tvec < tarTim(8,2) & tvec > tarTim(8,1));
NE_index    = find(tvec < tarTim(9,2) & tvec > tarTim(9,1));

fix_indexcal = fix_index(61:length(fix_index));
N_indexcal = N_index(61:length(N_index));
NW_indexcal = NW_index(61:length(NW_index));
W_indexcal = W_index(61:length(W_index));
SW_indexcal = SW_index(61:length(SW_index));
S_indexcal = S_index(61:length(S_index));
SE_indexcal = SE_index(61:length(SE_index));
E_indexcal = E_index(61:length(E_index));
NE_indexcal = NE_index(61:length(NE_index));

% These are the X, Y, and Z-coordinates of the hand in the Leap Motion
% coordinate system. This means that the values for fix_hand correspond to
% [0 0 z?] on the plot, and N_hand to [0 0.75 z?], etc.. 
fix_hand = mean([X(fix_indexcal), Y(fix_indexcal), Z(fix_indexcal)],1); 
N_hand = mean([X(N_indexcal), Y(N_indexcal), Z(N_indexcal)],1);
NW_hand = mean([X(NW_indexcal), Y(NW_indexcal), Z(NW_indexcal)],1);
W_hand = mean([X(W_indexcal), Y(W_indexcal), Z(W_indexcal)],1);
SW_hand = mean([X(SW_indexcal), Y(SW_indexcal), Z(SW_indexcal)],1);
S_hand = mean([X(S_indexcal), Y(S_indexcal), Z(S_indexcal)],1);
SE_hand = mean([X(SE_indexcal), Y(SE_indexcal), Z(SE_indexcal)],1);
E_hand = mean([X(E_indexcal), Y(E_indexcal), Z(E_indexcal)],1);
NE_hand = mean([X(NE_indexcal), Y(NE_indexcal), Z(NE_indexcal)],1);
handLoc = [fix_hand; N_hand; NW_hand; W_hand; SW_hand; S_hand; SE_hand; E_hand; NE_hand];
    
% for j = 1:length(Z)
%     Z_nul(j) = abs(Z(j))- abs(Z(j));
% end
% Z_nul = Z_nul';

% Creating rotation and translation matrices for the coordinate systems.
handLoc = handLoc';
tarLoc = tarLoc';
N = length(tarLoc);

% calculate the vector P corresponding to projection matrix
P = zeros(2*N,12);
 
for i = 1:N
P(2*i-1,:) = [handLoc(:,i)', 1, 0,0,0,0, -tarLoc(1,i)*handLoc(:,i)', -tarLoc(1,i)];
P(2*i,:) = [0,0,0,0,handLoc(:,i)', 1, -tarLoc(2,i)*handLoc(:,i)', -tarLoc(2,i)];
end
 
[U,S,V] = svd(P'*P);
indx = 12;
eigval_min = S(indx,indx);
m_vect = V(:,indx);
 
% projection matrix M
M = zeros (3,4);
M(1,1:4) = m_vect(1:4);
M(2,1:4) = m_vect(5:8);
M(3,1:4) = m_vect(9:12);

a1 = M(1,1:3)';
a2 = M(2,1:3)';
a3 = M(3,1:3)';
% epsilon = +-1. With -1, a different set of values of rotation matrix 
% and translation vector will be obtained.
epsilon = 1;
 
% value of epsilon = +-1 comes from the fact that if a^2 = 1 then
% a = +-1. A row of rotation matrix has unit magnitude.
prow = epsilon/ norm(a3);
 
r3 = prow*a3;
u0 = prow^2*(a1'*a3);
v0 = prow^2*(a2'*a3);
 
tmp1 = cross(a1,a3);
tmp2 = cross(a2,a3);
 
tmp3 = (tmp1'*tmp2)/(norm(tmp1)*norm(tmp2));
 
% as theta is between 0 to 90, cos(theta) is always positive
tmp3 = abs(tmp3);
 
theta = acosd(tmp3);
 
% sign of alpha &amp;amp; beta depends on sign of focal length of lens. Assuming
% positive focal length
alpha = prow^2*norm(tmp1)*sind(theta);
beta = prow^2*norm(tmp2)*sind(theta);
 
r1 = tmp2/norm(tmp2);
 
r2 = cross(r3,r1);
 
% intrinsic parameters matrix
K = [alpha, -alpha*cotd(theta),u0; ...
    0, beta/sind(theta), v0; ...
    0, 0, 1];  
 
% rotation matrix
R = [r1';r2';r3'];
 
% translation vector
tz = M(3,4)*prow;
ty = (M(2,4)*prow - v0*tz)*sind(theta)/beta;
tx = (M(1,4)*prow-u0*tz+alpha*cotd(theta)*ty)/alpha;

%% 

figure(1);
xlim([-1 1]); ylim([-1 1])
set(gcf,'color','w');
set(gcf, 'MenuBar', 'none');
set(gcf, 'ToolBar', 'none');
set(gcf, 'Units', 'normalized');
set(gcf, 'outerposition', [0 0 1 1]);
set(gca, 'visible', 'off');
scatter(0,0,1000,'Marker','x','LineWidth',2); hold on;
tic
tc = toc;
i = 1;
gca; shg
while toc<15
    tvec(i) = toc;
    % get a frame
    try
        f=matleap_frame_ms;
        handpos(:,:,i) = vertcat(f.pointables.position);
    catch
            handpos(:,:,i) = nan(5,3);
    end
    if (rem(round(toc,2),0.1)) && i>25
        disp(toc)
        scatter(squeeze(handpos([1],1,i-25:i)),squeeze(handpos([1],2,i-25:i)),linspace(10,150,26),'filled')
        xlim([-1 1]); ylim([-1 1])
        set(gca,'xcolor','none'); set(gca,'ycolor','none');
        drawnow
    end
    
    i = i+1;
    pause(0.01)
    disp(toc)
   
end
