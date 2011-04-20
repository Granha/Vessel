%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second derivative of Gaussian along axis y
% this corresponds to entry i and j (i=2,j=2) in the Q matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = g22(n)
A=1/sqrt(2*pi);
xc=(n)/2; yc=(n)/2;
x = repmat(0:n-1, n,1);
y = repmat((0:n-1)',1,n);
f=A.*exp(-(y-yc).^2./2).*exp(-(x-xc).^2./2).*((y-yc).^2-1);
