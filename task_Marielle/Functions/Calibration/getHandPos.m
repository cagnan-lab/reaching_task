function handpos = getHandPos()
% This acquires data of five fingers from the LeapMotion to use for calibration. 
% Requires matleap_frame function.

    try
        f=matleap_frame;
        handpos = vertcat(f.pointables.position);
    catch
            handpos = nan(5,3);
    end