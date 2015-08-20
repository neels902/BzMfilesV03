function Varargout= prop2earth( speed,in_dist)
%PROP2EARTH Summary of this function goes here
%   Detailed explanation goes here
%
%
%
% INPUTS:     speed= bulk flow speed in km/s e.g. 800
%             in_dist= starting distance in Rs e.g. ~15
%
% OUTPUTS:    Either no function output = print output to screen ONLY
%             OR
%             Varargout= decimalised # of days for the propagation to Earth
%
% written by NP Savani 8th July 2014
%
%



EarthD=1.0 * au2rs;

distkm= (EarthD-in_dist)* rs2km;

tsec=(distkm)/speed; % time in sec

t_day=tsec./(3600*24);
Dy=floor(t_day);

trem=t_day-Dy;
Hr=floor(trem*24);

trem=trem*24-floor(trem*24);
Mi=floor(trem*24);

trem=trem*24-floor(trem*24);
Se=floor(trem*60);

if nargout == 0
    str1(1) = {sprintf(' %1$3.0g Day  %2$2.0f Hours %3$2.0f Minutes',Dy,Hr,Mi)};
    display(str1{1})
elseif nargout == 1
    Varargout=t_day;
end

