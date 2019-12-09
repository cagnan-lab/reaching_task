clear; close all; clc;

Data = LoadSMR();

plot(Data.MS_2(1).imp.adc)

Data.MS_4(1).imp.tim(2)/

Data.MS_2(1).hdr.tim.Units*length(Data.MS_2(1).imp.adc)