function handposition = AcquireLeap()
% This acquires stabilized palm position data from the LeapMotion to use for the task. 
% Requires matleap_frame function.

    try
        f = matleap_frame;
        handposition = f.hands.stabilized_palm_position;
    catch
        handposition = nan(1,3);
    end