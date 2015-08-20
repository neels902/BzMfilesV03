function outPP_h =KpIndexplot_old

%looks for KpIndexplot2

% http://www.mathworks.com/matlabcentral/answers/58971-bar-plot-with-bars-i
% n-different-colors

%http://stackoverflow.com/questions/13266352/matlab-bar-graph-fill-bars-with-different-colours-depending-on-sign-and-magnit


KPmatrix= [1,1,2,1,1,1,1,0;...
           0,1,1,0,1,1,2,2;...
           1,2,0,1,1,3,3,3;...
           3,3,1,1,1,1,1,2;...
           3,3,2,2,1,1,3,2;...
           2,2,1,1,1,2,1,1;...
           0,0,0,0,1,1,3,2];

NN=size(KPmatrix,1);       
for ii=1:1:NN
    data((8*ii-7):(8*ii),1)=KPmatrix(ii,:);
end
       


H = data(:, 1);
N = numel(H);
for i=1:N
  h = bar(i, H(i));
  if i == 1, hold on, end
  if data(i, 1) < 4
    col = 'g';
  elseif data(i, 1) == 4
    col = 'y';
  else
    col = 'r';
  end
  set(h, 'FaceColor', col) 
end
set(gca, 'XTickLabel', '')  
uniNames = {'eno','pck','zwf','...'};
xlabetxt = uniNames(data(:,1));
ylim([0 9]);
ypos = -max(ylim)/50;


text(1:N,repmat(ypos,N,1), ...
     xlabetxt','horizontalalignment','right','Rotation',0,'FontSize',15)
text(.55,77.5,'A','FontSize',15)


ylabel('Kp Index','FontSize',15)
xlabel('Universal Time','FontSize',15)




termp=1;

end


%set(get(hb,'children'),'cdata', sign(y) );
%colormap([1 0 0; 0 0 1]);

