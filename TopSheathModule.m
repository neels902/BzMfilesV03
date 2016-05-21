function [BSheathProxy, OutStruc]= TopSheathModule (InBfield, InStruc)
% Top routine to run all programs in this project
% prototype v1

Bin=InBfield;

%% 01. define the shock normal direction
BfieldCompressionRatio=2;       % max value is 4.
tilt = 0;
HAF= 45;
SolarSource =[10,15]; % [Lat, Lon]

%[BnormVec,OutNorm] = BvectorSet(SolarSource, tilt, HAF);
BnormVec= [-0.8517,-0.3971,0.3420];
% [x,y,z] = sph2cart((-25*d2r),(20*d2r),1);
% BnormVec= [-x,-y,z];

ninitial=BnormVec;
% ninitial=[1,0,0];

LL =length(Bin); % made up length of vector and data
n = repmat(ninitial,LL,1);


%% 02. import the correct raw magnetic data

% import the CCMC API data here


% truncate to 6hr raw data

tinitial=[2015,1,1,00,00,00];
binitial=[1,-1,0]; %observed B field - assumed parker spiral direction

t = repmat(tinitial,LL,1);
b = repmat(binitial,LL,1);

b=Bin(:,2:4);

%% define new direction of field

% simple dot product, as normal component doesn't change
bn=(n(:,1).*b(:,1)) + (n(:,2).*b(:,2)) + (n(:,3).*b(:,3)) ; 
bnormal=[bn.*n(:,1),bn.*n(:,2),bn.*n(:,3)];

% perp to normal direction for compression
bperp=(b-bnormal);

%% increase field strength and PMS for downstream

bperp=BfieldCompressionRatio * (b-bnormal); % strong limiting case for shock compression in perp direction

bdown= bperp + bnormal;

%% compress the data timecadence



%% 41. OUTput the Bfield
BSheathProxy=bdown;
OutStruc=1;

return
