function data = LoadSMR_TW(R,SMR2FT_flag,FTSave_flag)
if nargin<3
    SMR2FT_flag = 0;
end
if nargin<4
    FTSave_flag = 0;
end
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
% Channel Defs
names = {'Fz','Cz','Ox','O1','O2','C3','C4','F3','F4','EMG1','EMG2','LMZ','LMY','CODER','LMX','ACCY','ACCX','ACCZ'};
% Flattten Seshnums
seshnums = [R.expSet.seshnums{:}];

p = 0;
for i = seshnums
    p = p+1;
    SMR_data = ImportSMR([R.paths.datapath '\SMR Data\ms_' num2str(i) '.smr']);
    SMR_name = ['MS_' num2str(i)];
    
    if SMR2FT_flag == 1
        fsample = 2048;
        ft_data = FT2SMR(SMR_data,names,fsample);
        if FTSave_flag == 1
            mkdir([R.paths.datapath '\FTData\raw'])
            save([R.paths.datapath '\FTData\raw\ms_' num2str(i) '_raw.mat'],'ft_data');
        end
        data{p} = ft_data;
        
    else % if not then save MS style
        data{p,2} = SMR_data;      % #1
        data{p,1} = SMR_name;
    end
end



