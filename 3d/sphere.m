function s = sphere(m,n,k,r,M,N, K) 
%create a ball at a specific spot and radius
%  m, n: location,  r:radius, M, N: image size
xc=n;yc=m;zc=k;
x = repmat((1:N), [M,1,K]);
y = repmat((1:M)',[1,N,K]);
zeros(M,N,K);
for k=1:K
  z(:,:,k) = repmat(k,M,N);
end

s = (x-xc).^2+(y-yc).^2+(z-zc).^2 <= r^2*ones(M,N,K);
s = double(s);