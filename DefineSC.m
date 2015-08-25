function OutHand = DefineSC(InHandles)

% handles.Hinput.AT=datenum([2012,03,12,012,20,00]);
% handles.Hinput.tempCyc = 1;
% handles.Hinput.I_Mgram ='North';

%Program correctly does SC19, but SC18 and below is misrepresented as SC19.
% simply adding Stsc19 ... will not correc this mistake for future. ie must
% change find function.

%% INPUTS
OutHand=InHandles;

%% define real SC of CME time
Stsc20=datenum([1964,10,15,0,0,0]);
Stsc21=datenum([1976,5,15,0,0,0]);
Stsc22=datenum([1986,3,15,0,0,0]);
Stsc23=datenum([1996,6,15,0,0,0]);
Stsc24=datenum([2008,1,15,0,0,0]);
StscFut=datenum([2025,1,15,0,0,0]);

tempa=[Stsc20,Stsc21,Stsc22,Stsc23,Stsc24,StscFut];
% tempb=[0,1,2,3,4,5];

a=find((tempa-InHandles.Hinput.AT)>0);
scOddEven=a(1); % this is the SC is correct odd/even number


%% If SC is even
if rem(a(1),2)==0
    if strcmp(InHandles.Hinput.I_Mgram,'North') && InHandles.Hinput.tempCyc == 1
        scOddEven= scOddEven +1 ;
    elseif strcmp(InHandles.Hinput.I_Mgram,'South') && InHandles.Hinput.tempCyc == -1
        scOddEven= scOddEven +1 ;
    else
        scOddEven=scOddEven;
    end
%% If SC is odd
else
    if strcmp(InHandles.Hinput.I_Mgram,'North') && InHandles.Hinput.tempCyc == -1
        scOddEven= scOddEven +1 ;
    elseif strcmp(InHandles.Hinput.I_Mgram,'South') && InHandles.Hinput.tempCyc == 1
        scOddEven= scOddEven +1 ;
    else
        scOddEven=scOddEven;
    end
end

%% find BSS equivalent SC value
if rem(scOddEven,2)==0
    OutHand.Hinput.cycle = 24;
else
    OutHand.Hinput.cycle = 23;
end

end