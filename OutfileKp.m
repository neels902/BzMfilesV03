function [O_temp] = OutfileKp(I_FileLoc, I_Kp,varargin)
% routine creates 2 output txt files for the magnetic model forecast. 
% as simple ascii and JSON format.
% This uses a package:
% addpath /Users/Neel/Documents/MATLAB/matlab-json
% json.startup


%% 1. inputs
DestStg = I_FileLoc; % directory destination of where to place files eg. '~/'
Kpvec = I_Kp;


if isempty(varargin),
    DirName = 'Bz4CastFiles'; % name of the folder to place the files inside
    COREstring = 'Kp_TXT'; % core string structure of the file names
    COREstringJS = 'Kp_JSON'; % core string structure of the file names
else
    DirName = varargin{1,1}{1,1};
    COREstring = varargin{1,1}{1,2};
    COREstringJS = varargin{1,1}{1,3};
end
%varargin{1,2}=inputString;

vararginOVERRIDE=varargin;

inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};

% if isempty(varargin), DoStuff=[]; 
% else DoStuff=varargin{1,1}(:); end

%% separate time and Bx , y, z
TT = Kpvec(:,1);
Kp = Kpvec(:,2);

Kmatrix = [datevec(TT), Kp];
Kpmatrix = Kmatrix';

formatOut = 'yyyy-mm-dd HH:MM:SS';
TTstring = datestr(TT,formatOut);
%% create JSON format
X = struct('Time', TTstring,'Kp', Kp);
S_JSON = json.dump(X);
% X3 = json.load(S_JSON); disp(X3);  -- strangely the order of strucutre is
% By, Bx, Time, Bz ???

% 'Year', YY, 'Month', MM, 'Day', DD, 'hour', hh, 'Minute', mm,'Second', ss, 
%% create file name to change by numbers if previous forecast file has been made

fileName = CreateFileName(DestStg, DirName, COREstring);

%% create output files: ASCII
fid=fopen(fileName,'w');
fprintf(fid, ['Year  Month  Day  hour  Minute  Second  Kp ' '\n']);
fprintf(fid,'%-4u %02u %02u %02u %02u %3.1f %3.2f \n',Kpmatrix);
% fprintf(fid,'%-4u %02u %02u %02u %02u %02u %4.3f %4.3f %4.3f \n',...
%         YY, MM, DD, hh, mm, ss, Bx, By, Bz);
fclose(fid);


%% create output file: JSON
fileName2 = CreateFileName(DestStg, DirName, COREstringJS);

fid2=fopen(fileName2,'w');
fprintf(fid2, '%s \n', S_JSON);
fclose(fid2);

%% outputs
O_temp =1;

end