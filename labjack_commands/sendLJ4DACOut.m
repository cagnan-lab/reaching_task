function ljudObj = sendLJ4DACOut(ljudObj,ljhandle,V)
% This function will write to the LabJack analogue outputs using the LJTick-DAC
%extension board. This function takes in the labjack object and device handle. 
%V is a 1x4 list of write voltages.The order of the channels is 1= DAC0;
%2= DAC1; 3= DACA; 4= DACB.


% The first two outputs are the onboard DAC0/1 outputs, so write these
% first:
% DAC0:
ljudObj.eDAC(ljhandle, 0, V(1), 0, 0, 0);       % eDAC (Handle, channel,V, 0, 0, 0); 
% DAC1:
ljudObj.eDAC(ljhandle, 1, V(2), 0, 0, 0);       % eDAC (Handle, channel,V, 0, 0, 0);

% Now you have to do the LJTick DAC slightly differently
% DACA
ljudObj.ePutSS(ljhandle, 'LJ_ioTDAC_COMMUNICATION','LJ_chTDAC_UPDATE_DACA',V(3), 0);
% DACB
ljudObj.ePutSS(ljhandle, 'LJ_ioTDAC_COMMUNICATION','LJ_chTDAC_UPDATE_DACB',V(4), 0); 