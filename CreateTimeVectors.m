function OUT_P=CreateTimeVectors(I_stTime,I_enTime,I_TotNum)

%% INPUTS
stTime=I_stTime;
enTime=I_enTime;
TotNum=I_TotNum;

%% 
Timelength=enTime-stTime;
incrementTime=Timelength./ (TotNum-1);

Timeserie=stTime:incrementTime:enTime;

%%
OUT_P=Timeserie';
end