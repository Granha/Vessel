function response=minimum_response(im, min_r, max_r, increment)

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
current_response = zeros(M,N);

for r = min_r:increment:max_r % same as in the OOF atricle
  % call filter response
  current_response = filter_response(im, r);   
  response = min(response, current_response);   
end

end