function Set_LJ_Tick_Out(connection_port, channel, value)

% syntax: Set_LJ_Tick_Out(connection_port, channel, value)
% sets the analog output from the labjack when connected to the LJTick_DAC. 
% connection_port is the FIO? closest to GND of the four slots where the
% tick was connected - FIO4 -> connection_port=4.
% channel is which output, 1 being the one closer to the GND slot. 
% rated values are up to +/-10 V, ostensibly 14 bits, i.e. 1.2 mV
% resolution.

ljud_LoadDriver
ljud_Constants

[Error ljHandle] = ljud_OpenLabJack( LJ_dtU3, LJ_ctUSB, '1', 1 );
Error_Message(Error)

Error = ljud_ePut (ljHandle, LJ_ioPIN_CONFIGURATION_RESET, 0, 0, 0);
Error_Message(Error)

[Error] = ljud_ePut( ljHandle, LJ_ioPUT_CONFIG, LJ_chTDAC_SCL_PIN_NUM,connection_port,0);
Error_Message(Error)

if channel==1
	
	[Error] = ljud_ePut( ljHandle, LJ_ioTDAC_COMMUNICATION, LJ_chTDAC_UPDATE_DACA, value, 0);  % setting the output
	Error_Message(Error)
	
elseif channel==2
	
	[Error] = ljud_ePut( ljHandle, LJ_ioTDAC_COMMUNICATION, LJ_chTDAC_UPDATE_DACB, value, 0);  % setting the output
	Error_Message(Error)
	
end