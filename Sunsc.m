% self contained script for testing how best to draw sun in 2D figure

th=90:-2:1;
tlat=1-(cos(th'*d2r).^3);
tlon=1-(cos(th*d2r).^3);
tlonmat=repmat(tlon,length(th),1);
tlatmat=repmat(tlat,1,length(th));
tmat=tlatmat.*tlonmat;

tmat1=fliplr(tmat);
tmat2=[tmat1,tmat];
tmat3=flipud(tmat2);

tMat=[tmat3;tmat2];

%figure vperspec
%axesm ('vperspec', 'Frame', 'on', 'Grid', 'on');tightmap;
axesm ('ortho', 'Frame', 'on', 'Grid', 'on');tightmap;
colormap('Autumn')
[latte, lonte] = meshgrat(tMat, [length(th)./90,90,-90]);
h=surfacem(latte,lonte,tMat);
%meshm(tMat, [length(th)./90,90,-90])
%caxis([-1,1])
%axis off

ImportAIA
% ImportAIA_v1  % for manual changes to SOlar imagery 

%hemisphere = [ones(257,125),X,ones(257,125)];

%hemisphere = log(Im-min(Im(:))+1);
hemisphere = Im;
set(h,'CData',flipud(hemisphere),'FaceColor','texturemap')
%caxis([log(10), log(10000)]) - for fts files
caxis([0,300])
colormap(b4)

clear Im hemisphere
text(0,-0.85,strDate, 'color',DarkBlue ,'horizontalalignment','center','Rotation',0,'FontSize',15)

%% testing demo for Earth rendering as it is faster
% load earth
% %hemisphere = [ones(257,125),X,ones(257,125)];
% hemisphere = X;
% set(h,'CData',flipud(hemisphere),'FaceColor','texturemap')
% colormap(map)
% 
% 
% 
%%
temp=1;


%load topo
%axesm globe; view(120,30)
%meshm(topo,topolegend); demcmap(topo)

%Fitting Gridded Data to the Graticule
