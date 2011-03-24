function Im = imsyn(n,c,r)
x=1:n;
[Y,X]=meshgrid(x,x);
D=240*((X-c(1)).^2+(Y-c(2)).^2 <=r^2);
Im=double(D);
end   
