function [Bfield, StrucA]= FRmodel(I_Y0,I_BBmag, I_veclen,I_alpha)
% used inside FRProfile.m file ~L78

Y0=I_Y0;
B0=I_BBmag;
L=I_veclen;
alpha0=I_alpha;   % 2.4


R0=L/2;
alpha= alpha0/R0; % defining Bz=0 at edge of rope.

%FLUX MODEL
for i=1:1:L
    
    %as s/c passes through rope, x changes incremently; y remains fixed.
    x=(i-R0);
    y=(Y0*R0);
    r= sqrt(x^2 + y^2);
     if r==0
         r=0.0000001;
     end
     
     
    mBmin(i,1)=B0*  besselj(1,(alpha* r)) *y/r;
    mBmax(i,1)=B0*  besselj(1,(alpha* r)) *x/r;
    mBint(i,1)=B0*  besselj(0,(alpha* r));
    mBmag(i,1)= sqrt(mBmin(i)^2 + mBint(i)^2 + mBmax(i)^2);

    
    %time(i,1)= startT + ( (i-1) * stepT );
    
    
end
Bfield=[mBmin,mBint,mBmax];


end

