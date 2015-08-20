function  [outp,outp2,OutStruc]=CalcImpactparam( I_source, I_tilt,I_haf,I_StrucOut, varargin )
%CALCIMPACTPARAM estimate the impact parameter for the CME 
%   using the inputs (distance of the source region from Earth location),
%   this routine outputs a single value estimate of the impact parameter of
%   the magnetic flux rope
% 
%   USE:   e.g  outp=CalcImpactparam( so,tilt,haf,[0,0],1)

lon=I_source(1); % in deg
lat=I_source(2); % in deg
haf=I_haf;       % in deg - is the alpha param from GCS to help express length of FR axis
tilt=I_tilt;     % in deg  angle output from GCS
StrucOut=I_StrucOut;   

EarthPos=StrucOut.EarthPos; %[0,0] in deg temp define Earth at the center of (lon lat)
linevec=StrucOut.linevec;
FRlat=linevec(:,1);
FRlon=linevec(:,2);

inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};

%% define the initial conditions required for the impact parameter profile
avCMEhaWidth=pi/8;% 0.65 pi/8;  % r* theta is the distance, av full width of CME is approx pi/4
fullCMEcutoff= 0.8;
ImpactThreshold= 0.6;
Impactmax=1.0;


%% add shading to area of sun
% script file

az=(0:2:360)';
initang=haf+avCMEhaWidth*r2d;

ShadeSun2  % wider outer region
ShadeSun % centre core region


% print(gcf,'-dpng','-r100','-opengl','AA.png')

%% estimate impact parameter Y0
% define the interp profile 
RdistProf=(0:0.01:1.9)';
ind=find(RdistProf<avCMEhaWidth,1,'last');

% linear formula for Y0
M= ImpactThreshold/avCMEhaWidth ;
Y0Prof(1:ind,1)= M* RdistProf(1:ind,1);
%Y0= M* E2Sdist;

% quad formula for Y0
M= (Impactmax - ImpactThreshold)./ (fullCMEcutoff - avCMEhaWidth).^2;
Y0Prof(ind:length(RdistProf),1)= M *(RdistProf(ind:end,1) - avCMEhaWidth).^2 + ImpactThreshold;
%Y0= M *(E2Sdist - avCMEhaWidth).^2 + ImpactThreshold;

% define all impact param above 1 to equal 1
Y0Prof(Y0Prof>1)=1;


%% plot figures if keyword set
if ~isempty(plotfig), 
    OutStruc.fig2=figure;
    set(gcf,'Units','centimeters')
    set(gcf,'Position',[15.3,11.0,16.0,8.0])
    set(OutStruc.fig2,'Name',['MTseries Bz: Fig.2 - Y0']);
    set(OutStruc.fig2,'NumberTitle', 'off');
    FF= 14;
    
    
    plot(RdistProf,Y0Prof,'Color',DarkBlue,'LineWidth',2),hold on 
    ylabel('Impact paramater, Y_0','FontWeight','Demi','FontSize',12);
    xlabel('Distance to Earth location, [Rs]','FontWeight','Demi','FontSize',12);
    axis([0,1.1,0,1.1]);
    set(gca,'FontSize',12,'FontWeight','Demi')
end

%% define outputs
if nargout == 0
     plot(x, y)
else
     outp=RdistProf;
     outp2=Y0Prof;
     if isempty(plotfig),OutStruc.fig2=1;end
end

end

