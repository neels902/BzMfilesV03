
% testing the theory that:
% cos(theta)= cos(alpha) * cos(beta)..
% where theta is the total angle between two vectors when 
% long and lat angle are known separately. 

al=(0:1:90)';
be=0:1:90;
theta1d=acos(cos(al'*d2r).*cos(be*d2r))*r2d;

al=(0:1:79)';
al2d=repmat(al,[1,length(be)]);

for ii=1:1:length(al);
    theta2d(ii,:)=acos(cos(al2d(ii,:)*d2r).*cos(be*d2r))*r2d;
end
surfc(be,al,theta2d)

