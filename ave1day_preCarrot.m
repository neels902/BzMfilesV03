function [O_aveData,O_str]=ave1day_preCarrot(I_insit_path, I_Time)

% TOPTREEBzTool > Bestimate > ave1day_preCarrot

% USES ReadCdaw, NanAvErr

%%
x=I_insit_path; % is a string - a path to the insitu .txt file
st=I_Time(1);    % bkgd 4 days earlier needed
en=I_Time(2);    % bkgd + 6 hrs
arT=I_Time(3);

%%
%Data1= ReadCdaw(x);

if st <= datenum([2005,12,31,23,59,0])
    UrlStart= 'http://spdf.gsfc.nasa.gov/pub/data/ace/merged/4_min_merged_mag_plasma/ace_m';
    [Data1A] = ReadOmniAce(UrlStart, arT);
else
    % use JSON iSWA
    UrlStart='http://iswa.ccmc.gsfc.nasa.gov/IswaSystemWebApp/DatabaseDataStreamServlet?format=JSON&resource=ACE,ACE,ACE&quantity=B_x,B_y,B_z&';
    [Data1A] = ReadJsonVec(x, arT);
end
% Data1= ReadJsonVec(x,arT);  


IncT=datenum([0,0,0,0,12,0]);
Data1=AveNanB(Data1A,IncT);

%% FOR the BACKGROUND STATIC VALUE
datenum1=Data1A(:,1);
points1= datenum1>st & datenum1<en;
Bfield=Data1A(points1,:);
LL=size(Bfield,2);
BBave=zeros(1,LL);
for ii=1:1:LL
    [AVE,standard_error]=NanAvErr(Bfield,ii,0);
    BBave(1,ii)=AVE;
end


%%
O_aveData= BBave;  % FOR THE BACKGROUND
O_str.temp=Data1;  % FOR THE COMPLETE DATA 



end