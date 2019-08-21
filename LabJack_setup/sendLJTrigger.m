function ljudObj = sendLJTrigger(ljudObj,ljhandle,v,c)
if nargin<4
    c = 0;
end
% Set DAC0 to 3.0 volts.
channel = c;
voltage = v;
binary = 0;
ljudObj.eDAC(ljhandle, 0, voltage, binary, 0, 0);
disp(['DAC0 set to ' num2str(voltage) ' V'])
