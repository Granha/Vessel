%% clean
clc;
clear all;
close all;

%% parameters

output_dir = '../results/';
base_name = 'rectangle';
out_base = strcat(output_dir, base_name);

noisy = 1;
noisy_sigma = 0;
pretreatement = 0;

%% Create files

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
elseif strcmp(base_name, 'circle_grid')
  R = 4; % circle radius
  dist = 2*R+4; % distance between two adjancent circles
  % draw a grid of circles
  for m = (dist+4):dist:(M-(dist+4))
    for n = (dist+4):dist:(N-(dist+4))
      Im = Im + imsyn(N,[m,n],R); % combine circles to the previous image
    end
  end
elseif strcmp(base_name, 'retina')
  Im = imread('../medical images/retina_origin.JPG');
  Im = rgb2gray(Im);
  Im = imcomplement(Im);
%  Im = imresize(Im, 1/4);
% Im = Im(14:134,41:130);
  Im = Im(15:538,196:522);
  [M, N] = size(Im);
elseif strcmp(base_name, 'tjunc1') % 3D images
  load('../medical images/Tjunc1');
  [M,N,K] = size(Tjunc1);
  Im = Tjunc1(:,:,round(K/2));
elseif strcmp(base_name, 'yjunc1') % 3D images
  load('../medical images/Yjunc1');
  [M,N,K] = size(Yjunc1);
  Im = Yjunc1(:,:,round(K/2));
end

%% show image
f_init = figure
%imshow(Im);
image(Im); colormap(gray);
title('original image');
print(f_init, '-r80', '-djpeg', strcat(out_base, '_figure.jpg'));

%%  add noisy
if noisy && noisy_sigma > 0
  out_base = strcat(out_base,'_noisy');  
  Im = Im + noisy_sigma*randn(size(Im));
  f_noisy = figure
  image(Im); colormap(gray);
  title('noisy image');
end

%% pretreatement
if pretreatement
%  Im = pretreatment(Im, 1);  
  Im = medfilt2(Im); % 3x3 neighborhoodx
  f_pretreated = figure
  image(Im); colormap(gray);
%  imshow(Im);
  title('pretreated image');
  print(f_pretreated, '-r80', '-djpeg', strcat(out_base, '_pretreated.jpg'));  
end

% image has two value 0 background and the 
% structure a constant near 255
MAX = max(Im(:));

[response r_matrix eigen_vectors_matrix eigen_values_matrix] = minimum_response(Im, 1, 8, 0.5, 1, 0, 0);

[a b c d] = size(eigen_vectors_matrix)

old_resp = response;
%% remove noisy  by thresholding filter response
if  noisy
  response = old_resp;
  threshold = 0.1*min(response(:)); % threshold: 5% of min
  idx = response > threshold;
  response = imhmin(response,-threshold);
  response(idx) = 0;
  r_matrix(idx) = 0; % remove noisy radius
%  eigen_vectors_matrix(idx,:,:) = 0; % remove noisy vectors
%  eigen_values_matrix(idx,:) = 0; % remove noisy eigen
                                           % values					 
%  response = pretreatment(response, 1);  
end

%% show 3D image of filtered response
f_response = figure;
surf(response);
title('filter response');
print(f_response, '-r80', '-djpeg', strcat(out_base, '_filtered.jpg'));


% rescale radius valeus to better visualization
min_radius = min(r_matrix(:));
max_radius = max(r_matrix(:));
aux_r_matrix = 40*(1/(max_radius-min_radius))*(r_matrix(:,:) - min_radius);

f_radius = figure
image(aux_r_matrix); colormap(gray);
title('radius');
print(f_radius, '-r80', '-djpeg', strcat(out_base, '_radius.jpg'));

direction = atan2(eigen_vectors_matrix(:,:,2,1), eigen_vectors_matrix(:,:,1,1) + 0.0001);

min_direction = min(direction(:));
max_direction = max(direction(:));
direction = 80*(1/(max_direction-min_direction))*(direction(:,:) - min_direction);

f_direction = figure
image(direction); colormap(gray);
title('vessel direction');
print(f_direction, '-r80', '-djpeg', strcat(out_base, '_direction.jpg'));

%% Find best threshold by comparing
%% binarized image to the original one
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if 0 % disable
% 
% reconstructed_im = build_vessel(response, 1, MAX);
% 
% % show reconstructed image
% figure
% image(reconstructed_im); colormap(gray);
% 
% diff = Im - reconstructed_im;
% 
% figure
% surf(diff);
% image(abs(diff)); colormap(gray);
% 
% 
% [threshold, reconstructed_im] = best_threshold(Im, response, 10000);
% 
% f_final = figure
% image(reconstructed_im); colormap(gray);
% print(f_final, '-r80', '-djpeg', strcat(out_base, '_reconstructed.jpg'));
% 
% end


%%        Find local minimum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

minimum = local_minimum(response);
%minimum = imextendedmin(response, abs(0.3*min(min(response))));
minimum_im = 255*minimum;

f_minimum = figure
image(minimum_im); colormap(gray);
title('centerlines (local minima)');
print(f_minimum, '-r80', '-djpeg', strcat(out_base, '_centerline.jpg'));


%% Reconstructed image using centerline
%% and radius    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reconstructed_im = 255*reconstruction(minimum, r_matrix);
f_reconstructed = figure
image(reconstructed_im); colormap(gray);
title('reconstructed vessels');
print(f_reconstructed, '-r80', '-djpeg', strcat(out_base, '_reconstructed.jpg'));


%%      Stochastic throwing balls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%times = 100;
%
%% ball throwing
%ball_count = count_ball(response, times);
%f_ball = figure
%surf(ball_count);
%title('balls stochastic');
%print(f_ball, '-r80', '-djpeg', strcat(out_base, '_ball_stochastic.jpg'));
%
%% ball centerline
%line = 255*(ball_count > 1.5*times*ones(M, N));
%f_ball_centerline = figure;
%image(line); colormap(gray);
%title('ball centerline');
%print(f_ball_centerline, '-r80', '-djpeg', strcat(out_base, '_ball_centerline.jpg'));
