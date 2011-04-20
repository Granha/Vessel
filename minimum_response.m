function [response, radii]=minimum_response(im, min_r, max_r, increment)

if nargin < 4
  increment = 0.5;
end
if nargin < 3
  max_r = 6;
end
if nargin < 2
  min_r = 1; 
end

[M,N] = size(im);

response = zeros(M,N);
radii = zeros(M, N);
dim = 25;

for r = min_r:increment:max_r % same as in the OOF atricle
  % call filter response
  current_response = filter_response(im, r, dim);
  %current_response = filter_reponse_sqr(im, r, dim);
  isinf = current_response < response;
  response = isinf.*current_response + ~isinf.*response;
  radii = isinf.*r + ~isinf.*radii;
  
%   issup = current_response > response;
%   response = issup.*current_response + ~issup.*response;
%   radii = issup.*r + ~issup.*radii;
end
response = abs(response)