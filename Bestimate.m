function [O_Bdata, StructA]= Bestimate(I_Axis_dirn, I_Y0,I_BBmag, I_magdirn,varargin)

% USES   FRProfile, ave1day_preCarrot, addNoiseVec, KpEstimate

%% 1. inputs
FRaxisvec=I_Axis_dirn.Axis;
tilt=I_Axis_dirn.tilt;
rad_ang=I_Axis_dirn.rad_ang;

inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};
vararginOVERRIDE=varargin; vararginOVERRIDE{1,1}=1;

inputScript
stTime=StrucFRax.stTime;
enTime=StrucFRax.enTime;

Y0=I_Y0;
B0=I_BBmag(1);
VV=I_BBmag(2);
MagDirn=I_magdirn;
% define and create eul



%% 2. ideal FR profile euler angles
eul_ang_3rd=0;
eul_ang=[tilt,rad_ang,eul_ang_3rd];

%StrucFR.FRaxis=FRaxisvec;
% stTime=datenum([2014,01,08,22,00,00]);
% enTime=datenum([2014,01,09,19,45,00]);

StrucFR.stTime=stTime;
StrucFR.enTime=enTime;
%% 3. calculate the field in each componetn vector within FR
[bfield,temp]=FRProfile(eul_ang, Y0, B0, MagDirn,StrucFR,varargin);
%[bfield,temp]=FRProfile(eul_ang, Y0, B0, MagDirn,StrucFR,varargin);

Timemod=bfield(:,1);
BMAG= sqrt( (bfield(:,2)).^2 + (bfield(:,3)).^2 + (bfield(:,4)).^2   );

%% 4. calculate the field in each component vector outside the FR - use 27days
%% earlier data  

% --------- at the moment I will use 2 days earlier from
% insit_path='..\Insitu\Omni\E10_Omni.txt';
% T1=datenum([2014,01,07,00,00,00]);  % time range used only for estimating the background static in situ params.
% T2=datenum([2014,01,07,12,00,00]);
% inputScript




Time_Ra=[T1,T2,arrTime];  %  <-- NEW 3rd VAR for JSON inputs  

[aveData,OutStrucTemp]=ave1day_preCarrot(insit_path, Time_Ra);

Bxave=aveData(1,2);
Byave=aveData(1,3);
Bzave=aveData(1,4);
BBave= sqrt( (aveData(1,2)).^2 + (aveData(1,3)).^2 + (aveData(1,4)).^2   );

%VVave= sqrt( (aveData(1,5)).^2 + (aveData(1,6)).^2 + (aveData(1,7)).^2   );
%Npave=aveData(1,8);

insit=OutStrucTemp.temp;
avlength=[0,0,0,0,20,5];%10min alone doesnt ave date-must be slightly larger
insit= Ave (insit, avlength);

%% 5. pad time series with generic values i.e add background

Timelength=0.5;  % half a day extra on both sides;
incrementTime= Timemod(2)-Timemod(1);

tvec=(incrementTime:incrementTime:Timelength)';
tvecN=length(tvec(:,1));
Static=ones(tvecN,1);


preTime=Timemod(1)-flipud(tvec((1:end)));
postTime=Timemod(end) + (tvec((1:end)));


TTmod=[preTime;Timemod;postTime];
Bxmod=[(Bxave*Static) ; bfield(:,2) ; (Bxave*Static)];
Bymod=[(Byave*Static) ; bfield(:,3) ; (Byave*Static)];
Bzmod=[(Bzave*Static) ; bfield(:,4) ; (Bzave*Static)];

BBmod=[(BBave*Static) ; BMAG ; (BBave*Static)];

FullmodData=[TTmod,Bxmod,Bymod,Bzmod,BBmod];

%Bave=5.5; % nT ave background field strength

%% 5b add noise to forecast vectors - new addition section
[FullmodDataNoise,temp]=addNoiseVec(FullmodData);

BxmodN=FullmodDataNoise(:,2);
BymodN=FullmodDataNoise(:,3);
BzmodN=FullmodDataNoise(:,4);
BBmodN=sqrt((BxmodN.*BxmodN)+(BymodN.*BymodN)+(BzmodN.*BzmodN));

%% 6. Temp figure plot checking
[th,ph,r]=cart2sph(BxmodN,BymodN,BzmodN);
thet=(th/(2*pi)*360 );
theta=thet; theta(thet<0)=360+theta(thet<0);
phi=ph/(2*pi)*360;

figInSit=figure;
set(figInSit,'Name',['Bz4Cast:2 - L1 Prediction']);
set(figInSit,'NumberTitle', 'off');
subpanel(6,1,1),plot(FullmodDataNoise(:,1),FullmodDataNoise(:,2),'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,2),plot(FullmodDataNoise(:,1),FullmodDataNoise(:,3),'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,3),plot(FullmodDataNoise(:,1),FullmodDataNoise(:,4),'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,4),plot(FullmodDataNoise(:,1),theta,'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,5),plot(FullmodDataNoise(:,1),phi,'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,6),plot(FullmodDataNoise(:,1),BBmod,'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,1),ylabel('B_{x} GSE [nT]','Fontsize',14);
subpanel(6,1,2),ylabel('B_{y} [nT]','Fontsize',14);
subpanel(6,1,3),ylabel('B_{z} [nT]','Fontsize',14);
subpanel(6,1,4),ylabel('B_\Phi','Fontsize',14);
subpanel(6,1,5),ylabel('B_\theta','Fontsize',14);
subpanel(6,1,6),ylabel('|B| [nT]','Fontsize',14);
TimeAxisSet
xxlim=get(gca,'xlim');datevec(xxlim)  % ######### PRINT LINE   ############
subpanel(6,1,1),plot([xxlim(1)-10,xxlim(2)+10],[0,0],'Color','k','LineWidth',0.7,'LineStyle','--');
subpanel(6,1,2),plot([xxlim(1)-10,xxlim(2)+10],[0,0],'Color','k','LineWidth',0.7,'LineStyle','--');
subpanel(6,1,3),plot([xxlim(1)-10,xxlim(2)+10],[0,0],'Color','k','LineWidth',0.7,'LineStyle','--');
subpanel(6,1,4),plot([xxlim(1)-10,xxlim(2)+10],[180,180],'Color','k','LineWidth',0.7,'LineStyle','--');
subpanel(6,1,5),plot([xxlim(1)-10,xxlim(2)+10],[0,0],'Color','k','LineWidth',0.7,'LineStyle','--');
subpanel(6,1,6),plot([xxlim(1)-10,xxlim(2)+10],[0,0],'Color','k','LineWidth',0.7,'LineStyle','--');
subpanel(6,1,1),plot(FullmodDataNoise(:,1),FullmodDataNoise(:,2),'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,2),plot(FullmodDataNoise(:,1),FullmodDataNoise(:,3),'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,3),plot(FullmodDataNoise(:,1),FullmodDataNoise(:,4),'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,4),plot(FullmodDataNoise(:,1),theta,'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,5),plot(FullmodDataNoise(:,1),phi,'Color',[1,0.4,0.4],'LineWidth',4);
subpanel(6,1,6),plot(FullmodDataNoise(:,1),BBmod,'Color',[1,0.4,0.4],'LineWidth',4);


[thin,phin,rin]=cart2sph(insit(:,2),insit(:,3),insit(:,4));
thet2=(thin/(2*pi)*360 ); phi2=phin/(2*pi)*360;
theta2=thet2; theta2(thet2<0)=360+theta2(thet2<0);
BMAGin= sqrt( (insit(:,2)).^2 + (insit(:,3)).^2 + (insit(:,4)).^2   );
ax(1)=subpanel(6,1,1);plot(insit(:,1),insit(:,2),'Color',DarkBlue,'LineWidth',1); hold on
ax(2)=subpanel(6,1,2);plot(insit(:,1),insit(:,3),'Color',DarkBlue,'LineWidth',1);hold on
ax(3)=subpanel(6,1,3);plot(insit(:,1),insit(:,4),'Color',DarkBlue,'LineWidth',1);hold on
ax(4)=subpanel(6,1,4);plot(insit(:,1),theta2,'Color',DarkBlue,'LineWidth',1); hold on
ax(5)=subpanel(6,1,5);plot(insit(:,1),phi2,'Color',DarkBlue,'LineWidth',1);hold on
ax(6)=subpanel(6,1,6);plot(insit(:,1),BMAGin,'Color',DarkBlue,'LineWidth',1);hold on
% ax(7)=subpanel(6,1,1);plot(FullmodData(:,1),FullmodData(:,2),'Color',DarkRed,'LineWidth',3);
% ax(8)=subpanel(6,1,2);plot(FullmodData(:,1),FullmodData(:,3),'Color',DarkRed,'LineWidth',3);
% ax(9)=subpanel(6,1,3);plot(FullmodData(:,1),FullmodData(:,4),'Color',DarkRed,'LineWidth',3);
% ax(1)=subpanel(6,1,4);plot(FullmodData(:,1),theta,'Color',DarkRed,'LineWidth',3);
% ax(11)=subpanel(6,1,5);plot(FullmodData(:,1),phi,'Color',DarkRed,'LineWidth',3);
% ax(12)=subpanel(6,1,6);plot(FullmodData(:,1),BBmod,'Color',DarkRed,'LineW
% idth',3);
% for ii=1:1:12; set(ax(ii),'xlim',xxlim); end
for ii=1:1:6; set(ax(ii),'xlim',[xxlim(1)-0.75,xxlim(2)+0.75]); end
TimeAxisSet
set(ax,'Fontsize',14);
addzoomy

set(ax(4),'ylim',[0,360]);
set(ax(4),'ytick',[0,90,180,270,360]); set(ax(4),'yticklabel',{'','90','','270',''});
set(ax(5),'ylim',[-90,90]);
set(ax(5),'ytick',[-90,-45,0,45,90]); set(ax(5),'yticklabel',{'','-45','','45',''});

% Vmag= sqrt( (insit(:,5)).^2 + (insit(:,6)).^2 + (insit(:,7)).^2   );
% Np=insit(:,8);Tp=insit(:,9);
% Beta=insit(:,10);
%% 7. average data to 3hours for Kp insertion
% ave the forecast field data to 3-hr segments.
FullmodDataAve=Ave(FullmodDataNoise,[0,0,0,3,0,0]);


%% 8. Kp prediction
% Vel=VV;       original code for Nature   %Strtemp.Y0=Y0; 

% VVtemp= insit(:,5:7);
% datenum1=insit(:,1);
% points1= datenum1>stTime & datenum1<enTime;
% Vfield=VVtemp(points1,:);
% VVmag= sqrt( (Vfield(:,1)).^2 + (Vfield(:,2)).^2 + (Vfield(:,3)).^2   );
% Vel=mean(VVmag);
Vel=enlilVV;  % <-- using new manual enlil + JSON query

disp(['##----------------##']);
%disp(['Ave Vel from in situ FR =  ', num2str(Vel),' km/s']);
disp(['Ave Vel from Enlil FR Estimate =  ', num2str(Vel),' km/s']);
disp(['##----------------##']);

[KpvecHighRes,O_Struc]=KpEstimate(Vel,FullmodDataAve, varargin);
%[KpvecHighRes,O_Struc]=KpEstimate(Vel,FullmodDataNoise, vararginOVERRIDE);
%% 9. ave the Kp index into 3hr segments
Kpvec=Ave(KpvecHighRes,[0,0,0,3,0,0]);
%Kpvec=Ave(O_Struc.Kp_old,[0,0,0,3,0,0]);

% plot Kp index data with prediction
kpstuff.Kpvec=Kpvec;
kpstuff.stTime=stTime;

outKp= KpIndexplot4(kpstuff, varargin);

%% 10. outputs
O_Bdata=FullmodDataNoise;
StructA.temp1=1;
StructA.temp2=1;

end




