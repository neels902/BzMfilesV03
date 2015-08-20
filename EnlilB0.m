function [Bearth,Vearth]= EnlilB0(I_String,vararginA)
 % adjustment to L5 for Bztool
instring=I_String;

%filePath=['../Insitu/enlil/',instring,'.txt'];
filePath=instring;


data=importEnlildata(filePath);

% yy mm dd hh mm BB VV nn TT

dd=[data(:,1:5),zeros(size(data,1),1)];
date=datenum(dd);
bb= data(:,6);
vv= data(:,7);
nn= data(:,8);
tt= data(:,9);
%Find max ram pressure
rampress=nn.* (vv.*vv);
[c,i]=max(rampress);
% find corresponding BB and VV for max ram pressure location
Vearth=vv(i);
Vmax=max(vv);
Bearth=bb(i);
Bmax=max(bb);

% backup solution
%BEarth=10.42 ;
if isempty(vararginA) || strcmpi(vararginA, 'quiet')
    disp(['|B| for Enlil Sheath =  ', num2str(Bearth),' nT']);
    disp(['Vel for Enlil Sheath =  ', num2str(Vearth),' km/s']);
else
    figure
    subpanel(4,1,1),plot(date,nn,'color',DarkRed,'linewidth',3);hold on
    subpanel(4,1,1),plot(date(i),nn(i),'color','g','MarkerSize',8,'Marker','o','MarkerFaceColor','g');
    
    subpanel(4,1,2),plot(date,vv,'color',DarkRed,'linewidth',3);hold on
    subpanel(4,1,2),plot(date(i),vv(i),'color','g','MarkerSize',8,'Marker','o','MarkerFaceColor','g');

    subpanel(4,1,3),plot(date,rampress,'color',DarkBlue,'linewidth',3); hold on
    subpanel(4,1,3),plot(date(i),rampress(i),'color','g','MarkerSize',8,'Marker','o','MarkerFaceColor','g');

    subpanel(4,1,4),plot(date,bb,'color',DarkRed,'linewidth',3); hold on
    subpanel(4,1,4),plot(date(i),bb(i),'color','g','MarkerSize',8,'Marker','o','MarkerFaceColor','g');
    
    subpanel(4,1,1),ylabel('Density','Fontsize',12);
    subpanel(4,1,2),ylabel('Velocity','Fontsize',12);
    subpanel(4,1,3),ylabel('ram Pressure','Fontsize',12);
    subpanel(4,1,4),ylabel('|B|','Fontsize',12);
    TimeAxisSet
    addzoomy
    disp(['|B| for Enlil Sheath =  ', num2str(Bearth),' nT']);
    disp(['Vel for Enlil Sheath =  ', num2str(Vearth),' km/s']);
end


return
