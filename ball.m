function b = ball(m,n,r,M,N) 
%create a ball at a specific spot and radius
%  m, n: location,  r:radius, M, N: image size
xc=n;yc=m;
x = repmat(1:N, M,1);
y = repmat((1:M)',1,N);
b = (x-xc).^2+(y-yc).^2 <= r^2*ones(M,N);
b = double(b);