function [OUTPUTkpvec,O_Struc]=KpEstimate(I_Vel,I_FullmodDatanoise, varargin)
% USED BY: Bestimate

% importing Kp data is done by routines inside mfiles sub-folder
%%
vel=I_Vel;
Bdata=I_FullmodDatanoise;

Time=Bdata(:,1);
Bx=Bdata(:,2);
By=Bdata(:,3);
Bz=Bdata(:,4);
BB=Bdata(:,5);
B0=max(BB);

inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};



%% calculate Kp from old CCMC |B| system
% clockl angle goes  0 < theta_c  <180
thetaART=90 *d2r;  % WEST
dPhi=(vel.^(4/3)) .* (B0.^(2/3)) ;
Kp_linearA(1,1) = 1.0 + 0.0002947 *(dPhi .*  (nthroot(((sin(0.5*thetaART)).^8) ,3) )  );
Kp_newA(1,1)=9.5 - exp(2.17676 - 0.52001*0.0001*(dPhi .* (nthroot(((sin(0.5*thetaART)).^8) ,3) )   ) );
thetaART=135 *d2r;  % SOUTH-WEST
Kp_linearA(1,2) = 1.0 + 0.0002947 *(dPhi .*  (nthroot(((sin(0.5*thetaART)).^8) ,3) )  );
Kp_newA(1,2)=9.5 - exp(2.17676 - 0.52001*0.0001*(dPhi .* (nthroot(((sin(0.5*thetaART)).^8) ,3) )   ) );
thetaART=180 *d2r;  % SOUTH
Kp_linearA(1,3) = 1.0 + 0.0002947 *(dPhi .*  (nthroot(((sin(0.5*thetaART)).^8) ,3) )  );
Kp_newA(1,3)=9.5 - exp(2.17676 - 0.52001*0.0001*(dPhi .* (nthroot(((sin(0.5*thetaART)).^8) ,3) )   ) );

%% calculate Kp from new vector system
theta=atan(By./Bz);        % clockl angle goes  0(North) < theta_c  <180 (South)
theta2=theta;
% perform corrections for each quandrant
a=find(theta<0 & By>0 );  % Q2
b=find(theta<0 & By<0 );  % Q4
c=find(theta>0 & By<0 );  % Q3
d=find(theta>0 & By>0 );  % Q1

%Q2
theta(a)= theta(a) + (180*d2r);
%Q4
theta(b)= theta(b) + (360*d2r);
%Q3
theta(c)= theta(c) + (180*d2r);

if ~isempty(plotfig)
    hClock=figure;
    plot(theta*r2d,'r-')
    ylabel('clock angle [deg]')
    xlabel('FR array index')
    set(hClock,'Name',['Clock Angle']);
end


dPhi=(vel.^(4/3)) .* (BB.^(2/3)) ;
Kp_linear = 1.0 + 0.0002947 *(dPhi .*  (nthroot(((sin(0.5*theta)).^8) ,3) )  );

Kp_new=9.5 - exp(2.17676 - 0.52001*0.0001*(dPhi .* (nthroot(((sin(0.5*theta)).^8) ,3) )   ) );


%% create output arguments 
Kpvec=[Time,Kp_new];
Kp_old=[Time,Kp_linear];
O_Struc.Kp_old=Kp_old;
O_Struc.Kp_linearA= Kp_linearA;
O_Struc.Kp_newA=Kp_newA;

if ~isempty(plotfig)
    ha_kpest=figure;
    plot(Time,Kp_linear,'Color',DarkGreen,'LineWidth',1);
    hold on
    plot(Time,Kpvec(:,2),'Color',DarkRed,'LineWidth',3);

    ylabel('predicted kp Index')
    set(ha_kpest,'Name',['Kp estimate']);
    TimeAxisSet
    
end

%% running ave for 6 or 9 hr window.
Runave=0;
if Runave~=0
    dday=Runave./24;
    dt=Time(2)-Time(1);
    VecNum=round(dday./dt);
    VecLength=length(Time);

    KpCumSum=cumsum(Kpvec(:,2));
    KpCumSumVN=KpCumSum(VecNum:end);

    temp= KpCumSumVN(2:end)-KpCumSum(1:end-VecNum);
    KpRunSum=[KpCumSumVN(1);temp];

    KpRunAve=KpRunSum./ VecNum;
    KpvecRunAve=[Time(1:end-VecNum+1),KpRunAve];

%     if ~isempty(plotfig)
%         plot(KpvecRunAve(:,1),KpvecRunAve(:,2),'Color',DarkBlue,'LineWidth',2);
%         legend(gca,'Kp Linear eqn','Kp Exponential eqn','Kp runnning Ave')
%         plot(Time,Kp_newA(1,1)*ones(length(Time)),'Color','k','LineWidth',1);
%         plot(Time,Kp_newA(1,3)*ones(length(Time)),'Color','k','LineWidth',1);
%     end
    OUTPUTkpvec=KpvecRunAve;
else
    OUTPUTkpvec=Kpvec;
end;

if ~isempty(plotfig)
        plot(OUTPUTkpvec(:,1),OUTPUTkpvec(:,2),'Color',DarkBlue,'LineWidth',2);
        legend(gca,'Kp Linear eqn','Kp Exponential eqn','Kp runnning Ave')
        plot(Time,Kp_newA(1,1)*ones(length(Time)),'Color','k','LineWidth',1);
        plot(Time,Kp_newA(1,3)*ones(length(Time)),'Color','k','LineWidth',1);
    end    
%%
% figure
% subpanel(5,1,1),plot(Bx,'k-')
% subpanel(5,1,2),plot(By,'k-')
% subpanel(5,1,3),plot(Bz,'k-')
% subpanel(5,1,4),plot(BB,'k-')
% subpanel(5,1,5),plot(Kp_new,'g-')
% 
% subpanel(5,1,1),plot(190,Bx(190),'r+')
% subpanel(5,1,2),plot(190,By(190),'r+')
% subpanel(5,1,3),plot(190,Bz(190),'r+')
% subpanel(5,1,4),plot(190,BB(190),'r+')
% subpanel(5,1,5),plot(190,Kp_new(190),'r+')
% 
% subpanel(5,1,1),plot(230,Bx(230),'r+')
% subpanel(5,1,2),plot(230,By(230),'r+')
% subpanel(5,1,3),plot(230,Bz(230),'r+')
% subpanel(5,1,4),plot(230,BB(230),'r+')
% subpanel(5,1,5),plot(230,Kp_new(230),'r+')
% 
% subpanel(5,1,1),plot(295,Bx(295),'r+')
% subpanel(5,1,2),plot(295,By(295),'r+')
% subpanel(5,1,3),plot(295,Bz(295),'r+')
% subpanel(5,1,4),plot(295,BB(295),'r+')
% subpanel(5,1,5),plot(295,Kp_new(295),'r+')
% 
% subpanel(5,1,1),ylabel('B_{x} GSE [nT]')
% subpanel(5,1,2),ylabel('B_{y} [nT]')
% subpanel(5,1,3),ylabel('B_{z} [nT]')
% subpanel(5,1,4),ylabel('|B| [nT]')
% subpanel(5,1,5),ylabel('Kp ')


%OUTPUTkpvec=Kpvec;
%OUTPUTkpvec=KpvecRunAve;
end