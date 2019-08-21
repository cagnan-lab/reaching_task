function voltage = getLJBPMeasurement(ljudObj,ljhandle,P,N)  

% Take a single-ended measurement from AIN3.
    channelP = P;
    channelN = N;
    voltage = 0.0;
    range = 0;  % Not applicable for the the U3
    resolution = 0;
    settling = 0;
    binary = 0;
    [ljerror, voltage] = ljudObj.eAIN(ljhandle, channelP, channelN, voltage, range, resolution, settling, binary);
    disp(['AIN3 = ' num2str(voltage) ' V'])