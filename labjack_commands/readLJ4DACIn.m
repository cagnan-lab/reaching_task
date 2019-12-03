function voltage = readLJ4DACIn(ljudObj,ljhandle,P)
% This function will read the LabJack analogue output at channel P.

% Take a single-ended measurement from AINP.
    channelP = P;
    channelN = 31; % This is the default for single ended recordings
    range = 0;  % Not applicable for the the U3
    resolution = 0; % Pass a nonzero value to enable QuickSample
    settling = 0; % Pass a nonzero value to enable LongSettling
    binary = 0; % If nonzero (true) the voltage will return binary value
    voltage = 0.00;
    [ljerror, voltage] = ljudObj.eAIN(ljhandle, channelP, channelN, voltage, range, resolution, settling, binary);
%     disp(['AIN3 = ' num2str(voltage) ' V'])