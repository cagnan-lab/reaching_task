function [BW,maskedRGBImage,Iref] = createMask(RGB,tol,Iref)
if nargin<3
   axis ij;
   axis manual;
   [m n] = size(RGB);  %%d1 is the image which I want to display
   axis([0 m 0 n])
   imshow(RGB);
   ref = round(ginput(1));
   Iref = rgb2hsv(RGB(ref(2),ref(1),:));
end
% Convert RGB image to HSV image
I = rgb2hsv(RGB);
% Define thresholds for 'Hue'. Modify these values to filter out different range of colors.
channel1Min = Iref(:,:,1) - tol.*Iref(:,:,1);
channel1Max = Iref(:,:,1) + tol.*Iref(:,:,1);
% Define thresholds for 'Saturation'
channel2Min = Iref(:,:,2) - tol.*Iref(:,:,2);
channel2Max = Iref(:,:,2) + tol.*Iref(:,:,2);
% Define thresholds for 'Value'
channel3Min = Iref(:,:,3) - tol.*Iref(:,:,3);
channel3Max = Iref(:,:,3) + tol.*Iref(:,:,3);
% Create mask based on chosen histogram thresholds
BW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
% Initialize output masked image based on input image.
maskedRGBImage = RGB;
% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

