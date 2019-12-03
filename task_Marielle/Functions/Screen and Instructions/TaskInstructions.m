function txt_instructions = TaskInstructions()
% Function that creates the task instructions before every new condition.
% Marielle Stam (2019)

%Give quick recap of instructions and wait for input
txt_instructions = {'Start of new session!!!';
    'In this session you are asked to first hold a posture, and then repetitively reach and point.';
    'When you see "Wing Beating Postural Hold", please HOLD POSTURE as explained.';
    'When you see the empty compass surrounded by circles please REACH.';
    'When arrows appear, please PREPARE to move';
    'When you see a green target please POINT as accurately as you can!';
    'When you see "You can rest", please REST your hands on your lap.';                 % We can swap these actions
    'Good luck!'};

% Waiting for key presses: matlab "pause"
for i=1:8
    ah = gca;
    th = text(1,1,txt_instructions{i}, 'FontSize', 25);
    set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    pause
    delete(th);
end
 