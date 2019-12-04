function runBlock(condition,id)
%% HARDWARE SETUP
% Screen Setup:
ScreenSetup()
% Labjack Setup
[ljasm,ljudObj,ljhandle] = setup_LabJack();
% Leapmotion setup
load([cd '/testData/Keys_' id],'XKey','YKey');
[version]=matleap_version;
fprintf('matleap version %d.%d\n',version(1),version(2));

%% DEFINE BLOCK CONDITION
% Sigma and STD determine which condition (1, 2, 3 or 4) it will be:
sigma   = [1.5 1.5];
std     = [0.01 0.01];

% Determine which uncertainty to use:
if condition == 1                % high precision
    sigma = sigma(1);
    std = std(1);
elseif condition == 2            % low precision
    sigma = sigma(2);
    std = std(1);
% %         elseif condition == 3            % high precision, go before you know
% %             sigma = sigma(2);    
% %             std = std(2);
% %         elseif condition == 4            % low precision, go before you know
% %             sigma = sigma(1);
% %             std = std(2);
end

%% TRIAL DEFINITIONS
% Timings of 1) posture; 2) reach; 3) prep; 4) exec; 5) hold; 6) return
% timing = [15 20 23 25 30 35];
timing = [3 7 10 13 17 20];

% Setup triggers for labjack (voltages)
v = reshape(linspace(0.5,3,6),6,1);        % Change 1 to 2 if go before you know is included

%% BEGIN EXPERIMENT!
% Experiment explanation before every condition. Show strings until pressing any key.
% % txt_instructions = TaskInstructions();
clf;
block = 1;
tic
i = 1; % Initialize whole loop counter (THIS COUNTS THE TIME STEP)
trial = 1;


%% SET FLAGS
coder = v(1);
flag_reach = 0;
flag_trial = 1; % This is 1 only if moving to next trial
flag_post = 1;
% % flag_exec = 1;
while trial < 5
    if flag_trial == 1
        TrialStart = toc;
        flag_trial = 0;
    end
    % Keep track of time
    handposition(i,:) = AcquireLeap();           % Acquires stabilized palm position data
        X = squeeze(handposition(i,1));
        Y = squeeze(handposition(i,2));
        Z = squeeze(handposition(i,3));
        minmax = [-120 120];                % Change these to known from LeapMotion?
    V(1) = coder;
    V(2) = rescaleLeap(X,minmax);
    V(3) = rescaleLeap(Y,minmax);
    V(4) = rescaleLeap(Z,minmax);
    sendLJ4DACOut(ljudObj,ljhandle,V);
    
    if (rem(round(toc,2),0.1) == 0) %&& i>25 % This sets the frequency at which plots will be refreshed
        
        % --- POSTURE
        if (toc < TrialStart+timing(1)) && flag_post == 1  % Timing 1 to 2 is period of holding posture
            Posture()
            coder = v(1);
            
            % --- REACH
        elseif toc >= (TrialStart+timing(1)) && toc < (TrialStart+timing(2))    % Timing 2 is period of holding reach
            if flag_reach == 0
                [cmp,cir,dirC] = Reach(sigma, std);
                flag_reach = 1;
                flag_post = 0;
            end
            coder = v(2);
            % --- MOTOR PREPARATION
        elseif toc >= (TrialStart+timing(2)) && toc < (TrialStart+timing(3))    % Timing 2 to 3 is period of preparing movement
            MotorPrep(cmp,cir)
            coder = v(3);
            
            % --- MOTOR EXECUTION - changing the color of one arrow with according circle to green.
        elseif toc >= (TrialStart+timing(3)) && toc < (TrialStart+timing(4))    % Timing 3 to 4 is period of executing movement
%             if flag_exec == 0
                MotorExec(cmp, cir, dirC)
%                 flag_exec = 1;
%                 flag_post = 0;
%             end
           coder = v(4);
            
            % --- HOLD
        elseif toc >= (TrialStart+timing(4)) && toc < (TrialStart+timing(5))
            Hold(cir, dirC)
            coder = v(5);
            
            % --- RETURN
        elseif toc >= (TrialStart+timing(5)) && toc < (TrialStart+timing(6))
            Return(cmp, cir, dirC)
            coder = v(6);
            
            % --- UPDATE FLAGS
         elseif toc >= (TrialStart+timing(6))
            flag_trial = 1; % Pass onto next trial
            flag_reach = 0; % Replot the compass next time!
            trial = trial + 1;
            timing = [0 5 10 15 20 25];
            clf
        end
    end
    i = i + 1;

    tvec(i) = toc;    
end % Master loop


% --- REST
% Rest()
% sendLJTrigger(ljudObj, ljhandle, v(3,1), channel);


% SAVE ANY DATA - SAVE log of the correct ARROW LOCATIONS + LEAPMOTION
% use the input id to label the saves!