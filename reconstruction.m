function [rec] = reconstruction(minima, radii)
% image reconstruction from its minima and the
% correspondig radius

[M, N] = size(minima);
rec = zeros(M,N);
[line, column] = find(minima==true);

for k = 1:length(line)
  m = line(k);
  n = column(k);
  rec = rec | ball(m,n,radii(m,n),M,N);  
end
