function runBlock(condition,id)
%% HARDWARE SETUP
% Screen Setup:
ScreenSetup()
% Labjack Setup
% Leapmotion setup
load([cd '/testData/Keys_' id],'XKey','YKey');
% % [version]=matleap_version;
% % fprintf('matleap version %d.%d\n',version(1),version(2));

%% DEFINE BLOCK CONDITION
% Sigma and STD determine which condition (1, 2, 3 or 4) it will be:
sigma   = [0.25 1];
std     = [0.1 0.7];

% Determine which uncertainty to use:
if condition == 1                % high precision
    std = std(1);
    sigma = sigma(2);
elseif condition == 2            % low precision
    std = std(1);
    sigma = sigma(1);
    %     elseif condition(block) == 3            % high precision, go before you know
    %         std = std(2);
    %         sigma = sigma(2);
    %     elseif condition(block) == 4            % low precision, go before you know
    %         std = std(2);
    %         sigma = sigma(1);
end

%% TRIAL DEFINITIONS
% Timings of 1) posture; 2) reach; 3) prep; 4) exec; 5) hold; 6) return
% timing = [15 20 25 30 35 40];
timing = [5 10 15 20 25 30];

% Setup triggers for labjack (voltages)
v = reshape(linspace(0.5,3,6),6,1);        % Change 2 to 4 if go before you know is included

%% BEGIN EXPERIMENT!
% Experiment explanation before every condition. Show strings until pressing any key.
% % txt_instructions = TaskInstructions();
clf;
block = 1;
tic
i = 1; % Initialize whole loop counter (THIS COUNTS THE TIME STEP)
trial = 1;

%% SET FLAGS
flag_reach = 0;
flag_trial = 1; % This is 1 only if moving to next trial
flag_post = 1;
while trial < 10
    if flag_trial == 1
        TrialStart = toc;
        flag_trial = 0;
    end
    % Keep track of time
    handposition(i,:) = AcquireLeap();           % Acquires stabilized palm position data
    
    if (rem(round(toc,2),0.1) == 0) %&& i>25 % This sets the frequency at which plots will be refreshed
        % --- POSTURE
        
        if (toc < TrialStart+timing(1)) && flag_post == 1  % Timing 1 is period of holding posture
            Posture()
% %             sendLJ4DACOut(ljudObj,ljhandle,v(1));
            
            % --- REACH
        elseif toc >= (TrialStart+timing(1)) && toc < (TrialStart+timing(2))    % Timing 2 is period of holding reach
            if flag_reach == 0
                [cmp,cir,dirC] = Reach_Return(sigma, std);
                
                % %             sendLJ4DACOut(ljudObj,ljhandle,v(2));
                flag_reach = 1;
                flag_post = 0;
            end
            % --- MOTOR PREPARATION
        elseif toc >= (TrialStart+timing(2)) && toc < (TrialStart+timing(3))    % Timing 3 is period of preparing movement
            MotorPrep(cmp,cir)
%             sendLJ4DACOut(ljudObj,ljhandle,v(3));
            
            % --- MOTOR EXECUTION - changing the color of one arrow with according circle to green.
        elseif toc >= (TrialStart+timing(3)) && toc < (TrialStart+timing(4))    % Timing 3 is period of preparing movement
            set(cmp(dirC),'Color',[0 1 0],'linewidth',2)
            set(cir(dirC), 'Color', [0 1 0], 'linewidth', 2)
            drawnow
            % --- HOLD
            
            % --- RETURN
            
            % --- UPDATE FLAGS
        elseif toc >= (TrialStart+timing(4)) && toc < (TrialStart+timing(5))    % Timing 3 is period of preparing movement
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


% --- 5. REST
% Requires plot with text saying "please rest your arm".

th = text(0.5,0.5,'Please rest your arm', 'FontSize', 25);
% sendLJTrigger(ljudObj, ljhandle, v(3,1), channel);
set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');

% SAVE ANY DATA - SAVE log of the correct ARROW LOCATIONS + LEAPMOTION
% use the input id to label the saves!