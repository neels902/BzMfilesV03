function [temp2]  = TOPTREEBzTool( I_toolHandle, varargin )
%TOPTREE Summary of this function goes here
%   - This is for operational mode. TOPTREEBz is no longer used with the UI
%
%   - Code improved to use a script to drive the input variables and minimise
%   the toptreeBz inputs
%   - code improved to import enlil txt files to estimate the B0 & V0 value
%    
%
%  set varargin=1 for output of all figures used in calculations
%
% TOPTREEBz( I_strg, varargin )
% temp2 = TOPTREEBz('ev03');
% temp2 = TOPTREEBz('ev03',1); - to plot extra figures
%
% To manually adjust the solar imagery to any jpeg you want:
% Sunsc L27: ImportAIA  --> ImportAIA_v1 
% 
% 
% 
% 
% 
% 



inputString=I_toolHandle;
%inputString='Error Old Code pre BzTool';

inputScript
if isempty(varargin), plotfig=[]; 
else plotfig=varargin{1,1}(:); end
varargin{1,2}=inputString;
%varargin{1,2}=inputString;
vararginOVERRIDE=varargin;  % vararginOVERRIDE{1,1}=1;

% Event 03, 04, 10
%{
% so=[-30.75,30.46]; %   -- Event 10
% tilt=40.25;
% haf=41.93;
% Mgram='South';
%}

% outp=TOPTREEBz( so,tilt,haf,[0,0],Mgram,1);
%set(0,'defaultfigureposition',[-1040 400 560 420]'); %set(0,'defaultfigureposition',[440 300 760 620]')
set(0,'defaultfigureposition',[200 100 760 620]')
lat=so(1); % in deg
lon=so(2); % in deg
haf=I_haf;       % in deg - is the alpha param from GCS to help express length of FR axis
tilt=I_tilt;     % in deg  angle output from GCS
EarthPos=I_earthpos;  %[0,0] in deg temp define Earth at the center of (lon lat) 
Mgram=I_Mgram;


%% 1. calc min perp distance to source 
Ang2Sou_deg = totAng(lon, lat);
Ang2Sou = Ang2Sou_deg * d2r;

%[E2dist,Fracdist,tempStruc]= Earth2FRaxis(EarthPos,lon,lat,tilt,haf,1);
vararginOVERRIDE2=vararginOVERRIDE; vararginOVERRIDE2{1,1}=1; %- always plot sun image
[E2dist,Fracdist,tempStruc]= Earth2FRaxis(EarthPos,lon,lat,tilt,haf,vararginOVERRIDE2);

StrucOut.EarthPos=EarthPos;
StrucOut.fsun=tempStruc.fig1;
StrucOut.Y0mag=tempStruc.Y0mag;
StrucOut.linevec=tempStruc.linevec;

disp(sprintf('Fractional dist Parallel to Axis, Rf= %3.3g ',Fracdist));
Y0mag=tempStruc.Y0mag;

%% 2. estimate the impact parameter of the FR
% create the impact param profile and draws shading
[RdistProf,Y0Prof,tempStruc]=CalcImpactparam( [lon,lat],tilt,haf,StrucOut,vararginOVERRIDE);  %   *****
StrucOut.fY0prof=tempStruc.fig2; 

% define the impact param for the Earth Locations 
% - also determin is above/below axis i.e. is y0 +ve or -ve
[temp,ind2]=min(abs(RdistProf-E2dist));
Y0=Y0Prof(ind2,1)* Y0mag;
RR=RdistProf(ind2,1);

if ~isempty(varargin{1,1}), 
    figure(StrucOut.fY0prof);
    plot([RR,RR],[0,(Y0*Y0mag)],'r:','LineWidth',2); 
    plot([0 RR],[(Y0*Y0mag),(Y0*Y0mag)],'r:','LineWidth',2);
    str1(1) = {sprintf('Impact paramter, Y0= %3.3g ',Y0)};
    str1(2) = {sprintf('Physical distance to Earth location= %3.3g Rs ',RR)};
    tx = text(0.4, 0.1, str1);
    tx.EdgeColor='black';
    tx.FontSize = 11;
end   % display only the magnitude


% text(0,0,str1,'Position',[0.4,0.1],'EdgeColor','black');
% old - % print(gcf,'-dpng','-r300','fig/f02Y0.png','-zbuffer')
% old - %print(gcf,'-dpsc2','-r300','fig/f12Y0.ps','-zbuffer')

% print(gcf,'-dpng','-r100','-opengl','AA.png')
%% 3. define the FR axis in 3 components- ie needs radial part 
% initial define +ve as going up - i.e south to north

[Axis_init,tempstruc]= FRaxis(tilt,Fracdist,vararginOVERRIDE);

disp(['##----------------##']);
disp(['Flux Rope Axis =  ', num2str(Axis_init')]);
disp(['##----------------##']);  

%NOTE: the vector is not used in calculations... euler angles are used for
%rotation into correct vectors.
%% 4. define b field magnitude
%sigma=-6.9;  % 0 -6.9   6.9+6.9+6.9   ; -5.9  FIND in INPUTSCRIPT
%Vearth=1400; % preset
%BBmag=15.0 + sigma;  % 17.8
% new program
if isempty(varargin{1,1})
    tmpStrg='quiet';
else
    tmpStrg='loud';
end
InvFrac = FRmodelMag(Y0);

%inputScript  <-- NEW for BzTool manual ENLIL inputs
BBmag= enlilBB;
Vearth = enlilVV;
disp(['|B| for Enlil Sheath =  ', num2str(BBmag),' nT']);
disp(['Vel for Enlil Sheath =  ', num2str(Vearth),' km/s']);
% temp=['../Insitu/enlil/',inputString,'.txt'];    BzTool

%enlilPath=enliltxt;
% if exist(enlilPath, 'file')    
%     [BEarth,Vearth]= EnlilB0(enlilPath,tmpStrg);   %  <-- estimated from Enlil sheath @ 1 AU
%     BBmag=(BEarth * InvFrac) + sigmaA ;
% else
%     disp(['Warning: Default Enlil values are being used as no Enlil data file exists']);
%     disp(['|B| for Enlil Sheath =  ', num2str(BBmag),' nT']);
%     disp(['Vel for Enlil Sheath =  ', num2str(Vearth),' km/s']);
%     disp(['##----------------##']);
% end

% Future use BBmag=ShockStandOffDist(stuff);

%% 5. create FR magnetic field profile
StrucFRax.Axis=Axis_init;
StrucFRax.tilt=tilt;
StrucFRax.rad_ang=tempstruc.PHI2;
StrucFRax.stTime=datenum([2014,01,08,22,00,00]);  % st n end of FR time series e10
StrucFRax.enTime=datenum([2014,01,09,19,45,00]);
BBVV=[BBmag,Vearth];
%
% CREATED WITIHIN INPUTSTRING
%
% StrucFRax.stTime=datenum([2014,01,10,02,00,00]);  % st n end of FR time series e10 late version
% StrucFRax.enTime=datenum([2014,01,11,01,00,00]);
% StrucFRax.stTime=datenum([2012,06,17,00,00,00]);  % st n end of FR time series e08
% StrucFRax.enTime=datenum([2012,06,17,14,00,00]);


magnetogram=Mgram;  % 'down'  up means +ve region is above(north) the neutral line and -ve region

[Bfield,strucA]= Bestimate(StrucFRax, Y0,BBVV, magnetogram,varargin);

Kpvec= strucA.Kp.Kpvec;

%% define outputs
if nargout == 0
     temp=1;
else
     temp2=1;
end

%% OUTPUT results into txt files and JSON fomatted files.
% file location on local computer
FileLoc = '~/';
DirName = 'Bz4CastFiles'; % name of the folder to place the files inside

%% output: 2 text files: Mag vec times series model in both txt & JSON

COREstring = 'Bfield_TXT'; % core string structure of the file names
COREstringJS = 'Bfield_JSON'; % core string structure of the file names

BasicInputsStr{1,1} = DirName;
BasicInputsStr{1,2} = COREstring;
BasicInputsStr{1,3} = COREstringJS;

% temp = OutfileBz(FileLoc,Bfield,varargin);

% fileName = CreateFileName(FileLoc, DirName, COREstring);
% tempscript

temp = OutfileBz(FileLoc,Bfield,BasicInputsStr);


%% output: 2 text files: Kp times series model in both txt & JSON

COREstring = 'Kp_TXT'; % core string structure of the file names
COREstringJS = 'Kp_JSON'; % core string structure of the file names
BasicInputsStr{1,2} = COREstring;
BasicInputsStr{1,3} = COREstringJS;

temp = OutfileKp(FileLoc,Kpvec,BasicInputsStr);

% output: - OutfileSkill: 
% work in progress to be used in histroical sense. Need to predefine 'Hit' 
% Criteria

disp(['##----------------##']);
disp(['  ']);
disp(['  ']);
end

