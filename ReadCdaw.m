function OUTPUT= ReadCdaw(fileToRead1)
% for this routine to work the txt dump from the online source must have
% all header lines manually removed (and check the last few lines as well!)
% and the data download options must be as follows:
% |B|,Bx,By,Bz,Vx,Vy,Vz,Rho,T,P,beta,BSx,BSy,BSz,AE 
% output=ReadCdaw('cdaw.txt');

% output=ReadCdaw('cdaw2010.txt');

% Import the file

fid = fopen(fileToRead1);
mydata = textscan(fid, '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f  %*[^\n]');


mydate=mydata{1,1};
%DD/MM/YYYY  ;  hh/mm/ss.sss
mytime=mydata{1,2};

% remove microsec from datestring
NN=length(mytime);
celltime=cell(NN,1);
CorrectTime=cell(NN,1);
for ii=1:1:NN
    celltime{ii,1}=mytime{ii,1}(1:end-4);
    CorrectTime{ii,1}=[mydate{ii,1},' ',celltime{ii,1}];
end

% final datenum format
DD=datenum(CorrectTime(:,1),'dd-mm-yyyy HH:MM:SS');



% text data:
% |B|,Bx,By,Bz,Vx,Vy,Vz,Rho,T,P,beta,BSx,BSy,BSz,AE 
for ii=1:1:length(mydata)-2
    tempdata(:,1)=mydata{1,ii+2};
    % clean data
    if ii== 9, 
        j=find(tempdata> 1000000.0);
        tempdata(j)=nan;
    elseif  ii== 10, 
        j=find(tempdata> 90.0);
        tempdata(j)=nan;
    elseif ii== 15, 
        j=find(tempdata> 10000.0);
        tempdata(j)=nan;
    else
        j=find(tempdata> 990.0);
        tempdata(j)=nan;
    end
    P(:,ii)=tempdata;
end

%DATA=[DD,P];



%L=-1*ones(length(bt),1);

%1.datenum, 2.B_X,3.B_Y,4. B_Z,    5.V_X,6.V_Y,7.V_Z,   8.N_P,  9.T,
%10.Beta  11. BSx-R(AU), 12. BSy-HLat, 13. BSz-HLong, 14. P-N_alpha/N_P, 15. AE-|B|,
OUTPUT=[DD,P(:,2:4)   ,P(:,5:7),   P(:,8),   P(:,9),...
        P(:,11),   P(:,12:14),   P(:,10),   P(:,15)   ]; % no Bmag used














return
