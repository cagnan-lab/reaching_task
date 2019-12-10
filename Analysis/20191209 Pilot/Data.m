clear; close all; clc;

addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Spike-smr-reader\smrReader');

SMR_data = LoadSMR();

% plot(Data.MS_2(1).imp.adc)
% 
% Data.MS_4(1).imp.tim(2)/
% 
% Data.MS_2(1).hdr.tim.Units*length(Data.MS_2(1).imp.adc)