function ljudObj = sendLJTrigger(ljudObj,ljhandle,v,c)
if nargin<4
    c = 1;
end
% Set DAC0 to 3.0 volts.
channel = c;                                            % Errorcode = eDAC (Handle, lngChannel, dblVoltage, lngBinary, lngReserved1, lngReserved2)
voltage = v;
binary = 0;
ljudObj.eDAC(ljhandle, channel, voltage, binary, 0, 0);       % eDAC (Handle, 0, 3.1, 0, 0, 0);   // Set DAC0 to 3.1 volts.
disp(['DAC1 set to ' num2str(voltage) ' V'])
