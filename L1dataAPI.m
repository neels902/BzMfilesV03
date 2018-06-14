function OutHand = L1dataAPI (InHandles)
% Used inside BzTool L554
% This routine simply converts core string of API handle from DISCVR to
% ACE.
% 

%% INPUTS
OutHand=InHandles;

Stdiscvr = datenum([2016,08,03,00,00,00]); % iSWA API starts at 2016-07-24
stCME =  InHandles.Hinput.AT;

%% find BSS equivalent SC value
if (stCME-Stdiscvr) <= 0
    OutHand.Hinput.insitu = OutHand.Hinput.insituACE;
else
    temp = 0; % OutHand.Hinput.insitu = Hinput.insitu;
end

return
