% find point P
% will find the whole array- the last point is the one needed
azim=90-tilt;
azim_perp=azim-90;
shade1=fullCMEcutoff*r2d;
[latgc,longc] = track1('gc',lat,lon,azim_perp,[0,360]);
[distgc,aztemp]=distance(lat,lon,latgc,longc);
tempa=round(0.5*length(distgc));
[a1,In1]=min(abs(distgc(1:tempa)-avCMEhaWidth*r2d));
if ~isempty(varargin), 
    %linem(latgc,longc,'r')
    %geoshow(latgc(In1),longc(In1),'Marker','s','MarkerSize',10)
end

%create line of point parrelel to axis
latLine=linevec(:,1)*r2d;
lonLine=linevec(:,2)*r2d;
[latoutt,lonoutt] = reckon(latLine,lonLine,shade1*ones(length(latLine),1),azim_perp*ones(length(latLine),1));
linem(latoutt, lonoutt,'color','k','linewidth',1)


% repeat for the other axis
azim_perp2=azim_perp+180;
latLine=linevec(:,1)*r2d;
lonLine=linevec(:,2)*r2d;
[latoutb,lonoutb] = reckon(latLine,lonLine,shade1*ones(length(latLine),1),azim_perp2*ones(length(latLine),1));
linem(latoutb, lonoutb,'color','k','linewidth',1)




% create semis circle to connect lines
latLine=linevec(:,1)*r2d;
lonLine=linevec(:,2)*r2d;
[temp,azpt]=distance(latLine(end),lonLine(end),latoutt(end), lonoutt(end));

%geoshow(latoutt(end), lonoutt(end),'color','w','Marker','p','MarkerSize',10)
sct = scircle1(latLine(end),lonLine(end),shade1,[azpt, azpt+180]);
plotm(sct(:,1), sct(:,2),'b--');


[temp,azpt]=distance(latLine(1),lonLine(1),latoutt(1), lonoutt(1));
scb = scircle1(latLine(1),lonLine(1),shade1,[azpt+180,azpt+360]);
plotm(scb(:,1), scb(:,2),'b--');



% connect polygon and fill
latc=[latoutt;sct(:,1);flipud(latoutb);scb(:,1)];
lonc=[lonoutt;sct(:,2);flipud(lonoutb);scb(:,2)];
patchm(latc,lonc,'w','FaceAlpha',0.3)



% 
% rng2=initang * ones(length(az),1);
% [latout2, lonout2] = reckon(lat, lon, rng2, az);
% % better toolbox code: [latc,longc] = scircle1(0,0,10);
% linem(latout2,lonout2,0.01,'r')
% h_fill=fillm(latout2,lonout2,'FaceColor','blue','FaceAlpha',0.2);

%blank_globe=zeros(180,180);


temp=1;










%{

domeAlt=-0.1;
domeRadius=rng2(1)*d2r;
alma=almanac('earth','radius','km');  % grs80 = almanac('earth','grs80','km');
eccentricity1=0;
grs80ns=[1,0];  % [alma, eccentricity]
[x,y,z] = sphere(20);
xLV = domeRadius * x;
yLV = domeRadius * y;
zLV = domeRadius * z;

zLV(zLV < 0) = 0;
[xECEF, yECEF, zECEF] = lv2ecef(xLV, yLV, zLV, ...
    lat * pi/180, lon * pi/180, domeAlt,grs80ns);
%surf(xECEF, yECEF, zECEF,'FaceColor','blue','FaceAlpha',0.3,'LineStyle', 'none')
surf(xECEF, yECEF, zECEF,'FaceColor','blue','FaceAlpha',0.3)

%then create a general [lat,lon] semi globe

% then use logical to remove the repeated positions

% convert nm distance to degrees
%dist = nm2deg(600)





%}



