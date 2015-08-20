i=1;  % 1->2
j=4;  % 1->4->7->10

width=[3.0,14.5];
height=[2.0,3.5,5.0,8.0,9.5,11.0,14.0,15.5,17.0,20.0,21.5,23.0];

boxsize1=[width(i),height(j),9,1.5];
boxsize2=[width(i),height(j+1),9,1.5];
boxsize3=[width(i),height(j+2),9,1.5];

ha=get(gcf,'Children');
isaxis=zeros(1,length(ha));
for i=1:length(ha)
if strcmp(get(ha(i),'Type'),'axes')&...
    (isempty(strmatch('colorbar',get(ha(i),'DeleteFcn')))&~(strcmp(get(ha(i),'Tag'),'Colorbar'))),
  isaxis(i)=1;
end
end
ha=ha(find(isaxis==1));
handle=ha;
%handle=flipud(handle);

a=handle(1);
b=handle(2);
c=handle(3);
set(b,'YAxisLocation','left')

set(handle,'Units','centimeters')
set(a,'Position',boxsize1)
set(b,'Position',boxsize2)
set(c,'Position',boxsize3)




