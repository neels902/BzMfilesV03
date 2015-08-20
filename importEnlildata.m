function OUTPUT= importEnlildata(fileToRead1)
% function used by [Bearth,Vearth]= EnlilB0(I_String,vararginA)

newData1 = importdata(fileToRead1);
OUTPUT=newData1.data;

end