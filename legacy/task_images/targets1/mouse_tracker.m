clear; close all; clc;

% Reaching Task Master Script
[dpath,gpath] = add_ReachingTask_paths();
% Setup Images
baseTar = {
    [gpath '/reaching_task/task_images/targets1/fixation_cross_targets.bmp'];...
    [gpath '/reaching_task/task_images/targets1/0_0_0_0_targets.bmp'];...
    };

img_center = baseTar{2,1}; 
imshow(img_center);
% [x, y] = ginput(4);
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
% figure;
% imshow(img_center,'Parent',gca)
% pixHover(x,y)
% 
% 
%  function pixHover(x,y)
%      Thresh = 40;
%      set(gcf,'WindowButtonMotionFcn', @hoverCallback);
%      axesHdl = gca;
%      textHdl = text('Color', 'black', 'VerticalAlign', 'Bottom', 'Parent', gca);
%      function hoverCallback(src, evt)
%         mousePoint = get(axesHdl, 'CurrentPoint');
%         mouseX = mousePoint(1,1);
%         mouseY = mousePoint(1,2);
%         distancesToMouse = hypot(x - mouseX, y - mouseY);
%         [~, ind] = min(abs(distancesToMouse));
%         xrange = range(get(axesHdl, 'Xlim'));
%         yrange = range(get(axesHdl, 'Ylim'));
%         if abs(mouseX - x(ind)) < Thresh && abs(mouseY - y(ind)) < Thresh
%             set(textHdl, 'String', {['x = ', num2str(x(ind))], ['y = ', num2str(y(ind))]});
%             set(textHdl, 'Position', [x(ind) + 0.01*xrange, y(ind) + 0.01*yrange])
%         else
%             set(textHdl, 'String', '')
%         end
%     end
%  end