function [O_aveData,O_str]=ave1day_preCarrot(I_insit_path, I_Time)

% USES ReadCdaw, NanAvErr

%%
x=I_insit_path; % is a string - a path to the insitu .txt file
st=I_Time(1);
en=I_Time(2);
arT=I_Time(3);

%%
%Data1= ReadCdaw(x);
Data1= ReadJsonVec(x,arT);  

datenum1=Data1(:,1);
points1= datenum1>st & datenum1<en;

Bfield=Data1(points1,:);

LL=size(Bfield,2);
BBave=zeros(1,LL);
for ii=1:1:LL
    [AVE,standard_error]=NanAvErr(Bfield,ii,0);
    BBave(1,ii)=AVE;
end


%%
O_aveData= BBave;
O_str.temp=Data1;



end