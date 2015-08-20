% function linevec=CreateFRaxis(I_lat, I_lon,I_tilt,I_haf)
% lat= I_lat ;    % in deg
% lon= I_lon  ;   % in deg
% tilt= I_tilt ;    % in deg
% haf= I_haf ;    % in deg half angle, alpha from GCS

axisDist= 1.0* (2.0*haf*d2r);  % r*theta -- ie in radians
N_seg=200;  % this is half number 
segLen=axisDist./(N_seg*2);   
D_lon= segLen * cos(tilt*d2r);
D_lat= segLen * sin(tilt*d2r);

% define the entire lon and lat of the FR axis line as an array
templon=(D_lon:D_lon:D_lon*N_seg)';
templon2=flipud(templon);
if isempty(templon), templon=zeros(N_seg,1); templon2=templon; end
lonLine= [((lon*d2r)-templon2);(lon*d2r);((lon*d2r)+templon)];

templat=(D_lat:D_lat:D_lat*N_seg)';
templat2=flipud(templat);
if isempty(templat), templat=zeros(N_seg,1); templat2=templat; end
latLine= [((lat*d2r)-templat2);(lat*d2r);((lat*d2r)+templat)];

linevecb=[latLine,lonLine];


%return
