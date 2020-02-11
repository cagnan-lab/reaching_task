
SMR_data_MS = LoadSMR();
SMR_coder = CoderSMR(SMR_data_MS);

%% EMG filters

% 1. ----- MS7:
MS7_EMG1raw = SMR_data_MS{4, 2}(10).imp.adc;
MS7_EMG2raw = SMR_data_MS{4, 2}(11).imp.adc;

MS7_EMG1raw = MS7_EMG1raw - mean(MS7_EMG1raw);           % Offset correction
MS7_EMG2raw = MS7_EMG2raw - mean(MS7_EMG2raw); 

    % EMG1 -- Fourier transform and power spectrum:
    N = length(MS7_EMG1raw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_7EMG1 = fft(MS7_EMG1raw);
    Power7 = (abs(MS_7EMG1).^2) / N;
    f = k*(1/(N*dt));
    figure()
    plot(f(1:(N/2)), Power7(1:(N/2))); 
    title('powerspectrum van MS 7 EMG1')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS7_EMG1 = filtfilt(B, A, MS7_EMG1raw);         % Cutoff at 200 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS7_EMG1 = filtfilt(B, A, MS7_EMG1);

    figure(7)
    subplot(3,1,1)
    plot(MS7_EMG1raw)
    title('MS 7 EMG1 offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS7_EMG1)
    title('MS 7 EMG1 filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{4, 2})
    title('MS 7 coder', 'FontSize', 20)

% 2. ----- MS15 Tremor:
MS15_EMG1raw = SMR_data_MS{12, 2}(10).imp.adc;
MS15_EMG2raw = SMR_data_MS{12, 2}(11).imp.adc;

MS15_EMG1raw = MS15_EMG1raw - mean(MS15_EMG1raw);           % Offset correction
MS15_EMG2raw = MS15_EMG2raw - mean(MS15_EMG2raw); 

    % EMG1 -- Fourier transform and power spectrum:
    N = length(MS15_EMG1raw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_15EMG1 = fft(MS15_EMG1raw);
    Power15 = (abs(MS_15EMG1).^2) / N;
    f = k*(1/(N*dt));
    figure()
    plot(f(1:(N/2)), Power15(1:(N/2))); 
    title('powerspectrum van MS 15 EMG1')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS15_EMG1 = filtfilt(B, A, MS15_EMG1raw);         % Cutoff at 70 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS15_EMG1 = filtfilt(B, A, MS15_EMG1);

    figure(15)
    subplot(3,1,1)
    plot(MS15_EMG1raw)
    title('MS 15 EMG1 offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS15_EMG1)
    title('MS 15 EMG1 filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{12, 2})
    title('MS 15 coder', 'FontSize', 20)
    
% 3. ----- MS10:
MS10_EMG1raw = SMR_data_MS{7, 2}(10).imp.adc;
MS10_EMG2raw = SMR_data_MS{7, 2}(11).imp.adc;

MS10_EMG1raw = MS10_EMG1raw - mean(MS10_EMG1raw);           % Offset correction
MS10_EMG2raw = MS10_EMG2raw - mean(MS10_EMG2raw); 

    % EMG1 -- Fourier transform and power spectrum:
    N = length(MS10_EMG1raw);
    k = [1:N-1];
    dt = 1/1000;
 
    MS_10EMG1 = fft(MS10_EMG1raw);
    Power10 = (abs(MS_10EMG1).^2) / N;
    f = k*(1/(N*dt));
    figure()
    plot(f(1:(N/2)), Power10(1:(N/2))); 
    title('powerspectrum van MS 10 EMG1')
    xlabel('frequentie (Hz)')
    ylabel('p^2') 

    % Filtering:
    fs = 2048;
    fc = 200;
    Wn = fc / (fs/2);
    [B, A] = butter(2, Wn); 
    MS10_EMG1 = filtfilt(B, A, MS10_EMG1raw);         % Cutoff at 70 Hz

    fc1 = 48;
    Wn1 = fc1 / (fs/2);
    fc2 = 52;
    Wn2 = fc2 / (fs/2);
    [B, A] = butter(2, [Wn1, Wn2], 'stop');         % Bandstop for 50 Hz
    MS10_EMG1 = filtfilt(B, A, MS10_EMG1);

    figure(10)
    subplot(3,1,1)
    plot(MS10_EMG1raw)
    title('MS 10 EMG1 offset corrected', 'FontSize', 20)
    subplot(3,1,2)
    plot(MS10_EMG1)
    title('MS 10 EMG1 filtered', 'FontSize', 20)
    subplot(3,1,3)
    plot(SMR_coder{7, 2})
    title('MS 10 coder', 'FontSize', 20)

