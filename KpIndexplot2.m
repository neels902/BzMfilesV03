function outPP_h =KpIndexplot2(varargin)

% http://www.mathworks.com/matlabcentral/answers/58971-bar-plot-with-bars-i
% n-different-colors

%http://stackoverflow.com/questions/13266352/matlab-bar-graph-fill-bars-wit
%h-different-colours-depending-on-sign-and-magnit

%% 
if nargin< 1,
    Kpvec=[];
elseif nargin==1
    Kpvec=varargin{1,1}.Kpvec;
    stTime=varargin{1,1}.stTime;
end

%% Import the Kp data
load('..\Insitu\Omni\Kp03_13.mat');

ind22=find(Kp(:,1)>stTime);


KPmatrix22= Kp(ind22(1)-2:ind22(1)+2,:);  % 5 days of data starting 1/2 days prior
KPmatrix= KPmatrix22(:,2:end);
% 1,1,2,1,1,1,1,0;...
%            0,1,1,0,1,1,2,2;...
% KPmatrix= [1,2,0,1,1,3,3,3;...
%            3,3,1,1,1,1,1,2;...
%            3,3,2,2,1,1,3,2;...
%            2,2,1,1,1,2,1,1;...
%            0,0,0,0,1,1,3,2];


% KPmatrix= [1,1,2,1,4;...
%            0,1,6,0,7];       

NN=size(KPmatrix,1);
PP=size(KPmatrix,2);
for ii=1:1:NN
    data((PP*ii-(PP-1)):(PP*ii),1)=KPmatrix(ii,:);
end
N=numel(data);


%% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& %%
figure
set(gcf,'Units','centimeters')
set(gcf,'Position',[11.8,6.7,16.3,10.0])
%%%%%%%%%%%%%%%%%%%%% horizontal lines for kp= 2, 4, 6, 8 
ha1=plot([0 N],[2 2],'Color',[0,0.8,0],'LineStyle','-','Linewidth',1);hold on
ha2=plot([0 N],[3 3],'Color',[0,0.8,0],'LineStyle',':','Linewidth',1);
ha3=plot([0 N],[4 4],'Color',[0.8,0.8,0],'LineStyle','-','Linewidth',1);
ha4=plot([0 N],[5 5],'Color',[0.8,0,0],'LineStyle',':','Linewidth',1);
ha5=plot([0 N],[6 6],'Color',[0.8,0,0],'LineStyle','-','Linewidth',1);
ha6=plot([0 N],[8 8],'Color',[0.8,0,0],'LineStyle','-','Linewidth',1);
%%%%%%%%%%%%%%%%%%%%%
hb=bar(data); 
set(get(hb,'children'),'cdata', sign(data-4) );
colormap([0 1 0;1 1 0; 1 0 0]);
caxis([3 5])

hbar=gca;
set(hbar,'Units','centimeters') 
set(hbar,'Position',[1.9,1.7,12.5,7.0])
%% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& %%



xlim([0.5,(N+0.5)]);
ylim([0 9]);
ylabel('Kp Index','FontSize',15)
xlabel('','FontSize',15)
set(hbar, 'XTickLabel', '')
set(hbar,'XTick',[])
set(hbar,'fontsize',15)
set(hbar, 'ytick',[1,2,3,4,5,6,7,8,9])
set(hbar,'YMinorTick','off')
set(hbar, 'yticklabel',{'','2','','4','','6','','8',''})



% vertical lines for start of ea day
% for jj=1:1:NN
%     ha3=plot([PP*jj-(PP-1), PP*jj-(PP-1)],[0 9],':k','Linewidth',1);
% end
% hb=bar(data);
%hb=bar(data,'style','hist');

kptxt={'Kp<4','Kp=4','Kp>4'};
text(N+(N/30),2,kptxt{1,1}, 'color',DarkGreen, ...
     'horizontalalignment','center','Rotation',90,'FontSize',15)
text(N+(N/30),4.2,kptxt{1,2}, 'color','yellow' , ...
     'horizontalalignment','center','Rotation',90,'FontSize',15)
text(N+(N/30),6.6,kptxt{1,3}, 'color',DarkRed , ...
     'horizontalalignment','center','Rotation',90,'FontSize',15)

% % '05 Jan','','','','','','','',...
% %             '06 Jan','','','','','','','',...
% uniNames = {'07 Jan','','','','','','','',...
%             '08 Jan','','','','','','','',...
%             '09 Jan','','','','','','','',...
%             '10 Jan','','','','','','','',...
%             '11 Jan','','','','','','',''};
%         
% xlabetxt = uniNames';
% ypos = -max(ylim)/25;
% set(gca,'XTick',1:8:57)
% text(1:N,repmat(ypos,N,1), ...
%      xlabetxt','horizontalalignment','center','Rotation',0,'FontSize',15)


%%%%%%%%%%%%%%%   stairs(x,sin(x))
%%%%%%%%%%%%%%%  BarCenters = [x1]  MATLAB 2014a  !!!!!
outPP_h=hb;



%% overplot Timaeaxis with extra stuff
ax2_2 = axes('Units','centimeters','Position',get(hbar,'Position'),...
           'XAxisLocation','bottom',...
           'YAxisLocation','right',...
           'Color','none',...
           'XColor',[0.0,0.0,0.0],'YColor',[0.0,0.0,0.0]);
h2_2 = line(Kpvec(:,1),Kpvec(:,2),'Color',[0.6,0.0,0.0],'LineStyle','-','Linewidth',2.5,'Parent',ax2_2);
hold on
h2_3=stairs(Kpvec(:,1),Kpvec(:,2),'Color',[1.0,0.6,0.6],'LineStyle','-','Linewidth',2.5,'Parent',ax2_2);hold on
delete(h2_2)
clear h2_2
t1=KPmatrix22(1,1);t2=KPmatrix22(end,1)+1;
%t1=datenum([2014,01,07,0,0,0]);t2=datenum([2014,01,12,0,0,0]);
set(ax2_2,'XLim',[t1,t2])
set(ax2_2,'ylim',get(hbar,'ylim'))
set(ax2_2, 'ytick',t1:1:t2-1)
set(ax2_2,'fontsize',15)
xlabel('Universal Time','FontSize',15)

%TimeAxisSet ('mat',ax2_2)
disp(['st time=  ', num2str(t1)]); disp(['st time KP=  ', num2str(KPmatrix22(1,1))]);
disp(['en time=  ', num2str(t2)]);disp(['en time KP=  ', num2str(KPmatrix22(end,1))]);

% vertical lines for start of ea day
for jj=1:1:NN+1
    ha3=plot([t1+jj-1,t1+jj-1],[0 9],':k','Linewidth',1,'Parent',ax2_2);
end
%hb=bar(data);

% uniNames = {'15 Jun','16 Jun','17 Jun','18 Jun','19 Jun','20 Jun'};
uniNames = {'07 Jan','08 Jan','09 Jan','10 Jan','11 Jan','12 Jan'};
set(ax2_2,'XTickLabel',uniNames );

%% DISPLAY:
% the NASA CCMC prediction on 2014 event
% t1ccmc=datenum([2012,06,16,10,20,0]);
t1ccmc=datenum([2014,01,09,00,38,0]);
tCcmcErr= 9./24;
ccmcKp=8.0;
haCCMC=plot([t1ccmc-tCcmcErr,t1ccmc+tCcmcErr],[ccmcKp,ccmcKp],...
        'Color',[0.4,0.4,1],'LineStyle','-','Linewidth',5,'Parent',ax2_2);
text(t1ccmc+tCcmcErr+0.1,8.2,'NASA CCMC Prediction', 'color',DarkBlue , ...
     'horizontalalignment','left','Rotation',0,'FontSize',13)

% the NOAA SWPC prediction on 2014 event
% t1swpc=datenum([2012,06,16,21,00,0]);
t1swpc=datenum([2014,01,09,12,00,0]);
tswpcErr= 12./24;
swpcKp=7.0;
haCCMC=plot([t1swpc-tswpcErr,t1swpc+tswpcErr],[swpcKp,swpcKp],...
        'Color',[0.4,0.4,1],'LineStyle','-','Linewidth',5,'Parent',ax2_2);
text(t1swpc+tswpcErr-0.4,6.4,'NOAA SWPC Prediction', 'color',DarkBlue , ...
     'horizontalalignment','left','Rotation',0,'FontSize',13)

 
% the NEW MODEL prediction on 2014 event
[NewMKp,tempI]=max(Kpvec(:,2));
t1swpc=Kpvec(tempI,1);
tswpcErr= 9./24;
haCCMC=plot([t1swpc-tswpcErr,t1swpc+tswpcErr],[NewMKp,NewMKp],...
        'Color',[1,0.4,0.4],'LineStyle','-','Linewidth',5,'Parent',ax2_2);
text(t1swpc+tswpcErr+0.1,NewMKp,'New Model Prediction', 'color',DarkRed , ...
     'horizontalalignment','left','Rotation',0,'FontSize',13)

%% 
h2_3=stairs(Kpvec(:,1),Kpvec(:,2),'Color',DarkRed,'LineStyle','-','Linewidth',2.5,'Parent',ax2_2);hold on
 
temp=1;

end




