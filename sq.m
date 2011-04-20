function el = sq(n,L) % n:la taille de b, r:taille du carré
xc=(n+1)/2;yc=(n+1)/2;
x = repmat(1:n, n,1);
y = repmat((1:n)',1,n);
el = double(abs((x-xc))<L/2 & abs((y-yc))<L/2);