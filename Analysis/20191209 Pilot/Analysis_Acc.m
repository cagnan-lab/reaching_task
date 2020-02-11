clear; close all; clc;

SMR_data_MS = LoadSMR();
SMR_coder = CoderSMR(SMR_data_MS);

%% Accelerometer (16, 17, 18) filters

% 1. ----- MS7:
MS7_ACxraw = SMR_data_MS{4, 2}(17).imp.adc;    %  17 = X
MS7_ACyraw = SMR_data_MS{4, 2}(16).imp.adc;    %  16 = Y
MS7_ACzraw = SMR_data_MS{4, 2}(18).imp.adc;    %  18 = Z

MS7_ACxraw = MS7_ACxraw - mean(MS7_ACxraw);           % Offset correction
MS7_ACyraw = MS7_ACyraw - mean(MS7_ACyraw); 
MS7_ACzraw = MS7_ACzraw - mean(MS7_ACzraw); 

    % ACx -- Fourier transform and power spectrum:
    N = length(MS7_ACxraw);
    k = [1:N-1];
    fs = 2048;
    dt = 1/fs;
 
    MS_7ACx = fft(MS7_ACxraw);
    Power7 = (abs(MS_7ACx).^2) / N;
    f = k*(1/(N*dt));
    figure(1)
    plot(f(1:(N/2)), Power7(1:(N/2))); 
    title('FFT powerspectrum van MS 7 ACx')
    xlabel('frequentie (Hz)')
    ylabel('p^2')
    
    freqres = 1/(length(MS7_ACxraw)/fs);
% [Pxx, F] = pwelch(signaal, window, noverlap, [], fs)
    [Pxx, F] = pwelch(MS7_ACxraw, N, [], N, fs);
    figure(2)
    plot(F, Pxx)
%  - window = aantal samples/segment (default: N/8)
%  - noverlap = aantal samples overlag (default 50%)
% Hoe meer segmenten, hoe beter artefacten uitmiddelen, maar hoe lager de resolutie van de frequentie-as 
% Vuistregels
% - minstens twee perioden van laagste frequentie per segment 
% - maximaal 50% overlap (dit is ook wat matlab instelt)
% Methode van Welch SHEET
% Met de methode van Welch ten opzichte van fft, treedt er meer leakage op (vanwege lagere frequentie-resolutie)
% - te zien aan de grafiek dat de eerste twee pieken volgens fft samengeklonterd zijn bij Welch 
    title('pwelch powerspectrum van MS 7 ACx')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS7_ACx = filtfilt(B, A, MS7_ACxraw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS7_ACx = filtfilt(B, A, MS7_ACx);

    figure(7)
    subplot(3,1,1)
    plot(MS7_ACxraw)
    title('MS 7 ACx offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS7_ACx)
    title('MS 7 ACx filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{4, 2})
    title('MS 7 coder', 'FontSize', 20)

% 2. ----- MS15 Tremor:
MS15_ACxraw = SMR_data_MS{12, 2}(17).imp.adc;    %  17 = X
MS15_ACyraw = SMR_data_MS{12, 2}(16).imp.adc;    %  16 = Y
MS15_ACzraw = SMR_data_MS{12, 2}(18).imp.adc;    %  18 = Z

MS15_ACxraw = MS15_ACxraw - mean(MS15_ACxraw);           % Offset correction
MS15_ACyraw = MS15_ACyraw - mean(MS15_ACyraw);
MS15_ACzraw = MS15_ACzraw - mean(MS15_ACzraw);

    % ACx -- Fourier transform and power spectrum:
    N = length(MS15_ACzraw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_15ACzraw = fft(MS15_ACzraw);
    Power15 = (abs(MS_15ACzraw).^2) / N;
    f = k*(1/(N*dt));
    figure()
    plot(f(1:(N/2)), Power15(1:(N/2))); 
    title('powerspectrum van MS 15 ACy')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS15_ACz = filtfilt(B, A, MS15_ACzraw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS15_ACz = filtfilt(B, A, MS15_ACz);

    figure(17)
    subplot(3,1,1)
    plot(MS15_ACzraw)
    title('MS 15 ACz offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS15_ACz)
    title('MS 15 ACz filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{12, 2})
    title('MS 15 coder', 'FontSize', 20)
    
% 3. ----- MS10:
MS10_ACxraw = SMR_data_MS{7, 2}(17).imp.adc;    %  17 = X
MS10_ACyraw = SMR_data_MS{7, 2}(16).imp.adc;    %  16 = Y
MS10_ACzraw = SMR_data_MS{7, 2}(18).imp.adc;    %  18 = Z

MS10_ACxraw = MS10_ACxraw - mean(MS10_ACxraw);           % Offset correction
MS10_ACyraw = MS10_ACyraw - mean(MS10_ACyraw); 

    % EMG1 -- Fourier transform and power spectrum:
    N = length(MS10_ACxraw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_10ACx = fft(MS10_ACxraw);
    Power10 = (abs(MS_10ACx).^2) / N;
    f = k*(1/(N*dt));
    figure()
    plot(f(1:(N/2)), Power10(1:(N/2))); 
    title('powerspectrum van MS 10 ACx')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS10_ACx = filtfilt(B, A, MS10_ACxraw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS10_ACx = filtfilt(B, A, MS10_ACx);

    figure(10)
    subplot(3,1,1)
    plot(MS10_ACxraw)
    title('MS 10 ACx offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS10_ACx)
    title('MS 10 ACx filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{7, 2})
    title('MS 10 coder', 'FontSize', 20)

