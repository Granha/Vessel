function [rec] = reconstruction(minima, radii)
% image reconstruction from its minima and the
% correspondig radius

[M, N] = size(minima);
rec = zeros(M,N);
[ligne, columne] = find(minima==true);

for m=[ligne(1):ligne(end)]
  for n=[columne(1):columne(end)]
    rec = rec | ball(m,n,radii(m,n),M,N);
  end
end
    