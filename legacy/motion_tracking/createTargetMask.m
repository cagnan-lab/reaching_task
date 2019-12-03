function [BW,maskedRGBImage,tarCentre,tarRef] = createTargetMask(RGB,t)
if nargin<3
    axis ij;
    axis manual;
    [m n] = size(RGB);  %%d1 is the image which I want to display
    axis([0 m 0 n])
    i = imshow(RGB);
    h = imellipse;
    position = wait(h);
    
end
BW = createMask(h,i);
s=regionprops(BW,'Centroid');
tarCentre = s.Centroid;
maskedRGBImage = RGB;
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

imshow(maskedRGBImage)

ref = round(ginput(1));
tarRef = (RGB(ref(2),ref(1),:));


