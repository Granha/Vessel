%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find the best threshold according to a metric (see implementation) 
% to evalute recontructed image regarding original one
%
% @param: original_im = original image
%         response = filter response
%         max_iteration = max number of iterations
% @return: threshold value and the best recontructed matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [threshold, best_reconstructed]=best_threshold(original_im, response, max_iteration)

min_response = abs(min(response(:)));
max_pixel_value = max(original_im(:));

% number of iterations is bounded by minium response value
if nargin < 3
  max_iteration = min_response;
end

% assure that maximum iteration number is respected
if max_iteration > min_response
   max_iteration = round(min_response)+1;
end

[M,N] = size(original_im);
best_reconstructed = zeros(M,N);

% count the number of pixel in the original image that belongs to the
% structure
total_structure_pixel = sum(original_im(:) > 0);

% mean pixel value in the structure
mean_pixel_value = sum(original_im(:))/total_structure_pixel;

metric = zeros(max_iteration);

min_diff = -1;
for k = 1:max_iteration
  reconstructed_im = build_vessel(response, k, max_pixel_value);

  % metric value
  metric(k) = 100*sum(abs(original_im(:) - reconstructed_im(:)) > mean_pixel_value/2)/double(total_structure_pixel);
  
  % first iteration or better value found accordin to metric
  if min_diff == -1 || metric(k) < min_diff
       min_diff = metric(k);
       threshold = k;
  end
  
end

% rebuild using best threshold
best_reconstructed = build_vessel(response, threshold, max_pixel_value);

% show the threshold (x) by metric values (y)
f = figure
plot(1:max_iteration,metric); grid;
xlabel('threshold');
ylabel('metric');

print(f, '-r80', '-depsc2', 'threshold_curve.eps');

end