function OUT = testcompile (xx,yy)

x2 = str2num(xx);
y2 = str2num(yy);

z = (2* x2 *x2) + 10*y2;

OUT = z

save -ascii out.txt OUT

return