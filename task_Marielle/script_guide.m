

ScreenSetup()
% To set up the screen to full size. 

txt_instructions = TaskInstructions()
% Function that creates the task instructions before every new condition.
% Ends with clear figure command.

basic_8pnt_calibration
% This performs the calibration. End products are XKey and YKey for further
% LeapMotion LiveDraw and the calculated error rate. The function requires 
% LabJack setup functions, Matleap_version, ScreenSetup, 
% Translation functions (which need matleap_frame), ...

handpos = getHandPos()
% This acquires data of five fingers from the LeapMotion to use for calibration.
% Requires matleap_frame function.

[XKey,YKey] = getTransform(WESN_app,WESN_leap)
% Function to generate the keys for transforming LeapMotion coordination to
% screen coordination.

[XS,YS] = applyTransform(XL,YL,XKey,YKey)
% Applies linear transform to leap motion coordinates in order to map to
% screen space

handposition = AcquireLeap()
% This acquires stabilized palm position data from the LeapMotion to use for the task. 
% Requires matleap_frame function.

[p, alpha] = circ_vmpdf_ms(alpha, thetahat, kappa)
% function circ
% This computes the circular von Mises pdf with preferred direction 
% thetahat and concentration kappa at each of the angles in alpha.

[location, radius] = GenerateTargets()
% function GenerateTargets
% This function generates the location and the radius of the circle
% targets.

h = circle(x,y,r)
% This generates circles in a plot. 

CompassGenerator(sigma, std)
% function ArrowGenerator
% This function generates the plot including the arrows and targets.  
% The arrows include von Mises length and direction which serve as an input 
% for the compass plot. Sigma and STD can be varied (in the main script) to 
% determine the level of uncertainty in the task. 

LeapScatter = LiveDraw(handposition, XKey, YKey)
% function LiveDraw
% This one plots the leapmotion pointer on the screen. It takes the
% calibration keys from (calibration fx) and the current leapmotion
% coordinates in order to plot in screen space.

