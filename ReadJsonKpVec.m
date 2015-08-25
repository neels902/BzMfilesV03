function [ OUTPUT ] = ReadJsonKpVec(fileToRead1, IN_time)

% Used inside TOPTREEBzTool > Bestimate > ave1day_preCarrot

%'http://iswa.ccmc.gsfc.nasa.gov/IswaSystemWebApp/DatabaseDataStreamServlet?format=JSON&resource=ACE,ACE,ACE&quantity=B_x,B_y,B_z&begin-time=2013-01-01%2023:59:59&end-time=2013-01-02%2023:59:59'
% &begin-time=2013-01-01%2023:59:59&end-time=2013-01-02%2023:59:59'

UrlStart= fileToRead1;
arrTime=IN_time(1);



%% Create complete JSON url string
%%%NEW%%% -->
KpBegTime=arrTime- datenum([0,0,10,00,00,00]);  % reads data prior to arrival Time
KpEndTime=arrTime+ datenum([0,0,5,00,00,00]);  % % reads data after arrival Time + 5 days for use with historical data
%%%%%%%%% <--
%   Kp should always be a fixed length vector of 15 days. (or at least data
%   from 2 days earlier and 3 days later are needed). The extra data at the 
%   end for future dates (i.e. 0's) are needed for correct plotting in
%   KpIndexplot4
%%%%%%%%% <--
ArrLength=int32(round((KpEndTime-KpBegTime)./datenum([0,0,0,3,00,00]))); % divide by Kp 3hr duration 

BTst='begin-time=';
ETst='&end-time=';
tempst='%20';

% 2013-01-02%2023:59:59
BTa=datestr(KpBegTime,'YYYY-mm-dd');
BTb=datestr(KpBegTime,'HH:MM:SS');
BT=[BTa,tempst,BTb];

ETa=datestr(KpEndTime,'YYYY-mm-dd');
ETb=datestr(KpEndTime,'HH:MM:SS');
ET=[ETa,tempst,ETb];

%% import DATA from ONLINE API
WebUrl= [UrlStart,BTst,BT,ETst,ET];
data = webread(WebUrl);

%%
a = zeros(ArrLength,2);
ttim= datenum([0,0,0,3,00,00]);
TimNum=KpBegTime:ttim:(KpEndTime- 0.01); 
a(:,1)=TimNum;  %   a good back to debug is date errors and makes sure complete array exists

for ii=1:1:length(data),
    javaSerialDate=data(ii).timestamp;
%     TimNum=AceBegTime + (ii-1)*ttim;    
    a(ii,1)=datenum([1970 1 1 0 0 javaSerialDate / 1000])- datenum([0,0,0,1,30,0]); % subtract 1.5 hrs to align correctly with beginining of Kp window.
    a(ii,2)=data(ii).KP;
end

a(a(:,2)<(-900),2)= NaN;

OUTPUT=a;
end

