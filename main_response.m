% clean
close all;

output_dir = '../results/';
base_name = 'rectangle';
out_base = strcat(output_dir, base_name);

noisy = 0;

% parameters definition
M = 128;     % image size
N = M;

Im = zeros(M,N);

if strcmp(base_name, 'circle')
  c=[40,64];   % disk center
  R=4;         % disk radius
  Im=imsyn(N,c,R);
elseif strcmp(base_name, 'rectangle') 
  for m=36:44
    for n = 1:N
      Im(m,n) = 255;
    end
  end
elseif strcmp(base_name, 'tjunc1') % 3D images
  load('../medical images/Tjunc1');
  [M,N,K] = size(Tjunc1);
  Im = Tjunc1(:,:,round(K/2));
elseif strcmp(base_name, 'yjunc1') % 3D images
  load('../medical images/Yjunc1');
  [M,N,K] = size(Yjunc1);
  Im = Yjunc1(:,:,round(K/2));
end

if noisy
  out_base = strcat(out_base,'_noisy');  
  sigma = 0.1;
  Im = Im + sigma*randn(size(Im));
end


% image has two value 0 background and the 
% structure a constant near 255
MAX = max(Im(:));

% show image
f_init = figure
image(Im); colormap(gray);
print(f_init, '-r80', '-depsc2', strcat(out_base, '_figure.eps'));

[response r_matrix eigen_vectors_matrix eigen_values_matrix] = minimum_response(Im);

% show 3D image of filtered response
f_response = figure
surf(response);
print(f_response, '-r80', '-depsc2', strcat(out_base, '_filtered.eps'));

f_radius = figure
image(r_matrix); colormap(gray);
print(f_radius, '-r80', '-depsc2', strcat(out_base, '_radius.eps'));

direction = atan(eigen_vectors_matrix(:,:,2,1)./(eigen_vectors_matrix(:,:,1,1)+0.001));
min_direction = min(direction(:));
max_direction = max(direction(:));
direction = 255*(1/(max_direction-min_direction))*(direction(:,:) - min_direction);
f_direction = figure
image(direction); colormap(gray);
print(f_direction, '-r80', '-depsc2', strcat(out_base, '_direction.eps'));

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
print(f_final, '-r80', '-depsc2', strcat(out_base, '_reconstructed.eps'));

end

minimum = 255*local_minimum(response);

f_minimum = figure
image(minimum); colormap(gray);
print(f_minimum, '-r80', '-depsc2', strcat(out_base, '_centerline.eps'));

times = 100;

ball_count = count_ball(response, times);
f_ball = figure
surf(ball_count);
print(f_ball, '-r80', '-depsc2', strcat(out_base, '_ball_stochastic.eps'));

line = 255*(ball_count > 1.5*times*ones(M, N));
f_ball_centerline = figure;
image(line); colormap(gray);
print(f_ball_centerline, '-r80', '-depsc2', strcat(out_base, '_ball_centerline.eps'));
