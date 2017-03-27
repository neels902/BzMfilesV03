
I_FileLoc = FileLoc; 
I_Bfield = Bfield;

DestStg = I_FileLoc; % directory destination of where to place files eg. '~/'
BStr = I_Bfield;

DirName = BasicInputsStr{1,1};
COREstring = BasicInputsStr{1,2};
COREstringJS = BasicInputsStr{1,3};



TT = BStr(:,1);
Bx = BStr(:,2);
By = BStr(:,3);
Bz = BStr(:,4);

Bmatrix = [datevec(TT), Bx, By, Bz];
Btmatrix = Bmatrix';

fid=fopen(fileName,'w');
fprintf(fid, ['Year  Month  Day  hour  Minute  Second  Bx  By  Bz ' '\n']);
fprintf(fid,'%-4u %02u %02u %02u %02u %3.1f %4.3f %4.3f %4.3f \n',Btmatrix);
fclose(fid);


