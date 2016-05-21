function [BnormVec,OutNorm] = BvectorSet(SolarSource, I_tilt, I_HAF)



tilt=I_tilt; % deg
HAF=I_HAF;
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

