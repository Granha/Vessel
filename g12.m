function f = g12(n,sigma)
% second derivative of Gaussian along axis x and y
% this corresponds to entry i and j (i=1,j=2) or (i=2, j=1) in the Q matrix
if nargin < 2
  sigma = 1;
end

A=1/(sqrt(2*pi)*sigma);
xc=(n)/2; yc=(n)/2;
x = repmat(0:n-1, n,1);
y = repmat((0:n-1)',1,n);
f = A.*exp(-(y - yc).^2./(2*sigma^2)).*exp(-(x-xc).^2./(2*sigma^2)).*(x-xc).*(y-yc);
