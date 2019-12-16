clear; close all; clc;

addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Data');
addpath('C:\Users\marie\OneDrive\Documenten\Oxford\Spike-smr-reader\smrReader');

SMR_data = LoadSMR();
SMR_data = struct2cell(SMR_data);

dt = SMR_data{1,1}(1).hdr.adc.SampleInterval(1) * SMR_data{1,1}(1).hdr.adc.SampleInterval(2);

for i = 1:length(SMR_data)
   totaltime(i) = SMR_data{i, 1}(1).hdr.adc.Npoints * dt;
end

recording = [7 10];
marker = 16;
tvector = [dt:dt:totaltime(recording(1))];
signal = SMR_data{recording(1), 1}(marker).imp.adc;
figure(1)
subplot(2,1,1)
plot(tvector, signal)
    title('Recording MS_10: condition 1 NO TREMOR')
tvector = [dt:dt:totaltime(recording(2))];
signal = SMR_data{recording(2), 1}(marker).imp.adc;
subplot(2,1,2)
plot(tvector,signal)
    title('Recording MS_13: condition 1 TREMOR')
    xlabel('Time')

plot(totaltime(),SMR_data{:, 1}(1).imp.adc)
% 
% Data.MS_4(1).imp.tim(2)/
% 
% Data.MS_2(1).hdr.tim.Units*length(Data.MS_2(1).imp.adc)