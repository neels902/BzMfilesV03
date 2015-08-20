function [Axis,struA ]= FRaxis( I_tilt,I_fracDis,varargin)
%FRAXIS Summary of this function goes here
%   Detailed explanation goes here
% output cartesian is assumed to be in rtn coord.
% this output has y dirn (rtn) as always +ve


%% inputs
tilt=I_tilt; % deg
FracDis=I_fracDis;

inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};

%what is  2D projection in y-plane


% use cos^2 profile between 180-270 deg for contribution of radial part
th=180:0.5:270;

if FracDis>0
    th_ind=round(FracDis*length(th));
    flag1=0;
elseif FracDis<0
    th_ind=round(-1*FracDis*length(th));
    flag1=1;
else
     th_ind=1;
     flag1=0;
end
rad_ang=((cos(th(th_ind)*d2r)+1).^2) * 90; % deg - equivalent to theta in zdirn

% calc 3D components
PHI2=rad_ang * d2r;
if    flag1>0.1, PHI2=-PHI2; end   % flips the angle so that eventually its outwards
THETA2= (90-tilt) *d2r;
R=1;

[nn,tt,neg_rr] = sph2cart(THETA2,PHI2,R);

% output normalised vector
Axis=[-neg_rr;tt;nn];

struA.THETA2=THETA2*r2d;
struA.PHI2=PHI2*r2d;
struA.flag1=flag1;

%% plot extra for debugging / understanding
if ~isempty(plotfig),
%     t_rang=(cos(th(th_ind)*d2r)+1)*90;
    t_rang=((cos(th(th_ind)*d2r)+1).^2)*90;
    xlen=0:1/(length(th)-1):1;
    figure,
    set(gcf, 'position',[583 9 595 321]);
    plot(xlen,(cos(th*d2r)+1)*90,'-.'),hold on; plot(-xlen,(cos(th*d2r)+1)*90,'-.');
    
    plot(xlen,((cos(th*d2r)+1).^2)*90,'k','LineWidth',2);
    plot(-xlen,((cos(th*d2r)+1).^2)*90,'k','LineWidth',2);
    
    plot([FracDis,FracDis],[0,t_rang],'r','LineWidth',1.5); 
    plot([0 FracDis],[t_rang,t_rang],'r','LineWidth',1.5);
    plot([0,0],[0,t_rang],'r','LineWidth',1.5);
    ylabel('angular comp of FR axis in Radial,[ \circ]');xlabel('Frac away from source center, [Rs]')
end
% outputs

end

