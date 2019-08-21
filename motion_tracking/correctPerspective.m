function [transVidFrame,perspTrans] = correctPerspective(vidFrame,perspTrans)
if nargin<2
    % 5.1 Undoing Perspective Distortion of Planar Surface
    % a)
    
    %book=imread('trapezoid.jpg');
    imshow(vidFrame);
    
    % b)
    fprintf('Corner selection must be top left corner and clockwise.\n');
    [X Y] = ginput(4);
    
    %if ispolycw(X, Y) % if the coordinates are not clockwise, sort them clockwise
    %    [X, Y] = poly2cw(X, Y)
    %end
    
    %X = uint8(X);
    %Y = uint8(Y);
    [X Y] = sortPolyFromClockwiseStartingFromTopLeft( X, Y );
    
    % Get target edge lengths
    Xe = sort(X);
    Xe = mean([diff(Xe([1 4])) diff(Xe([2 3]))]);
    
    Ye = sort(Y);
    Ye = mean([diff(Ye([1 4])) diff(Ye([2 3]))]);
    
    x=[1;Xe;Xe;1];
    y=[1;1;Ye;Ye];
    
    % c)
    A=zeros(8,8);
    A(1,:)=[X(1),Y(1),1,0,0,0,-1*X(1)*x(1),-1*Y(1)*x(1)];
    A(2,:)=[0,0,0,X(1),Y(1),1,-1*X(1)*y(1),-1*Y(1)*y(1)];
    
    A(3,:)=[X(2),Y(2),1,0,0,0,-1*X(2)*x(2),-1*Y(2)*x(2)];
    A(4,:)=[0,0,0,X(2),Y(2),1,-1*X(2)*y(2),-1*Y(2)*y(2)];
    
    A(5,:)=[X(3),Y(3),1,0,0,0,-1*X(3)*x(3),-1*Y(3)*x(3)];
    A(6,:)=[0,0,0,X(3),Y(3),1,-1*X(3)*y(3),-1*Y(3)*y(3)];
    
    A(7,:)=[X(4),Y(4),1,0,0,0,-1*X(4)*x(4),-1*Y(4)*x(4)];
    A(8,:)=[0,0,0,X(4),Y(4),1,-1*X(4)*y(4),-1*Y(4)*y(4)];
    
    v=[x(1);y(1);x(2);y(2);x(3);y(3);x(4);y(4)];
    
    u=A\v;
    %which reshape
    
    U=reshape([u;1],3,3)';
    
    w=U*[X';Y';ones(1,4)];
    w=w./(ones(3,1)*w(3,:));
    
    % d)
    %which maketform
    T=maketform('projective',U');
    
    tardim(1,:) = [1 Xe];
    tardim(2,:) = [1 Ye];
    
    perspTrans.tardim = tardim;
perspTrans.trans = T;

end
%which imtransform
transVidFrame=imtransform(vidFrame,perspTrans.trans,'XData',perspTrans.tardim(1,:),'YData',perspTrans.tardim(2,:));

% e)
% imshow(transVidFrame)