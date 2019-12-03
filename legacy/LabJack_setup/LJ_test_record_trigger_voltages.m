% Script to test trigger activation ( DAC0) and recording (AIN0) for LabJack
% U3-HV
clear; close all
[ljasm,ljudObj,ljhandle] = setup_LabJack();

tic
L = 1;
while L < inf
    t = toc;
    v(L)  = getLJMeasurement(ljudObj,ljhandle,3);
    tme(L) = t;
    L = L + 1;
    disp(L)
end
    

plot(tme,v.*1000)
xlabel('Time'); ylabel('AIN3 Measurement (mV)')