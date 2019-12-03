function Xout = rescaleLeap(Xin,minmax)

Xout = (Xin - minmax(1))./(minmax(2)-minmax(1));

Xout = (Xout*6)-3;