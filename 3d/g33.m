%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second derivative of Gaussian along axis 3
% this corresponds to entry i and j (i=3,j=3) in the Q matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = g33(n)
A=1/sqrt(2*pi);
xc=(n)/2; yc=(n)/2; zc=(n)/2;
x = repmat((0:n-1), [n,1,n]);
y = repmat((0:n-1)',[1,n,n]);
zeros(n,n,n);
for k=1:n
  z(:,:,k) = repmat(k,n,n);
end
f=A.*exp(-(y-yc).^2./2).*exp(-(x-xc).^2./2).*exp(-(z-zc).^2./2).*((z-zc).^2-1);
