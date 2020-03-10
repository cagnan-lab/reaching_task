% Unity Error Determination
% Copy xLoc and yLoc of Calibration folder! 

xLocFinger = [-3.163456
-0.4165058
-94.47132
-96.61444
-96.85499
-2.873635
84.90961
82.71272
85.6075
];
yLocFinger = [226.5392
319.4505
328.5927
231.5486
132.8068
118.6826
131.7678
226.1911
323.2943
];
xKeyFinger = [-95.98025
0.02217415
-2
];
yKeyFinger = [127.7524
0.02040538
-2
];
xLocPalm = [12.76333
13.29357
-5.261222
-15.77447
-22.8842
-19.57513
-10.3671
-2.696009
3.835029
];
yLocPalm = [235.2397
264.7413
275.0276
266.5859
251.2184
240.4113
232.483
232.0675
237.3012
];
xKeyPalm =[ -14.63996
0.345903
-2
];
yKeyPalm = [241.3709
0.2265978
-2
];
for i = 1:9; [XFinger(i), YFinger(i)] = applyTransform(xLocFinger(i),yLocFinger(i),xKeyFinger, yKeyFinger);end
for i = 1:9; [XPalm(i), YPalm(i)] = applyTransform(xLocPalm(i),yLocPalm(i),xKeyPalm, yKeyPalm);end

X_errorFinger = mean([abs(XFinger(1)) abs(XFinger(2)) abs(XFinger(6)) abs(XFinger(4)--2) abs(XFinger(3)--2) abs(XFinger(5)--2) abs(XFinger(8)-2) abs(XFinger(9)-2) abs(XFinger(7)-2)]); 
Y_errorFinger = mean([abs(YFinger(1)) abs(YFinger(4)) abs(YFinger(8)) abs(YFinger(2)-2) abs(YFinger(9)-2) abs(YFinger(3)-2) abs(YFinger(6)--2) abs(YFinger(7)--2) abs(YFinger(5)--2)]);
X_errorPalm = mean([abs(XPalm(1)) abs(XPalm(2)) abs(XPalm(6)) abs(XPalm(4)--2) abs(XPalm(3)--2) abs(XPalm(5)--2) abs(XPalm(8)-2) abs(XPalm(9)-2) abs(XPalm(7)-2)]);
Y_errorPalm = mean([abs(YPalm(1)) abs(YPalm(4)) abs(YPalm(8)) abs(YPalm(2)-2) abs(YPalm(9)-2) abs(YPalm(3)-2) abs(YPalm(6)--2) abs(YPalm(7)--2) abs(YPalm(5)--2)]);


