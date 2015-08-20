function [temp2]  = TOPTREEBz( I_source, I_tilt,I_haf,I_earthpos,I_Mgram, varargin )
%TOPTREE Summary of this function goes here
%   Detailed explanation goes here
%    uses simple method of manual inserted Max enlil B0 or statistics B0

% Event 03, 04, 10
%{
% so=[-30.75,30.46]; %   -- Event 10
% tilt=40.25;
% haf=41.93;
% Mgram='South';
%%%%
% so=[-26.27,1.98]; %   -- Event 04      % so=[5.03,13.13]; %   -- Event 03
% tilt=-3.35;                            % tilt=-38.01;
% haf=29.07;                             % haf=45.28;
% Mgram='South';                         % Mgram='North'; 

so=[-32.98,-11.6]; %   -- Event 08
tilt=3.91;
haf=25.16;
Mgram='South';
%}

% outp=TOPTREEBz( so,tilt,haf,[0,0],Mgram,1);
%set(0,'defaultfigureposition',[-1040 400 560 420]'); %set(0,'defaultfigureposition',[440 300 760 620]')
set(0,'defaultfigureposition',[200 100 760 620]')
lat=I_source(1); % in deg
lon=I_source(2); % in deg
haf=I_haf;       % in deg - is the alpha param from GCS to help express length of FR axis
tilt=I_tilt;     % in deg  angle output from GCS
EarthPos=I_earthpos;  %[0,0] in deg temp define Earth at the center of (lon lat) 
Mgram=I_Mgram;


%% 1. calc min perp distance to source 
Ang2Sou_deg = totAng(lon, lat);
Ang2Sou = Ang2Sou_deg * d2r;

%[E2dist,Fracdist,tempStruc]= Earth2FRaxis(EarthPos,lon,lat,tilt,haf);
[E2dist,Fracdist,tempStruc]= Earth2FRaxis(EarthPos,lon,lat,tilt,haf,varargin);

StrucOut.EarthPos=EarthPos;
StrucOut.fsun=tempStruc.fig1;
StrucOut.Y0mag=tempStruc.Y0mag;
StrucOut.linevec=tempStruc.linevec;

Y0mag=tempStruc.Y0mag;

%% 2. estimate the impact parameter of the FR
% create the impact param profile
[RdistProf,Y0Prof,tempStruc]=CalcImpactparam( [lon,lat],tilt,haf,StrucOut,1);
StrucOut.fY0prof=tempStruc.fig2;

% define the impact param for the Earth Locations 
% - also determin is above/below axis i.e. is y0 +ve or -ve
[temp,ind2]=min(abs(RdistProf-E2dist));
Y0=Y0Prof(ind2,1)* Y0mag;
RR=RdistProf(ind2,1);

if ~isempty(varargin), 
    figure(StrucOut.fY0prof);
    plot([RR,RR],[0,(Y0*Y0mag)],'r:','LineWidth',2); 
    plot([0 RR],[(Y0*Y0mag),(Y0*Y0mag)],'r:','LineWidth',2);
end   % display only the magnitude
str1(1) = {sprintf('Impact paramter, Y0= %3.3g ',Y0)};
str1(2) = {sprintf('Physical distance to Earth location= %3.3g Rs ',RR)};
text(0,0,str1,'Position',[0.4,0.1],'EdgeColor','black');
%print(gcf,'-dpng','-r300','fig/f02Y0.png','-zbuffer')
%print(gcf,'-dpsc2','-r300','fig/f12Y0.ps','-zbuffer')

%% 3. define the FR axis in 3 components- ie needs radial part 
% initial define +ve as going up - i.e south to north

[Axis_init,tempstruc]= FRaxis(tilt,Fracdist,varargin);

disp(['##----------------##']);
disp(['Flux Rope Axis =  ', num2str(Axis_init')]);
disp(['##----------------##']);  

%NOTE: the vector is not used in calculations... euler angles are used for
%rotation into correct vectors.
%% 4. define b field magnitude
sigma=0;  % 0 -6.9   6.9+6.9+6.9   ; -5.9  5.9+5.9+5.9;
BBmag=17.8 + sigma;
% test new program
BEarth=10.42 ;   %  <-- estimated from Enlil sheath @ 1 AU
InvFrac = FRmodelMag(Y0);
BBmag=(BEarth * InvFrac) + sigma ;

% Future use BBmag=ShockStandOffDist(stuff);
%% 5. create FR magnetic field profile
StrucFRax.Axis=Axis_init;
StrucFRax.tilt=tilt;
StrucFRax.rad_ang=tempstruc.PHI2;
StrucFRax.stTime=datenum([2014,01,08,22,00,00]);  % st n end of FR time series e10
StrucFRax.enTime=datenum([2014,01,09,19,45,00]);
% StrucFRax.stTime=datenum([2014,01,10,02,00,00]);  % st n end of FR time series e10 late version
% StrucFRax.enTime=datenum([2014,01,11,01,00,00]);
% StrucFRax.stTime=datenum([2012,06,17,00,00,00]);  % st n end of FR time series e08
% StrucFRax.enTime=datenum([2012,06,17,14,00,00]);
% StrucFRax.stTime=datenum([2012,07,15,07,30,00]);  % st n end of FR time series e05
% StrucFRax.enTime=datenum([2012,07,16,10,40,00]);
% StrucFRax.stTime=datenum([2012,06,16,23,00,00]);  % st n end of FR time series e04
% StrucFRax.enTime=datenum([2012,06,17,11,30,00]);
% StrucFRax.stTime=datenum([2012,03,12,012,20,00]);  % st n end of FR time series e03
% StrucFRax.enTime=datenum([2012,03,13,04,20,00]);


magnetogram=Mgram;  % 'down'  up means +ve region is above(north) the neutral line and -ve region

[Bfield,strucA]= Bestimate(StrucFRax, Y0,BBmag, magnetogram,varargin);



%% define outputs
if nargout == 0
     temp=1;
else
     temp2=1;
end


disp(['##----------------##']);
end

