function [E2dist,FracDist,OutStruc] = Earth2FRaxis( I_EarthPos,I_lon,I_lat,I_tilt, I_haf, varargin )
%EARTH2FRAXIS find shortest dist. from anywhere on source axis to Earth pos
%
% sledgehammar approach.  need to find time to solve mathematically/elaganatly 
% OUTPUT:  E2dist   - is the shortest distance to FR axis in Rs
% OUTPUT:  FracDist - is the frac. distance from: 
%            (FR axis centre to closest approach) ./(0.5*length of FR axis)
%               -> this is used for estimating the radial comp. of FR axis
%
% OUTPUT:  Y0mag    - is +1/-1 dependant if Earth is above/below FR axis
%
% USES:   CreateFRaxis; Sunsc; 

%% INPUTS
EarthPos= I_EarthPos ;  % in deg  (lon, lat)
lon= I_lon  ;   % in deg
lat= I_lat ;    % in deg
tilt= I_tilt ;    % in deg
haf= I_haf ;    % in deg half angle, alpha from GCS
inputString=varargin{1,1}{1,2};  % used in Sunsc>importAIA
plotfig=varargin{1,1}{1,1};
varargin=varargin{1,1};

%% prog. also used within CalcImpactparam
CreateFRaxis; 

%linevec=CreateFRaxis(lat, lon,tilt,haf);
%latLine=linevec(:,1);
%lonLine=linevec(:,2);
linevec=linevecb;
OutStruc.linevec=linevec;


%% find the minim distance to Earth
for ii=1:1:length(lonLine)
    Ang2Ear(ii,1) = totAng(lonLine(ii,1)-EarthPos(1), latLine(ii,1)-EarthPos(2));
end

[E2dist,IfrPos]=min(Ang2Ear);

% frac along the FR axis- needed to estimate radial comp. of insitu FR axis
% +ve is above source; -ve is below source
%if I<N_seg, a=-1; else a=1; end;
FracDist=(IfrPos-N_seg)./N_seg;
Re=ones(length(lonLine),1)*6371;




%% find the magnitude of Y0 - ie if Earth is above/below the FR
if EarthPos(2)> latLine(IfrPos)*r2d,
    OutStruc.Y0mag=1;
else
    OutStruc.Y0mag=-1;
end


%% Inport solar image?!?
%ImportAIA

%% plot schem. of Sun; Earth pos; FR axis pos; shaded reg. of impact
%%% axesm, plotm, 
if ~isempty(plotfig),
    %[s1,s2,s3]=sphere(50);
    %C=s1-0.1;
    
    OutStruc.fig1=figure;
    %surf(s1,s2,s3,C,'LineStyle', 'none','FaceColor','interp');
    %colormap('Autumn')
    %axesm ('globe','Grid', 'on');
    %view(90,0)
    Sunsc   % new version of sun - only in 2D not 3D globe..
    axis off
    
    set(gcf,'Units','centimeters')
    set(gcf,'Position',[1.0,0.5,14.0,13.5])
    set(OutStruc.fig1,'Name',['Bz4Cast:1 - Sun']);
    set(OutStruc.fig1,'NumberTitle', 'off');
    FF= 14; % FontSize

    linem(latLine*r2d, lonLine*r2d,'color','k','linewidth',2)
    linem(latLine*r2d, lonLine*r2d,Re./(6371*500),'color','w','linewidth',2.5,'linestyle','--')
%    linem(latLine*r2d, lonLine*r2d,'color','w','linewidth',3,'linestyle','--')
    
    %------ CREATES THE PERP BLUE LINE, EARTH 2 FRaxis
    [lat1,lon1] = interpm([EarthPos(2),latLine(IfrPos)*r2d],[EarthPos(1),lonLine(IfrPos)*r2d],2);
    tempr=0.01* ones(length(lat1),1);
    linem(lat1, lon1,'color','b','linewidth',1.5) % this one gets hidden by FRaxis white line
    linem(lat1, lon1,Re(1:length(lon1))./(6371*500),'color','b','linewidth',2.5,'linestyle',':')
    
%geoshow(TowerLat, TowerLon, 'Marker','.','MarkerEdgeColor','red')
    geoshow(EarthPos(2),EarthPos(1),'Marker','o','MarkerSize',8,'color','g','MarkerFaceColor','g')
    geoshow(lat,lon,'Marker','s','MarkerSize',14,'MarkerEdgeColor',DarkBlue, 'MarkerFaceColor',DarkBlue,'linewidth',2)
    %geoshow(lat,lon,'Marker','s','MarkerSize',10,'MarkerEdgeColor',[0.08,0.17,0.55], 'MarkerFaceColor','cyan','linewidth',2)
    geoshow(latLine(end)*r2d,lonLine(end)*r2d,'Marker','o','MarkerSize',10,'MarkerEdgeColor',[0.55,0.17,0.08],'linewidth',2)
    geoshow(latLine(1)*r2d,lonLine(1)*r2d,'Marker','+','MarkerSize',14,'MarkerEdgeColor',[0.55,0.17,0.08],'linewidth',2)
    %plotm(lat,lon,'x','MarkerSize',10,'color','b','linewidth',3)
         %    print(OutStruc.fig1,'-dpng','-r300','fig/f01Sun.png','-zbuffer')
%    print(OutStruc.fig1,'-dpsc2','-r300','fig/f01Sun.ps','-zbuffer')
    %saveas(OutStruc.fig1,'fig/f01Sun.png')
    %saveas(OutStruc.fig1,'fig/f11Sun.eps','psc2')

end
%%


end

%{



axesm ortho
[c,h]=contour3m(geoid, geoidrefvec, 50,'EdgeColor','black');
zdatam(handlem('surface'),min(geoid(:))); 
geoshow(geoid,geoidrefvec,'DisplayType','surface')
zdatam(handlem('surface'),min(geoid(:)));


code to try to convert ot 2D:

axesm ('vperspec', 'Frame', 'on', 'Grid', 'on');
axesm ('ortho', 'Frame', 'on', 'Grid', 'on');

th=90:-1:1;
tlat=1-cos(th'*d2r);
tlon=1-cos(th*d2r);
tlonmat=repmat(tlon,90,1);
tlatmat=repmat(tlat,1,90);

testsc

%}



