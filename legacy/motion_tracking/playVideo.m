v = VideoReader(vadd);
v.CurrentTime = 0;
currAxes = axes;
while hasFrame(v)
    vidFrame = readFrame(v);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/v.FrameRate);
end

% t = 
% t =
% t =
% t =
% t =
% t = 
% t = 
% t = 
% t = 

[245.5 124.2 210.4 47.8 95.5 220 84 58]