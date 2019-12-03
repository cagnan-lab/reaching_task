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
    
%     ljudObj.ePutS(ljhandle, 'LJ_ioPUT_CONFIG',4,0, 0);
%     
%     ljudObj.ePutS(ljhandle, 'LJ_ioTDAC_COMMUNICATION',0,1.2, 0);
