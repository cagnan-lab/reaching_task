function Allpos = AcquireLeap()
% This acquires stabilized palm position data from the LeapMotion to use for the task. 
% Requires matleap_frame function.
try
    f=matleap_frame;
    handpos = vertcat(f.pointables.position);
    limbpos = vertcat(f.hands.palm_position,f.hands.wrist_position,...
        f.hands.arm_wristPosition,f.hands.arm_elbowPosition);
    Allpos = vertcat(handpos,limbpos);
catch
    Allpos = nan(9,3);
end

if size(Allpos>9)
    Allpos = Allpos(1:9,:);
end