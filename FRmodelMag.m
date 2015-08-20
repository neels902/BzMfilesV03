function [InvFrac]= FRmodelMag(I_Y0)

%realY0=I_Y0;

Y0=abs(I_Y0);
B0=1; % I_BBmag;
L=1000; % I_veclen;
alpha0=2.4; % I_alpha;   % 2.4


R0=L/2;
alpha= alpha0/R0; % defining Bz=0 at edge of rope.

inc= double(1./L);
alphaARRAY= 0:inc:1;  % effectively new Y0
alpharr= alpha0 .* alphaARRAY;
    mBp = B0*  besselj(1,(alpharr));
    mBz = B0*  besselj(0,(alpharr));
    mBmag2= sqrt(mBp.^2 + mBz.^2);

    
[C,I]=min(abs(alphaARRAY-Y0));

InvFrac = 1 ./ mBmag2(I);
    
    
end
    
    
    
% %FLUX MODEL
% for i=1:1:L
%     
%     %as s/c passes through rope, x changes incremently; y remains fixed.
%     x=(i-R0);
%     y=(Y0*R0);
%     r= sqrt(x^2 + y^2);
%      if r==0
%          r=0.0000001;
%      end
%      
%      
%     mBmin(i,1)=B0*  besselj(1,(alpha* r)) *y/r;
%     mBmax(i,1)=B0*  besselj(1,(alpha* r)) *x/r;
%     mBint(i,1)=B0*  besselj(0,(alpha* r));
%     mBmag(i,1)= sqrt(mBmin(i)^2 + mBint(i)^2 + mBmax(i)^2);
% 
%     
%     %time(i,1)= startT + ( (i-1) * stepT );
%     
%     
% end
% Bfield=[mBmin,mBint,mBmax];
% 
% 
% end

