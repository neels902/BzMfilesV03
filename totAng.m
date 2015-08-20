
function Angle = totAng(long, lat)

% calculates the total angle between 2 vectors when only the component
% angles are known. i.e. the long and lat angles between the vectors
%
% INPUT and OUTPUT angles in degress only!!!!
% works for single value array only



temp= cos(long*d2r) * cos(lat*d2r);

Angle= acos(temp)* r2d;

return


