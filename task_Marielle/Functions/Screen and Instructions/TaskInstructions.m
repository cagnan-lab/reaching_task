function txt_instructions = TaskInstructions(condition)
% Function that creates the task instructions before every new condition.

if condition < 3
    %Give quick recap of instructions and wait for input
    txt_instructions = {'Start of new session!!!';
        'This is a "Go AFTER You Know" session.'
        'You are asked to first hold a posture, and then repetitively reach and point.';
        'When you see "Postural Hold", please HOLD POSTURE as explained.';
        'When you see the cross in the middle of the compass please REACH.';
        'When black arrows appear, please PREPARE to move';
        'When you see the arrows and targets turn green, please POINT to the target as accurately as you can!';
        'When you see "You can rest", please REST your hands on the arm rests.';                 % We can swap these actions
        'Good luck!'};
else
    txt_instructions = {'Start of new session!!!';
        'This is a "Go BEFORE You Know" session.';
        'You are asked to first hold a posture, and then repetitively reach and point.';
        'When you see "Postural Hold", please HOLD POSTURE as explained.';
        'When you see the cross in the middle of the compass please REACH.';
        'When black arrows appear, please PREPARE to move';
        'When you see the arrows turn green, please POINT to a target as accurately as you can!';
        'When you see "You can rest", please REST your hands on the arm rests.';                 % We can swap these actions
        'Good luck!'};
end

% Waiting for key presses: matlab "pause"
for i=1:9
    ah = gca;
    th = text(1,1,txt_instructions{i}, 'FontSize', 25);
    set(ah,'visible','off','xlim',[0 2],'ylim',[0 2],'Position',[0 0 1 1]) ;
    set(th,'visible','on','HorizontalAlignment','center','VerticalAlignment','middle');
    pause
    delete(th);
end
