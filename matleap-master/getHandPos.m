function handpos = getHandPos()
    try
        f=matleap_frame;
        handpos = vertcat(f.pointables.position);
    catch
            handpos = nan(5,3);
    end