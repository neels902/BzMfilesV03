 % Varargout= proptearth( speed,in_dist)  % is useful
 
 % two .txt files are usually required for each event. Omni data set, and
 % Enlil solar wind outputs (to estimate max |V| and |B|)
 
 % Otherwise manual adjustment is reuired in Sec 4 of TOPTREEBz to use
 % default enlil values

sigmaA= 0 ;  % 0 -6.9 +20.7 (3*6.9)   ;  or 5.9; uncertainty
I_earthpos=[0,0];
Hinput=inputString.Hinput;

KpStgStart='http://iswa.ccmc.gsfc.nasa.gov/IswaSystemWebApp/DatabaseDataStreamServlet?format=json&resource=NOAA-KP&quantity=KP&'; % begin-time=2015-08-18%2023:59:59&end-time=2015-08-26%2023:59:59';
so=Hinput.so; % [5.03,13.13]; 
I_tilt=Hinput.I_tilt; % -38.01;
I_haf=Hinput.I_haf; % 45.28;
I_Mgram=Hinput.I_Mgram; % 'North';
cycle=Hinput.cycle; % 24;
ftsStr=Hinput.ftsStr;
%    info=fitsinfo (ftsStr); % '../AIAfts/event03_20120310_023749_AIA_171_.fts'
%    Im2 =fitsread (ftsStr); % '../AIAfts/event03_20120310_023749_AIA_171_.fts'
insit_path=Hinput.insitu; % '../Insitu/Omni/E03_Omni.txt';    % Bestimate
%%%NEW%%% -->
enlilBB=Hinput.enlilBB;
enlilVV=Hinput.enlilVV;
%%%%%%%%% <--
arrTime=Hinput.AT;
    StrucFRax.stTime=arrTime; % datenum([2012,03,12,012,20,00]);  % st n end of FR time series e03
    StrucFRax.enTime=StrucFRax.stTime + datenum([0,0,0,18,00,00]);  % CME duration [2012,03,13,04,20,00]
%%%NEW%%% -->
    bkgdShift=datenum([0,0,4,00,00,00]); % [0,0,0,7,00,00] 4 days ahead
%%%%%%%%% <--
    T1= StrucFRax.stTime - bkgdShift;% datenum([2012,03,12,01,00,00]); % background SW values
    T2=T1 + datenum([0,0,0,6,00,00]); % 6 hour interval of bkgd    % datenum([2012,03,12,04,00,00]); 
        
ccmcKpEst=Hinput.ccmc; % [5.0, 8.0];
swpcKpEst=Hinput.swpc; % [5.5, 6.5];







ccmcArr= arrTime; % datenum([2012,03,12,18,00,0]);  
swpcArr=arrTime;  % datenum([2012,03,12,10,30,0]);   % https://kauai.ccmc.gsfc.nasa.gov/DONKI/view/GST/412/1
% - Enlil Velocity        NewMKpEst=[4.95,8.38];  %  DEFAULT  --  NewMKpmax=8.6; NewMKpmin=6.8; comes from varying sd |B| estimates
NewMKpEst=[5.084,8.4802];




%{

if inputString=='ev03'
  so=[5.03,13.13]; 
  I_tilt=-38.01;
  I_haf=45.28;
  I_Mgram='North';
  cycle=24;
  StrucFRax.stTime=datenum([2012,03,12,012,20,00]);  % st n end of FR time series e03
  StrucFRax.enTime=datenum([2012,03,13,04,20,00]);
    info=fitsinfo ('../AIAfts/event03_20120310_023749_AIA_171_.fts');
    Im2 =fitsread ('../AIAfts/event03_20120310_023749_AIA_171_.fts');
      insit_path='../Insitu/Omni/E03_Omni.txt';    % Bestimate
      T1=datenum([2012,03,12,01,00,00]);
      T2=datenum([2012,03,12,04,00,00]);
        ccmcKpEst=[5.0, 8.0];
        swpcKpEst=[5.5, 6.5];                               
        ccmcArr= datenum([2012,03,12,18,00,0]);  
        swpcArr=datenum([2012,03,12,10,30,0]);   % https://kauai.ccmc.gsfc.nasa.gov/DONKI/view/GST/412/1
% - Enlil Velocity        NewMKpEst=[4.95,8.38];  %  DEFAULT  --  NewMKpmax=8.6; NewMKpmin=6.8; comes from varying sd |B| estimates
        NewMKpEst=[5.084,8.4802];


elseif inputString=='ev04'
  so=[-26.27,1.98];
  I_tilt=-3.35;
  I_haf=29.07;
  I_Mgram='South';
  cycle=24;
  StrucFRax.stTime=datenum([2012,06,16,23,00,00]);  % st n end of FR time series e04
  StrucFRax.enTime=datenum([2012,06,17,11,30,00]);
    info=fitsinfo ('fig/AIAfts/event04_20120614_115501_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event04_20120614_115501_AIA_171_.fts');
      insit_path='../Insitu/Omni/E04_Omni.txt';    
      T1=datenum([2012,06,15,18,00,00]);
      T2=datenum([2012,06,16,06,00,00]);
        ccmcKpEst=[5.0, 9.0];
        swpcKpEst=[4.0, 5.0];                               
        ccmcArr= datenum([2012,06,16,10,15,0]);  
        swpcArr=datenum([2012,06,16,19,00,0]);
% - Enlil Velocity        NewMKpEst=[4.15,8.54];
        NewMKpEst=[2.703,6.7305];

elseif inputString=='ev05'
  so=[-5.59,1.61]; 
  I_tilt=55.9;
  I_haf=18.73;
  I_Mgram='South';
  cycle=24;
  StrucFRax.stTime=datenum([2012,07,15,07,30,00]);  % st n end of FR time series e05
  StrucFRax.enTime=datenum([2012,07,16,10,40,00]);
    info=fitsinfo ('fig/AIAfts/event05_20120712_163824_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event05_20120712_163824_AIA_171_.fts');
    insit_path='../Insitu/Omni/E05_Omni.txt';    
      T1=datenum([2012,07,13,18,00,00]);  
      T2=datenum([2012,07,14,00,00,00]);
        ccmcKpEst=[8.0, 9.0];
        swpcKpEst=[0.0, 0.0];                               %%n
        ccmcArr= datenum([2012,07,14,09,15,0]);  
        swpcArr=datenum([2014,01,01,0,0,0]);                %%n
% - Enlil Velocity        NewMKpEst=[7.65,9.3];
        NewMKpEst=[6.0284,8.6129];

elseif inputString=='ev08'                     %  e08
  so=[-32.98,-11.6]; 
  I_tilt=3.91;
  I_haf=25.16;
  I_Mgram='South';
  cycle=24;
  StrucFRax.stTime=datenum([2012,06,17,00,00,00]); % 1364 +744.2 % 1 Day  11 Hours 12 Minutes
  StrucFRax.enTime=datenum([2012,06,17,14,00,00]);
    info=fitsinfo ('fig/AIAfts/event08_20120613_155801_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event08_20120613_155801_AIA_171_.fts');
    insit_path='../Insitu/Omni/E08_Omni.txt';    
      T1=datenum([2012,06,16,00,00,00]);  
      T2=datenum([2012,06,16,04,00,00]);
        ccmcKpEst=[6.0, 9.0];
        swpcKpEst=[4.0, 5.0];                              
        ccmcArr= datenum([2012,06,16,12,40,0]);  % from max V in dat file of combi from email  
        swpcArr=datenum([2012,06,16,19,00,0]);          
% - Enlil Velocity        NewMKpEst=[5.85,8.84];
        NewMKpEst=[3,9];

        
elseif inputString=='ev09'
  so=[16.77,24.9]; 
  I_tilt=-69.3;
  I_haf=19.29;
  I_Mgram='North';
  cycle=23; % large arcade connecting AR 1577 and 1575
  StrucFRax.stTime=datenum([2012,09,30,23,55,00]);  % 1160 +679  %1 Day  16 Hours 16 Minutes
  StrucFRax.enTime=datenum([2012,10,01,23,55,00]);          %%n
    info=fitsinfo ('fig/AIAfts/event09_20120928_020336_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event09_20120928_020336_AIA_171_.fts');
      insit_path='../Insitu/Omni/E09_Omni.txt';  
      T1=datenum([2012,09,29,23,00,00]);  
      T2=datenum([2012,10,30,01,00,00]);
        ccmcKpEst=[5.0, 9.0];
        swpcKpEst=[7, 7];                                   %%nowcast only
        ccmcArr= datenum([2012,09,29,22,47,0]);  
        swpcArr=datenum([2012,10,01,03,0,0]);                %%nowcast only
% - Enlil Velocity        NewMKpEst=[4.10,7.3];
        NewMKpEst=[2.423,4.777];

        
elseif inputString=='ev10'
  so=[-30.75,30.46];         % [lat, lon]
  I_tilt=40.25;
  I_haf=41.93;
  I_Mgram='South';
  cycle=23;
  StrucFRax.stTime=datenum([2014,01,08,22,00,00]);  % st n end of FR time series e10
  StrucFRax.enTime=datenum([2014,01,09,19,45,00]);
  %StrucFRax.stTime=datenum([2014,01,10,02,00,00]);  % st n end of FR time series e10 late version
  %StrucFRax.enTime=datenum([2014,01,11,01,00,00]);
    info=fitsinfo ('fig/AIAfts/event10_20140107_201400_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event10_20140107_201400_AIA_171_.fts');
      insit_path='../Insitu/Omni/E10_Omni.txt';  % Bestimate
      T1=datenum([2014,01,07,00,00,00]);  % time range used only for estimating the background static in situ params.
      T2=datenum([2014,01,07,12,00,00]);
        ccmcKpEst=[6.0, 8.0];   % KpIndexplot4
        swpcKpEst=[5.9, 7.1];
        ccmcArr= datenum([2014,01,09,00,38,0]);  % ccmc arrival prediction
        swpcArr=datenum([2014,01,09,12,00,0]);   % SWPC arrival prediction
        NewMKpEst=[3.6457,6.0558];   % NewMKpEst=[6.88,8.957]; - Enlil Velocity
        
        
elseif inputString=='ev11'
  so=[-19,06.0]; 
  I_tilt=12;
  I_haf=25.0;
  I_Mgram='South';
  cycle=24; % large arcade AR 11126
  StrucFRax.stTime=datenum([2011,03,29,23,40,00]);  % from Savani13a
  StrucFRax.enTime=datenum([2011,03,31,10,00,00]);         
    info=fitsinfo ('fig/AIAfts/event11_20110325_004425_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event11_20110325_004425_AIA_171_.fts');
      insit_path='../Insitu/Omni/E11_Omni.txt';  
      T1=datenum([2011,03,29,04,00,00]);                  %%n
      T2=datenum([2011,03,29,09,00,00]);                  %%n
        ccmcKpEst=[5.0, 9.0];                             %%n
        swpcKpEst=[7, 7];                                 %%n
        ccmcArr= datenum([2012,09,29,22,47,0]);           %%n
        swpcArr=datenum([2012,10,01,03,0,0]);             %%n
        Vearth=375;                                 % from in situ data
        BBmag= 15 + sigmaA;                          % from in situ data
% - Enlil Velocity        NewMKpEst=[3.612,6.523];
        NewMKpEst=[3.4155,6.2475];
        
        
elseif inputString=='ev12'
  so=[-3.0,-25.0]; 
  I_tilt=-15.0;
  I_haf=32.4;
  I_Mgram='South';
  cycle=24; % large arcade AR 110259
  StrucFRax.stTime=datenum([2010,04,05,13,00,00]);  % from ???
  StrucFRax.enTime=datenum([2010,04,06,13,30,00]);         
    info=fitsinfo ('fig/AIAfts/event12_20100527_061100_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event12_20100527_061100_AIA_171_.fts');
      insit_path='../Insitu/Omni/E12_Omni.txt';  
      T1=datenum([2010,04,05,01,00,00]);                 
      T2=datenum([2010,04,05,04,00,00]);                
        ccmcKpEst=[4.0, 7.0];                             %%n
        swpcKpEst=[7, 7];                                 %%n
        ccmcArr= datenum([2012,04,05,00,00,0]);           %%n
        swpcArr=datenum([2012,04,05,00,00,0]);            %%n
        Vearth=750;                                 % from in situ data
        BBmag= 15 + sigmaA;                          % from in situ data
% - Enlil Velocity        NewMKpEst=[6.148,8.845];
        NewMKpEst=[5.11,8.1475];


elseif inputString=='ev13'
  so=[15,10];         % [lat, lon]
  I_tilt=5;
  I_haf=45;
  I_Mgram='North';
  cycle=23;
  StrucFRax.stTime=datenum([2014,09,12,11,45,00]);  % st n end of FR time series e10
  StrucFRax.enTime=datenum([2014,09,13,11,45,00]);
  %StrucFRax.stTime=datenum([2014,01,10,02,00,00]);  % st n end of FR time series e10 late version
  %StrucFRax.enTime=datenum([2014,01,11,01,00,00]);
    info=fitsinfo ('fig/AIAfts/event13_20140910_175112_AIA_171_.fts');
    Im2 =fitsread ('fig/AIAfts/event13_20140910_175112_AIA_171_.fts');
      insit_path='../Insitu/Omni/E13_Omni.txt';  % Bestimate
      T1=datenum([2014,01,07,00,00,00]);  % time range used only for estimating the background static in situ params.
      T2=datenum([2014,01,07,12,00,00]);
        ccmcKpEst=[6.0, 8.0];   % KpIndexplot4
        swpcKpEst=[5.9, 7.1];
        ccmcArr= datenum([2013,09,12,11,45,0]);  % ccmc arrival prediction
        swpcArr=datenum([2013,09,12,12,00,0]);   % SWPC arrival prediction
        Vearth=750;                                % from in situ data
        BBmag= 15 + sigmaA;
% - Enlil Velocity        NewMKpEst=[6.272,8.908];
        NewMKpEst=[5.1653,8.1928];
     
        
else 
    error('The input string is not a valid event selection: ', inputString)
end


%}
    
    
    