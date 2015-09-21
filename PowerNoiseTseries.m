function x = PowerNoiseTseries(alpha, N, INdelB)
% Generate samplesxx of power law noise. The power spectrum
% of the signal scales as f^(-alpha).
%
% Useage:
%  x = PowerNoiseTseries(alpha, N)
%  x = PowerNoiseTseries(alpha, N, delB)
%
% Inputs:
%   alpha   - power law scaling exponent  [CODED as  exp^(-alpha/2) ]
%     N     - number of samples to generate
%  INdelB   - normalised ratio of B field fluctions
%
% Output:
%  x  - N x 1 vector of power law noise to be multiplied with |B| t-series
%
%
% the power spectrum is deterministic, and the phases are uniformly 
% distributed in the range -pi to +pi. The power law extends all the way 
% down to 0Hz (DC) component. 
%
% (cc) Neel Savani, 2015. 
% This software CANNOT be [is] licensed at this stage under 
% the Attribution-Share Alike 2.5 Generic Creative Commons license:
% http://creativecommons.org/licenses/by-sa/2.5/

if nargin==2
    delB_OverB=0.1;
elseif nargin==3
    delB_OverB=INdelB;  % consider (delB/B) ~0.3;
end

% future version may consider not normailising the spectrum or non-uniform
% phase distribution
opt_RandPow = false;
opt_Norm = false;



N2 = floor(N/2)-1;
f = (2:(N2+1))';
Amp2 = 1./(f.^(-alpha/2));

% exponential phase
p2 = (rand(N2,1)-0.5)*2*pi;
d2 = Amp2.*exp(1i*p2);

% create freq distribution that includes the conjugate pair
d = [1; d2; 1/((N2+2)^alpha); flipud(conj(d2))];

% inverse fft to create time series
x = real(ifft(d));

% normalise the amplitude of noise to desired ratio of |B|
x =  delB_OverB *  ( ((x - min(x))/(max(x) - min(x)) - 0.5) * 2 ) ;

return






