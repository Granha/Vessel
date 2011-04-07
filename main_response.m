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
if 1
  for m=36:44
    for n = 1:N
      Im(m,n) = 255;
    end
  end
end

% 3D images
if 0
load('../medical images/Tjunc1');
[M,N,K] = size(Tjunc1);
Im = Tjunc1(:,:,round(K/2));
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


[threshold, reconstructed_im] = best_threshold(Im, response, 10000);

f_final = figure
image(reconstructed_im); colormap(gray);
print(f_final, '-r80', '-depsc2', 'tjunc1_reconstructed.eps');

end

minimum = zeros(M,N);

test = zeros(8);

factor = 0.05;
coeff = 1+factor;

for m = 1:M
  for n = 1:N

    curr_pixel = response(m,n);

    if curr_pixel ~= 0

      test(1) = (m-1 == 0   || response(m-1,n) >= curr_pixel || response(m-1,n) >= coeff*curr_pixel);
      test(2) = (m+1 == M+1 || response(m+1,n) >= curr_pixel || response(m+1,n) >= coeff*curr_pixel);
      test(3) = (n-1 == 0   || response(m,n-1) >= curr_pixel || response(m,n-1) >= coeff*curr_pixel);
      test(4) = (n+1 == N+1 || response(m,n+1) >= curr_pixel || response(m,n+1) >= coeff*curr_pixel);

      test(5) = (m-1 == 0   || n-1 == 0   || response(m-1,n-1) >= curr_pixel || response(m-1,n-1) >= coeff*curr_pixel);
      test(6) = (m+1 == M+1 || n-1 == 0   || response(m+1,n-1) >= curr_pixel || response(m+1,n-1) >= coeff*curr_pixel);
      test(7) = (m-1 == 0   || n+1 == N+1 || response(m-1,n+1) >= curr_pixel || response(m-1,n+1) >= coeff*curr_pixel);
      test(8) = (m+1 == M+1 || n+1 == N+1 || response(m+1,n+1) >= curr_pixel || response(m+1,n+1) >= coeff*curr_pixel);

      % all true
      if sum(test(1:4)) == 4
        minimum(m,n) = 255;
      end
    end
  end
end

f_minimum = figure
image(minimum); colormap(gray);


times = 100;

ball_count = count_ball(response, times);
f_ball = figure
surf(ball_count);

line = 255*(ball_count > 1.5*times*ones(M, N));
figure;
image(line); colormap(gray);