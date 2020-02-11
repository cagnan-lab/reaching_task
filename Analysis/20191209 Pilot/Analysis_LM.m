clear; close all; clc;

SMR_data_MS = LoadSMR();
SMR_coder = CoderSMR(SMR_data_MS);

%% LeapMotion filters

% 1. ----- MS7:
MS7_LMxraw = SMR_data_MS{4, 2}(15).imp.adc;    %  15 = X
MS7_LMyraw = SMR_data_MS{4, 2}(13).imp.adc;    %  13 = Y
MS7_LMzraw = SMR_data_MS{4, 2}(12).imp.adc;    %  12 = Z

MS7_LMxraw = MS7_LMxraw - mean(MS7_LMxraw);           % Offset correction
MS7_LMyraw = MS7_LMyraw - mean(MS7_LMyraw); 
MS7_LMzraw = MS7_LMzraw - mean(MS7_LMzraw); 

    % ACx -- Fourier transform and power spectrum:
    N = length(MS7_LMzraw);
    k = [1:N-1];
    fs = 2048;
    dt = 1/fs;
 
    MS_7LMz = fft(MS7_LMzraw);
    Power7 = (abs(MS_7LMz).^2) / N;
    f = k*(1/(N*dt));
    figure(1)
    plot(f(1:(N/2)), Power7(1:(N/2))); 
    title('FFT powerspectrum van MS 7 LMz')
    xlabel('frequentie (Hz)')
    ylabel('p^2')
    
    freqres = 1/(length(MS7_LMzraw)/fs);
% [Pxx, F] = pwelch(signaal, window, noverlap, [], fs)
    [Pxx, F] = pwelch(MS7_LMzraw, N, [], N, fs);
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
    title('pwelch powerspectrum van MS 7 LMz')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS7_LMz = filtfilt(B, A, MS7_LMzraw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS7_LMz = filtfilt(B, A, MS7_LMz);

    figure(12)
    subplot(3,1,1)
    plot(MS7_LMzraw)
    title('MS 7 LMz offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS7_LMz)
    title('MS 7 LMz filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{4, 2})
    title('MS 7 coder', 'FontSize', 20)

% 2. ----- MS15 Tremor:
MS15_LMxraw = SMR_data_MS{12, 2}(15).imp.adc;    %  15 = X
MS15_LMyraw = SMR_data_MS{12, 2}(13).imp.adc;    %  13 = Y
MS15_LMzraw = SMR_data_MS{12, 2}(12).imp.adc;    %  12 = Z

MS15_LMxraw = MS15_LMxraw - mean(MS15_LMxraw);           % Offset correction
MS15_LMyraw = MS15_LMyraw - mean(MS15_LMyraw);
MS15_LMzraw = MS15_LMzraw - mean(MS15_LMzraw);

    % ACx -- Fourier transform and power spectrum:
    N = length(MS15_LMzraw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_15ACzraw = fft(MS15_LMzraw);
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
    MS15_LMz = filtfilt(B, A, MS15_LMzraw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS15_LMz = filtfilt(B, A, MS15_LMz);

    figure(17)
    subplot(3,1,1)
    plot(MS15_LMzraw)
    title('MS 15 ACz offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS15_LMz)
    title('MS 15 ACz filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{12, 2})
    title('MS 15 coder', 'FontSize', 20)
    
% 3. ----- MS10:
MS10_LMxraw = SMR_data_MS{7, 2}(15).imp.adc;    %  15 = X
MS10_LMyraw = SMR_data_MS{7, 2}(13).imp.adc;    %  13 = Y
MS10_LMzraw = SMR_data_MS{7, 2}(12).imp.adc;    %  12 = Z

MS10_LMxraw = MS10_LMxraw - mean(MS10_LMxraw);           % Offset correction
MS10_LMyraw = MS10_LMyraw - mean(MS10_LMyraw); 

    % EMG1 -- Fourier transform and power spectrum:
    N = length(MS10_LMxraw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_10ACx = fft(MS10_LMxraw);
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
    MS10_LMx = filtfilt(B, A, MS10_LMxraw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS10_LMx = filtfilt(B, A, MS10_LMx);

    figure(10)
    subplot(3,1,1)
    plot(MS10_LMxraw)
    title('MS 10 ACx offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS10_LMx)
    title('MS 10 ACx filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{7, 2})
    title('MS 10 coder', 'FontSize', 20)

