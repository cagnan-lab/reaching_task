function data = LoadSMR()
% To load the SMR data into Matlab. 
% Definition channels:      EEG:    EMG:                LeapMotion:     Accelerometer:  Mark:             
%                           1. Fz   10. EMG1 (flexor)   12. Z           16. AcY         19. Mark
%                           2. Cz   11. EMG2 (extensor) 13. Y           17. AcX
%                           3. Oz                       14. Coder       18. AcZ    
%                           4. O1                       15. X
%                           5. O2
%                           6. C3
%                           7. C4
%                           8. F3
%                           9. F4

data_MS2 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_2.smr']);      % #1
data_MS4 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_4.smr']);      % #2
data_MS5 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_5.smr']);      % #3  
data_MS7 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_7.smr']);      % #4
data_MS8 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_8.smr']);      % #5
data_MS9 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_9.smr']);      % #6
data_MS10 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_10.smr']);    % #7    
data_MS11 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_11.smr']);    % #8
data_MS12 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_12.smr']);    % #9
data_MS13 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_13.smr']);    % #10
data_MS14 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_14.smr']);    % #11
data_MS15 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_15.smr']);    % #12
data_MS16 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_16.smr']);    % #13
data_MS17 = ImportSMR(['C:\Users\marie\OneDrive\Documenten\Oxford\Data\SMR Data\ms_17.smr']);    % #14


SMR = {data_MS2 data_MS4 data_MS5 data_MS7 data_MS8 data_MS9 data_MS10 data_MS11 data_MS12 data_MS13 data_MS14 data_MS15 data_MS16 data_MS17};
naming = {'MS_2' 'MS_4' 'MS_5' 'MS_7' 'MS_8' 'MS_9' 'MS_10' 'MS_11' 'MS_12' 'MS_13' 'MS_14' 'MS_15' 'MS_16' 'MS_17'};
data = [naming; SMR]';


