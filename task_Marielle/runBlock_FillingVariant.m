function runBlock_FillingVariant(condition,id,block,ntrials)
%% HARDWARE SETUP
% Screen Setup:
ScreenSetup()
% figure;
% Labjack Setup
% [ljasm,ljudObj,ljhandle] = setup_LabJack();
% Leapmotion setup
load(['C:\Users\marie\OneDrive\Documenten\Oxford\reaching_task\testData\Keys_' id], 'XKey','YKey');
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));
% LeapMotion minmaxs (effective range of tracking- for voltage scaling)
minmax(:,1) = [-250 250];
minmax(:,2) = [-150 350];
minmax(:,3) = [-250 250];

%% DEFINE BLOCK CONDITION
% Sigma and STD determine which condition (1, 2, 3 or 4) it will be:
sigma   = [1.3 1];
std     = [0.1 0.15];

% Determine which uncertainty to use:
if condition == 1                % high precision, go after you know
    sigma = sigma(1);
    std = std(1);
elseif condition == 2            % low precision, go after you know
    sigma = sigma(2);
    std = std(2);
elseif condition == 3            % high precision, go before you know
    sigma = sigma(1);
    std = std(1);
elseif condition == 4            % low precision, go before you know
    sigma = sigma(2);
    std = std(2);
end

%% TRIAL DEFINITIONS
% Timings of 1) posture = 15; 2) reach; 3) prep; 4) exec; 5) hold; 6) return
% timing = [15 20 23 25 30 35];
timing = cumsum([2 2 2 1.5 4 0.2]);   % Include randomness in appearance?

% Setup triggers for labjack (voltages)
v = reshape(linspace(0.5,3,7),7,1);        % Change 1 to 2 if go before you know is included

%% BEGIN EXPERIMENT!
% Experiment explanation before every condition. Show strings until pressing any key.
txt_instructions = TaskInstructions(condition);
clf;
tic
i = 1; % Initialize whole loop counter (THIS COUNTS THE TIME STEP)
trial = 1;
accumulator = 0;
holdScore = 0;
TargetDirection = zeros(ntrials,1);
TrialCorrect = zeros(ntrials,1);
TrialMove = zeros(ntrials,1);
%% SET FLAGS
coder = v(1);
flag_reach = 0;
flag_trial = 1; % This is 1 only if moving to next trial
flag_post = 1;
flag_exec_delay = 0; % This is only used for GBYN - 0 means only arrow goes green
flag_beep = 0; % This flag loads the beep gun!

while trial <= ntrials
    if flag_trial == 1
        TrialStart = toc;
        flag_trial = 0;
    end
    % Keep track of time
    handposition(:,:,i) = AcquireLeap();           % Acquires stabilized palm position data
    tvec(i) = toc;
    X = squeeze(handposition(2,1,i));
    Y = squeeze(handposition(2,2,i));
    Z = squeeze(handposition(2,3,i));
    V(1) = coder;
    V(2) = rescaleLeap(X,minmax(:,1));
    V(3) = rescaleLeap(Y,minmax(:,2));
    V(4) = rescaleLeap(Z,minmax(:,3));
    sendLJ4DACOut(ljudObj,ljhandle,V);
    
    if (rem(round(toc,2),0.1) == 0) %&& i>25 % This sets the frequency at which plots will be refreshed
        
        % --- POSTURE
        if (toc < TrialStart+timing(1)) && flag_post == 1  % Timing 1 to 2 is period of holding posture
            Posture()
            coder = v(1);
            
            % --- REACH
        elseif toc >= (TrialStart+timing(1)) && toc < (TrialStart+timing(2))    % Timing 2 is period of holding reach
            if flag_reach == 0
                [cross,cmp,cir,dirC,location] = Reach(sigma, std);
                flag_reach = 1;
                flag_post = 0;
            end
            th = Score(holdScore,ntrials);
            
            coder = v(2);
            TargetDirection(trial) = dirC;
            
            % --- MOTOR PREPARATION
        elseif toc >= (TrialStart+timing(2)) && toc < (TrialStart+timing(3))    % Timing 2 to 3 is period of preparing movement
            MotorPrep(cross,cmp,cir)
            coder = v(3);
            % --- MOTOR EXECUTION - changing the color of one arrow with according circle to green.
        elseif toc >= (TrialStart+timing(3)) && toc < (TrialStart+timing(4))    % Timing 3 to 4 is period of executing movement
            if condition <= 2
                MotorExec(cmp, cir, dirC, 1)
                coder = v(4);
            elseif condition > 2
                if flag_exec_delay == 0
                    MotorExec(cmp, cir, dirC, 0)
                    flag_exec_delay = 1;
                end
                
                % Check theyve actually moved!!
                [Xscreen, Yscreen] = applyTransform(X, Y, XKey, YKey);
                  dist = sqrt((0-Xscreen).^2+(0-Yscreen).^2);
                
                if (flag_exec_delay == 1) && (dist>0.35)
                    MotorExec(cmp, cir, dirC, 1)
                    TrialMove(trial) = 1;
                    coder = v(5);
                end
            end
            % --- HOLD
        elseif toc >= (TrialStart+timing(4)) && toc < (TrialStart+timing(5))
            start = TrialStart+timing(4);
            txy = location(dirC,:);
         [Xscreen, Yscreen] = applyTransform(X, Y, XKey, YKey);

            dist = sqrt((txy(1)-Xscreen).^2+(txy(2)-Yscreen).^2);
            if dist < 0.4
                if (start < start + 3) && (accumulator+0.01 < 1)
                    accumulator = accumulator + 0.015;
                    Hold(cir, dirC, accumulator)
                end
            end
            if (accumulator > 0.5) && (flag_beep == 0)
                TrialCorrect(trial) = 1;
                holdScore = holdScore + 1;
                th = Score(holdScore,ntrials,th);
                beep
                flag_beep = 1;
            end
            coder = v(6);
            % --- RETURN
        elseif toc >= (TrialStart+timing(5)) && toc < (TrialStart+timing(6))
            Return(cmp, cir, dirC)
            coder = v(7);
            
            % --- UPDATE FLAGS
        elseif toc >= (TrialStart+timing(6))
            flag_trial = 1; % Pass onto next trial
            flag_reach = 0; % Replot the compass next time!
            flag_exec_delay = 0; % Ensure GBYK flag is off!
            flag_beep = 0; % Ready for the next beep
            
            accumulator = 0;
            trial = trial + 1;
            clf
        end
        
        
        
    end
    i = i + 1;
    % Test LabJack recorder
    v(i)  = getLJMeasurement(ljudObj,ljhandle,3);
    coderSave(i) = coder;
    
end % Master loop

a = 1;
disp(holdScore)

mkdir([cd '\testData\' id])
trialData.tvec = tvec;
trialData.coderSave = coderSave;
trialData.handposition = handposition;
trialData.TargetDirection = TargetDirection;
trialData.TrialCorrect = TrialCorrect;
trialData.id = id;
trialData.condition = condition;
trialData.TrialMove = TrialMove;
save([cd '\testData\' id '\TrialData' id '_block' num2str(block) '_cond' num2str(condition)],'trialData');
