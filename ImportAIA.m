%function [Out1,O_st1]=ImportAIA
% See ImportAIA_v1.m for original with older code for fts file

%imshow(I);

% info=fitsinfo ('fig/AIAfts/event10_20140107_201400_AIA_171_.fts');
% Im2 =fitsread ('fig/AIAfts/event10_20140107_201400_AIA_171_.fts');
% 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/iSWACygnetStreamer?timestamp=2038-08-17%2002:24:47.0&window=-1&cygnetId=237');
inputScript

UrlStart=ftsStr;
AiaImTime= arrTime - datenum([0,0,2,0,0,0]); % Choose AIA image two days prior to CME arrival - not hte latest image
BTst1='iSWACygnetStreamer?timestamp=';
BTst2='iSWACygnetDateStreamer?timestamp=';

tempst='%20';
BTa=datestr(AiaImTime,'YYYY-mm-dd');
BTb=datestr(AiaImTime,'HH:MM:SS');
BTIm=[BTst1,BTa,tempst,BTb];
BTDate=[BTst2,BTa,tempst,BTb];

ETst='.0&window=-1&cygnetId=';
CygId='237';

%% import image from API
WebUrl= [UrlStart,BTIm,ETst,CygId];
str2=webread(WebUrl); 
% str2=imread(ftsStr); 
    
%     info=fitsinfo (ftsStr); % '../AIAfts/event03_20120310_023749_AIA_171_.fts'
%     Im2 =fitsread (ftsStr); % '../AIAfts/event03_20120310_023749_AIA_171_.fts'
% hdr=info.PrimaryData.Keywords;
% Im2=flipud(Im2);
%imagesc(str2)
%%  import image date as a string
WebUrl2= [UrlStart,BTDate,ETst,CygId];
strDatetemp=urlread(WebUrl2); 
strDate=strDatetemp(1:end-4);

%%
B = imresize(str2, 4);
Im2 = rgb2gray(B);
Im2=double(Im2);
%% header info used to crop the image to exact Sun size
Rs_arcs= 976; % Rs_arcs=hdr{86,2};%.rsun_obs; % 976 arc sec for radius of sun
x_RscenPix=2060; % x_RscenPix=hdr{60,2};%.crpix1; % [=2056]
y_RscenPix= 2045; % y_RscenPix=hdr{65,2};%.crpix2; % [=2046]

x_pix2arcs=0.5993; % x_pix2arcs=hdr{59,2};%.cdelt1;
y_pix2arcs= 0.5993; % y_pix2arcs=hdr{64,2};%.cdelt2;


colm_Hafwdth= Rs_arcs ./x_pix2arcs; 
row_Hafwdth= Rs_arcs ./y_pix2arcs; 

colm_Ind= [round(x_RscenPix - colm_Hafwdth) , round(x_RscenPix + colm_Hafwdth)];
row_Ind= [round(y_RscenPix - row_Hafwdth) , round(y_RscenPix + row_Hafwdth)];

Im=Im2(row_Ind(1):row_Ind(2),colm_Ind(1):colm_Ind(2));

%% create best colrmap so far

x0=1;
y0=0.1;
x1=50;
y1=0.9;
x2=64;
y2=1.0;

xlist=1:1:x2;
%xlist=1:(x2/(x2-x0+1)):x2;
ind=1;
%quad
M= (y1 - y0)./ (x1 - x0).^2;
ylist(x0:x1)= M * (xlist(x0:x1)).^2  + y0;
%lin
M = (y2-y1)/(x2-x1);
C1= y1 - M*x1;
ylist(x1:x2)= M *xlist(x1:x2) + C1;

bluelist= zeros(size(xlist));
M = (y2-0)/(x2-x1); C2=y2 - M*x2;
bluelist(x1:x2)= M*xlist(x1:x2) + C2;
% figure,
% plot(xlist,ylist,'r'); hold on
% plot(xlist,bluelist,'b')

b4=[ylist',ylist',bluelist'];
%b4=[ylist',bluelist',ylist'];


% 
% I=Im-min(Im(:))+1;
% 
% % figure,imshow(log(I),[log(10), log(10000)]);
% %colormap('gray')
% colormap(b4)
% colormap(b3)
% 

%% ********** Texture Mapping   ************** %%
% alpha(textu*
% set(h,'CData',flipud(hemisphere),'FaceColor','texturemap')
% hemisphere = [X,ones(257,125),ones(257,125)];
% 
% 
% %%
% 
% b3=[0.134738624069438,0.0432639259733564,0.0432639259733564;0.136774368767931,0.0438792958569387,0.0438792958569387;0.138810113466423,0.0444946657405211,0.0444946657405211;0.140845858164915,0.0451100356241034,0.0451100356241034;0.142881602863407,0.0457254055076857,0.0457254055076857;...
%     0.144917347561900,0.0463407753912681,0.0463407753912681;0.146953092260392,0.0469561452748504,0.0469561452748504;0.148990390832680,0.0475716395358993,0.0475716395358993;0.151038763898848,0.0481880202379807,0.0481880202379807;...
%     0.153103925923593,0.0488057447867370,0.0488057447867370;0.155178203569691,0.0494241989815514,0.0494241989815514;0.157252481215788,0.0500426531763657,0.0500426531763657;0.159326758861886,0.0506611073711801,0.0506611073711801;...
%     0.161401036507984,0.0512795615659945,0.0512795615659945;0.163116258286414,0.0517902913862143,0.0517902913862143;0.158607845025268,0.0504337987134624,0.0504337987134624;0.192903597226875,0.0604318073585887,0.0604318073585887;...
%     0.238895219668145,0.0735006258558036,0.0734700399801964;0.271111753295376,0.0839543822953898,0.0828147306079341;0.293763203169017,0.0978209139033887,0.0914436355023219;0.309123241709461,0.116049037673207,0.100148748120459;...
%     0.321269489011052,0.136475231089149,0.108929192165270;0.332992731051219,0.157801537127207,0.117805571634647;0.344925521176969,0.179771880359341,0.126784021627956;0.357074358662198,0.202334197705794,0.135853275790215;...
%     0.369436691838834,0.225496592273793,0.145010235969235;0.382028007071524,0.249319811644387,0.154259140277635;0.394881378499903,0.273924389998302,0.163610446175392;0.408035993029016,0.299462282511881,0.173075912131725;...
%     0.421495089527558,0.325986683830984,0.182652897364987;0.435277330593194,0.353609849188385,0.192344183438002;0.449394898055364,0.382435403751351,0.202149874120357;0.463896021401878,0.412731154098014,0.212081044892406;...
%     0.478814888470462,0.444718830608466,0.222166270783725;0.494173921591441,0.477113256533267,0.233382192700099;0.509978498312804,0.504986123345284,0.248913762624429;0.526314968868393,0.525824714256561,0.270413362753080;...
%     0.543273469097087,0.543273469097087,0.295521716710020;0.560889319585675,0.560889319585675,0.321914392528601;0.579220517999656,0.579220517999656,0.349345120286033;0.598379007400478,0.598379007400478,0.377971633837596;...
%     0.618489818255930,0.618489818255930,0.407967717479389;0.640357606081308,0.640357606081308,0.440508633485038;0.665300190135166,0.665300190135166,0.477531361918946;0.678583755845334,0.678583755845334,0.497170855255579;...
%     0.692275230880085,0.692275230880085,0.517377088580565;0.706415621996917,0.706415621996917,0.538207035755167;0.721648923232780,0.721648923232780,0.560531602555074;0.737730477221279,0.737730477221279,0.583994858629271;...
%     0.754834442690391,0.754834442690391,0.608822060626120;0.773655782808137,0.773655782808137,0.635852842181491;0.794269417210838,0.794269417210838,0.665014400351558;0.817150290696393,0.817150290696393,0.696692758497632;...
%     0.846885515407721,0.846885515407721,0.734500481119223;0.881584541998633,0.881584541998633,0.775231206675106;0.905872233286613,0.905872233286613,0.802327235790495;0.913353486421346,0.913353486421346,0.808671440805879;...
%     0.920834739556081,0.920834739556081,0.815015645821263;0.927771901553744,0.927771901553744,0.820898454108256;0.942217521242994,0.942217521242994,0.833148537247052;0.956663140932244,0.956663140932244,0.845398620385848;...
%     0.971108760621494,0.971108760621494,0.857648703524645;0.985554380310744,0.985554380310744,0.869898786663441;0.999999999999994,0.999999999999994,0.882148869802237;]
% 
% 
% %% OUTPUTS
% Out1=1;
% 
% O_st1.h=1;
% 
% end