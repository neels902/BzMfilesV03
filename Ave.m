function output= Ave (input, avetime)

%input avetime in 6colm datevec format
%
%averages data in all colm. must use 6colm matlab datevec format for time
%output [TIME DATA]
%neel savani updated 15/06/08

%%
% avetime is in datevec format

time= input(:,1);
data= input(:,2:end);
[r col]= size(data);

ave=datenum(avetime)- datenum([0 0 0 0 0 0]);


%%
t= datenum(time(2,:)) - datenum(time(1,:));

n= ave/t;
n=floor(n);
n2= floor( (n/2) );



s=ceil(r/n);
TIME=ones((s-1),1);
OUTPUTa= ones(s-1,col+1);
for i=1:1:s-1
    
    DATA(i,1:col)= (sum  (data( ( ((i-1)*n)+1):(i*n)  , :))   )/  n    ;

    TIME(i,1)= time(  ((i*n)-n2) ,:);
    for jj=1:1:col+1
        [avera1,std_err]=NanAvErr(input( ( ((i-1)*n)+1):(i*n),:),jj,0);
        OUTPUTa(i,jj)=avera1;
    end
end

%output= [TIME DATA];
output= OUTPUTa;


return
    
    
    

    
    