function [XKey,YKey] = getTransform(WESN_app,WESN_leap)
% Function to generate the keys for transforming LeapMotion coordination to
% screen coordination.

% WESN is [XWest XEast YSouth YNorth]
Xrange_app = WESN_app(2)-WESN_app(1);
Xrange_leap = WESN_leap(2)-WESN_leap(1);

Yrange_app = WESN_app(4)-WESN_app(3);
Yrange_leap = WESN_leap(4)-WESN_leap(3);

% xS = (xL- WESN_leap(1))*(Xrange_app/Xrange_leap) + WESN_app(1)
XKey = [WESN_leap(1) (Xrange_app/Xrange_leap) WESN_app(1)];
YKey = [WESN_leap(3) (Yrange_app/Yrange_leap) WESN_app(3)];