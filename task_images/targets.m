close all; clear; clc;

%% Plotting circles

% Rest posture
figure(1)
xlim([-1 1]); ylim([-1 1])
scatter(0,0,500,'x'); hold on

x = zeros(1,8);
y = zeros(1,8);
a = zeros(8,2);
theta = [0.25 0.5 0.75 1 1.25 1.5 1.75 0];      % Arrow angle
rho = 8;                                        % Arrow lengths

for i = 1:8
    x(i) = pol2cart(pi*theta(i), rho);
    y(i) = pol2cart(pi*theta(i),rho);
    
    a(i,i) = x(i);
    a(i,i+1) = y(i);
    
end

plot(a);

% % Completely random Arrow Cues
% drawArrow = @(x,y) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0 )    
% a=[0.1 0.2 0.3];
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x1 = [0 a1(1)];
% y1 = [0 a1(2)];
% figure(1)
% xlim([-1 1]); ylim([-1 1])
% drawArrow(x1,y1); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x2 = [0 a1(1)];
% y2 = [0 0];
% drawArrow(x2,y2); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x3 = [0 a1(1)];
% y3 = [0 -a1(2)];
% drawArrow(x3,y3); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x4 = [0 0];
% y4 = [0 -a1(2)];
% drawArrow(x4,y4); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x5 = [0 -a1(1)];
% y5 = [0 -a1(2)];
% drawArrow(x5,y5); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x6 = [0 -a1(1)];
% y6 = [0 0];
% drawArrow(x6,y6); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x7 = [0 -a1(1)];
% y7 = [0 a1(2)];
% drawArrow(x7,y7); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x8 = [0 0];
% y8 = [0 a1(2)];
% drawArrow(x8,y8);
% pause            % Keep arrows for 2 seconds
% clf;

%% Arrow pointing to future target

target = 1;
target = randperm(numel(target),1);

if target == 1

drawArrow = @(x,y) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0 )    
a=[0.3 0.3 0.3];
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x1 = [0 a1(1)];
y1 = [0 a1(2)];
figure(1)
xlim([-1 1]); ylim([-1 1]);
drawArrow(x1,y1); hold on
a=[0.1 0.2];
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x2 = [0 a1(1)];
y2 = [0 0];
drawArrow(x2,y2); hold on
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x3 = [0 a1(1)];
y3 = [0 -a1(2)];
drawArrow(x3,y3); hold on
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x4 = [0 0];
y4 = [0 -a1(2)];
drawArrow(x4,y4); hold on
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x5 = [0 -a1(1)];
y5 = [0 -a1(2)];
drawArrow(x5,y5); hold on
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x6 = [0 -a1(1)];
y6 = [0 0];
drawArrow(x6,y6); hold on
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x7 = [0 -a1(1)];
y7 = [0 a1(2)];
drawArrow(x7,y7); hold on
indexesToUse = randperm(numel(a),2); % 2 random indexes
a1 = a(indexesToUse);  % Extract 2 values from a
x8 = [0 0];
y8 = [0 a1(2)];
drawArrow(x8,y8);
pause(2)            % Keep arrows for 2 seconds
%clf;

% elseif target == 2
% 
% drawArrow = @(x,y) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0 )    
% a=[0.3 0.3 0.3];
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x1 = [0 a1(1)];
% y1 = [0 a1(2)];
% figure(1)
% xlim([-1 1]); ylim([-1 1]);
% drawArrow(x1,y1); hold on
% a=[0.1 0.2];
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x2 = [0 a1(1)];
% y2 = [0 0];
% drawArrow(x2,y2); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x3 = [0 a1(1)];
% y3 = [0 -a1(2)];
% drawArrow(x3,y3); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x4 = [0 0];
% y4 = [0 -a1(2)];
% drawArrow(x4,y4); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x5 = [0 -a1(1)];
% y5 = [0 -a1(2)];
% drawArrow(x5,y5); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x6 = [0 -a1(1)];
% y6 = [0 0];
% drawArrow(x6,y6); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x7 = [0 -a1(1)];
% y7 = [0 a1(2)];
% drawArrow(x7,y7); hold on
% indexesToUse = randperm(numel(a),2); % 2 random indexes
% a1 = a(indexesToUse);  % Extract 2 values from a
% x8 = [0 0];
% y8 = [0 a1(2)];
% drawArrow(x8,y8);
% pause(2)            % Keep arrows for 2 seconds
% clf;

end

%% Plotting targets

xlim([-1 1]); ylim([-1 1])
circle(0.5, 0.5, 0.2)

