function rotMatrix= rev_MVA(I_tilt,I_radial,I_phi)

% This function converts rotation angles into rotation matrix
%
% rotAngles : [rx ry rz] in degrees
%
% rotMatrix : RRmat* data(3xN) format
% euler angles Z1-Y2-Z3
% see wiki for matrix definition



a1= I_tilt*d2r;
a2= I_radial*d2r;
a3  = I_phi*d2r;

c1=cos(a1);c2=cos(a2);c3=cos(a3);
s1=sin(a1);s2=sin(a2);s3=sin(a3);

rotMatrix = [(c1*c2*c3)-(s1*s3) , (-c3*s1)-(c1*c2*s3) , (c1*s2); ...
             (c1*s3)+(c2*c3*s1) , (c1*c3)-(c2*s1*s3)  , (s1*s2); ...
                 (-c3*s2)       ,     (s2*s3)         ,  (c2)  ];

%rotMatrix = rotMatrix'; 




end