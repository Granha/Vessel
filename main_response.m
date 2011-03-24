% clean
close all;

% parameters definition
N = 128;     % image size
M = N;
c=[40,64];   % disk center
R=4;         % disk radius

% create image
Im=imsyn(N,c,R);

% create atificial image (rectangle)
if 0
  for m=36:44
    for n = 1:N
      Im(m,n) = 255;
    end
  end
end

% 3D images
if 0
load('medical images/Yjunc1');
[M,N,K] = size(Yjunc1);
Im = Yjunc1(:,:,round(K/2));
end

% image has two value 0 background and the 
% structure a constant near 255
MAX = max(Im(:));

% show image
f_init = figure
image(Im); colormap(gray);
print(f_init, '-r80', '-depsc2', 'tjunc1.eps')

response = minimum_response(Im);

% show 3D image of filtered response
f_response = figure
surf(response);
print(f_response, '-r80', '-depsc2', 'tjunc1_filtered.eps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       threshold = 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
reconstructed_im = build_vessel(response, 1, MAX);

% show reconstructed image
figure
image(reconstructed_im); colormap(gray);

diff = Im - reconstructed_im;

figure
surf(diff);
image(abs(diff)); colormap(gray);

end

[threshold, reconstructed_im] = best_threshold(Im, response, 10000);

f_final = figure
image(reconstructed_im); colormap(gray);
print(f_final, '-r80', '-depsc2', 'tjunc1_reconstructed.eps');

