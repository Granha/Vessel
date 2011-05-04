function p = pipe(m,n,r,M,N, K) 
%  create a pipe at a specific centerline and radius
%  m, n: center,  r:radius, M, N, K: image size
xc=n;yc=m;
x = repmat((1:N), [M,1,K]);
y = repmat((1:M)',[1,N,K]);
zeros(M,N,K);
for k=1:K
  z(:,:,k) = repmat(k,M,N);
end

p = (x-xc).^2+(y-yc).^2 <= r^2*ones(M,N,K);
p = double(p);