function configuration(path, labjack, tick, visible, reaches, condinfo, posturalhold, rest, posturestart, reachwait, prepwait, delaywait, holdwait, colorduration)
% function configuration(path, reaches, posturalhold, rest, posturestart, reachwait, prepwait, delaywait, holdwait, balloonsize)

fileTICK = fopen([path '\TICK.txt'],'w');
fprintf(fileTICK,tick);
fclose(fileTICK);
fileLABJACK = fopen([path '\LABJACK.txt'],'w');
fprintf(fileLABJACK,labjack);
fclose(fileLABJACK);
fileVISIBLE = fopen([path '\VISIBLE.txt'],'w');
fprintf(fileVISIBLE,visible);
fclose(fileVISIBLE);
fileREACHES = fopen([path '\REACHES.txt'],'w');
fprintf(fileREACHES,reaches);
fclose(fileREACHES);
fileCONDINFO = fopen([path '\CONDINFO.txt'],'w');
fprintf(fileCONDINFO,condinfo);
fclose(fileCONDINFO);
filePOSTHOLD = fopen([path '\POSTHOLD.txt'],'w');
fprintf(filePOSTHOLD,posturalhold);
fclose(filePOSTHOLD);
fileREST = fopen([path '\REST.txt'],'w');
fprintf(fileREST,rest);
fclose(fileREST);
filePOSTSTART = fopen([path '\POSTSTART.txt'],'w');
fprintf(filePOSTSTART,posturestart);
fclose(filePOSTSTART);
fileREACHWAIT = fopen([path '\REACHWAIT.txt'],'w');
fprintf(fileREACHWAIT,reachwait);
fclose(fileREACHWAIT);
filePREPWAIT = fopen([path '\PREPWAIT.txt'],'w');
fprintf(filePREPWAIT,prepwait);
fclose(filePREPWAIT);
fileDELAYWAIT = fopen([path '\DELAYWAIT.txt'],'w');
fprintf(fileDELAYWAIT,delaywait);
fclose(fileDELAYWAIT);
fileHOLDWAIT = fopen([path '\HOLDWAIT.txt'],'w');
fprintf(fileHOLDWAIT,holdwait);
fclose(fileHOLDWAIT);
fileCOLORDUR = fopen([path '\COLORDURATION.txt'],'w');
fprintf(fileCOLORDUR,colorduration);
fclose(fileCOLORDUR);
% fileBALLOONSIZE = fopen([path '\BALLOONSIZE.txt'],'w');
% fprintf(fileBALLOONSIZE,balloonsize);
% fclose(fileBALLOONSIZE);