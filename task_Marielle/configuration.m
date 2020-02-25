function configuration(subjectpath, reaches, posturalhold, rest, posturestart, reachwait, prepwait, delaywait, holdwait, colorduration)
% function configuration(subjectpath, reaches, posturalhold, rest, posturestart, reachwait, prepwait, delaywait, holdwait, balloonsize)

fileREACHES = fopen([subjectpath '\REACHES.txt'],'w');
fprintf(fileREACHES,reaches);
fclose(fileREACHES);
filePOSTHOLD = fopen([subjectpath '\POSTHOLD.txt'],'w');
fprintf(filePOSTHOLD,posturalhold);
fclose(filePOSTHOLD);
fileREST = fopen([subjectpath '\REST.txt'],'w');
fprintf(fileREST,rest);
fclose(fileREST);
filePOSTSTART = fopen([subjectpath '\POSTSTART.txt'],'w');
fprintf(filePOSTSTART,posturestart);
fclose(filePOSTSTART);
fileREACHWAIT = fopen([subjectpath '\REACHWAIT.txt'],'w');
fprintf(fileREACHWAIT,reachwait);
fclose(fileREACHWAIT);
filePREPWAIT = fopen([subjectpath '\PREPWAIT.txt'],'w');
fprintf(filePREPWAIT,prepwait);
fclose(filePREPWAIT);
fileDELAYWAIT = fopen([subjectpath '\DELAYWAIT.txt'],'w');
fprintf(fileDELAYWAIT,delaywait);
fclose(fileDELAYWAIT);
fileHOLDWAIT = fopen([subjectpath '\HOLDWAIT.txt'],'w');
fprintf(fileHOLDWAIT,holdwait);
fclose(fileHOLDWAIT);
fileCOLORDUR = fopen([subjectpath '\COLORDURATION.txt'],'w');
fprintf(fileCOLORDUR,colorduration);
fclose(fileCOLORDUR);
% fileBALLOONSIZE = fopen([subjectpath '\BALLOONSIZE.txt'],'w');
% fprintf(fileBALLOONSIZE,balloonsize);
% fclose(fileBALLOONSIZE);