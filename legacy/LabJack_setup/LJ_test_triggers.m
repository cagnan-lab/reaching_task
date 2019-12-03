% Script to test trigger activation (DAC0) and recording (AIN0) for LabJack
% U3-HV
clear; close all
[ljasm,ljudObj,ljhandle] = setup_LabJack();

tic
L = 1;
while L < 5e3
    t = toc;
    
            vout = 2.*sin(0.5*pi*t);
        ljudObj = sendLJTrigger(ljudObj,ljhandle,vout,0);

%     if rem(round(t),2)
%         vout = 2.*sin(0.5*pi*t);
%         ljudObj = sendLJTrigger(ljudObj,ljhandle,vout,0);
%     else
%         ljudObj = sendLJTrigger(ljudObj,ljhandle,0,0);
%     end
    v1 = getLJMeasurement(ljudObj,ljhandle,2);
    v2 = getLJMeasurement(ljudObj,ljhandle,3);
    v(L) = v2-v1;
%     v(L) = getLJBPMeasurement(ljudObj,ljhandle,3,2);
    tme(L) = t;
    L = L + 1;
    disp(L)
end
    

plot(tme,v.*1000)
xlabel('Time'); ylabel('AIN3 Measurement (mV)')