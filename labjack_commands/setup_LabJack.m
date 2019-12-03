function [ljasm,ljudObj,ljhandle] = setup_LabJack()

% Make the UD .NET assembly visible in MATLAB.
ljasm = NET.addAssembly('LJUDDotNet');
ljudObj = LabJack.LabJackUD.LJUD;

% Read and display the UD version.
disp(['UD Driver Version = ' num2str(ljudObj.GetDriverVersion())])

% Open the first found LabJack U3.
[ljerror, ljhandle] = ljudObj.OpenLabJackS('LJ_dtU3', 'LJ_ctUSB', '0', true, 0);

% Start by using the pin_configuration_reset IOType so that all pin
% assignments are in the factory default condition.
ljudObj.ePutS(ljhandle, 'LJ_ioPIN_CONFIGURATION_RESET', 0, 0, 0);

% Configure the LJTick-DAC on digital I/0 FIO4 (SCL) and
% FIO5 (SDA, which is automatically configured and is SCL line + 1)
ljudObj.ePutSS(ljhandle, 'LJ_ioPUT_CONFIG', 'LJ_chTDAC_SCL_PIN_NUM', 4, 0);
