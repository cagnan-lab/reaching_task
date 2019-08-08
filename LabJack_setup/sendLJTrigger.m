function ljudObj = sendLJTrigger(ljudObj,ljhandle,v)

% Set DAC0 to 3.0 volts.
    channel = 0;
    voltage = v;
    binary = 0;
    ljudObj.eDAC(ljhandle, 0, voltage, binary, 0, 0);
    disp(['DAC0 set to ' num2str(voltage) ' V'])
