function [BTimeSeries, StrucA]= FRProfile(I_eul_ang, I_Y0,I_BBmag, I_MagDirn, I_StrAxis,varargin)

% USES:  rev_MVA, FRmodel, CreateTimeVectors, TimeAxisSet

eul_ang=I_eul_ang;
%FRaxis=I_StrAxis.FRaxis;
Y0=I_Y0;     % *** need to adjust for above n below
B0=I_BBmag;
MagDirn=I_MagDirn;

tilt=eul_ang(1);
radial_ang=eul_ang(2);
phi_e3=eul_ang(3);

stTime= I_StrAxis.stTime;
enTime= I_StrAxis.enTime;

inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};
inputScript  % -- use for cycle parameter

%dBvecs=[e_min,e_int,e_max];

% FR model
veclen=200;
alpha=2.4;

%% do the chirallity thing here  !!!!!!
%   -90 <tilt < 90
Chiral=1;
Cycle=cycle;
if strcmpi(MagDirn,'North')
    Chiral=-1;       %  'LH'
    if rem(Cycle,2)<0.1  % cycle 24
        check=2.0;       %   B2; axis pointing West (right)
        BothmerConfig= 'NWS';
    else    % cycle 23
        check=4.0;       %   B4; axis pointing East (left)
        BothmerConfig= 'SEN';
    end
    Chiralstr= 'Left handed';
elseif strcmpi(MagDirn,'South') |strcmpi(MagDirn,'south')
    Chiral= 1;       %  'RH'
    if rem(Cycle,2)<0.1  % cycle 24
        check=1.0;       %   B1; axis pointing East (left)
        BothmerConfig= 'NES';
    else    % cycle 23
        check=3.0;       %   B3; axis pointing West (right)
        BothmerConfig= 'SWN';
    end
    Chiralstr= 'Right handed';
end

% Note:   -90< tilt <90
% note: if the tilt is between 90 and 270 (B1,B4)... it is equivalent to going from 
% above to below the axis. This gives the correct vectors from original RH
% FR model. But all vectors need to be rotated to the correct tilt + 180deg
checkY0=1;
if check == 1.0 || check == 4.0;
    checkY0=-1;   %  equiv. of impact parameter flip
    tilt=tilt+180;  % to make sure the correct matrix rotation is performed - assumes angles 90-> 270 are ok
end
Y0= checkY0*Y0;


%% evectors create
RRmatrix=rev_MVA(tilt,radial_ang,phi_e3);


disp(['Quadrant =' num2str(check)]);
disp(['checkY0 =' num2str(checkY0)]);
disp(['Chiral =' Chiralstr]);
disp(['tilt =' num2str(tilt)]);
disp(['Bothmer FR configuration=' BothmerConfig]);
disp(['##----------------##']); 

dBvecs=FRmodel(Y0, B0, veclen, alpha);

emBmin=Chiral*dBvecs(:,1)';
emBint=dBvecs(:,2)';
emBmax=Chiral*dBvecs(:,3)';


%% rotate into axes

Bfield= RRmatrix* [emBint;emBmax;emBmin];


% define chirality
% if statements for tilt and magdirn

%%  visualise the new field vectors

if ~isempty(plotfig), 
    figure
    subpanel(3,1,1),plot(1:1:veclen,Bfield(3,:))
    subpanel(3,1,2),plot(1:1:veclen,Bfield(1,:))
    subpanel(3,1,3),plot(1:1:veclen,Bfield(2,:))
    subpanel(3,1,1),ylabel('B_{r} [nT]')
    subpanel(3,1,2),ylabel('B_{t} [nT]')
    subpanel(3,1,3),ylabel('B_{n} [nT]')
    
    figure
    subplot(3,1,1),plot(1:1:veclen,dBvecs(:,1),'k'); hold on; plot(1:1:veclen,emBmin)
    subplot(3,1,2),plot(1:1:veclen,dBvecs(:,2),'k'); hold on; plot(1:1:veclen,emBint)
    subplot(3,1,3),plot(1:1:veclen,dBvecs(:,3),'k'); hold on; plot(1:1:veclen,emBmax)
    subplot(3,1,1),ylabel('B_{min} [nT]')
    subplot(3,1,2),ylabel('B_{int} [nT]')
    subplot(3,1,3),ylabel('B_{max} [nT]')
end
%print(OutStruc.fig4,'-dpng','-r300','fig/f04Bvectors.png')
%print(OutStruc.fig4,'-dpsc2','-r300','fig/f04Bvectors.ps')
%saveas(OutStruc.fig4,'fig/f04Bvectors.png')
%saveas(OutStruc.fig4,'fig/f14Bvectors.eps','psc2')

%% add correct time stamps to the field vectors
TotNum=length(Bfield(1,:));
Timeserie=CreateTimeVectors(stTime,enTime,TotNum);

Bseries=[Timeserie,-Bfield(3,:)',-Bfield(1,:)',Bfield(2,:)'];   % -ve for GSE coord system!!! not RTN

if ~isempty(plotfig), 
    OutStruc.fig4=figure;
    set(gcf,'Units','centimeters')
    set(gcf,'Position',[15.3,0.2,16.0,10.4])
    set(OutStruc.fig4,'Name',['MTseris Bz: Fig.4 - B-field vectors']);
    set(OutStruc.fig4,'NumberTitle', 'off');
    FF= 14; % FontSize
      subpanel(3,1,1),plot(Bseries(:,1),-Bseries(:,2),'Color',DarkGreen,'LineWidth',0.5); % this is the rtn equivalent
      subpanel(3,1,2),plot(Bseries(:,1),-Bseries(:,3),'Color',DarkGreen,'LineWidth',0.5);
      subpanel(3,1,3),plot(Bseries(:,1),Bseries(:,4),'Color',DarkGreen,'LineWidth',0.5);
    subpanel(3,1,1),plot(Bseries(:,1),Bseries(:,2),'Color',DarkGreen,'LineWidth',3);
    subpanel(3,1,2),plot(Bseries(:,1),Bseries(:,3),'Color',DarkGreen,'LineWidth',3);
    subpanel(3,1,3),plot(Bseries(:,1),Bseries(:,4),'Color',DarkGreen,'LineWidth',3);
    subpanel(3,1,1),ylabel('B_{x} GSE [nT]','fontsize',FF)
    subpanel(3,1,2),ylabel('B_{y} [nT]','fontsize',FF)
    subpanel(3,1,3),ylabel('B_{z} [nT]','fontsize',FF)
    TimeAxisSet
    addzoomy
end
BTimeSeries=Bseries;

% outputs
StrucA=1;


end
