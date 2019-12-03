function [XS,YS] = applyTransform(XL,YL,XKey,YKey)
% Applies linear transform to leap motion coordinates in order to map to
% screen space.

XS = (XL- XKey(1))*XKey(2) + XKey(3);
YS = (YL- YKey(1))*YKey(2) + YKey(3);