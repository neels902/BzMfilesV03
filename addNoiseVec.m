function [Bfield, StrucA]= addNoiseVec(I_data)

% use certain fourier frequencies defined by MJ Owens & Meterological methods
% to be done in future



Time=I_data(:,1);
BxmodN=I_data(:,2);
BymodN=I_data(:,3);
BzmodN=I_data(:,4);

alpha=5/3;
N = length(Time);     %N = 48* 60;
delB_B=0.3;
Bdefault=9;   % make B noise field larger when the B-component is small

%% do inverse fft to create time series. do a time period for all components
NormNoise = PowerNoiseTseries(alpha, 3* N, delB_B);

% create correct amplitude for the noise
startT=datenum([0,0,0,00,00,00]);
delT=datenum([0,0,0,0,1,0]);
TtNoi=startT:delT:startT+(delT-1)*N;


% add normailised noise for actual B-field
Bx=BxmodN + (BxmodN.*NormNoise(1:N));
Bx(abs(BxmodN)<5)=BxmodN(abs(BxmodN)<5) + (Bdefault.*NormNoise(abs(BxmodN)<5));



By=BymodN + (BymodN.*NormNoise(N+1:2*N));
By(abs(BymodN)<5)=BymodN(abs(BymodN)<5) + (Bdefault.*NormNoise([logical(zeros(N,1));abs(BymodN)<5]));

Bz=BzmodN + (BzmodN.*NormNoise((2*N+1):3*N));
Bz(abs(BzmodN)<5)=BzmodN(abs(BzmodN)<5) + (Bdefault.*NormNoise([logical(zeros(N,1));abs(BzmodN)<5])); 

BB=sqrt((Bx.*Bx)+(By.*By)+(Bz.*Bz));

%% create output
Bfield=[Time,Bx,By,Bz,BB];

% Bfield=I_data;
StrucA=1;



end


