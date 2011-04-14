function [response r_matrix eigen_vectors_matrix eigen_values_matrix]=minimum_response(im, min_r, max_r, increment)

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
r_matrix = zeros(M,N);

eigen_vectors_matrix  = zeros(M,N,2,2);
current_eigen_vectors = zeros(M,N,2,2);
eigen_values_matrix   = zeros(M,N,2);
current_eigen_values  = zeros(M,N,2);

for r = min_r:increment:max_r % same as in the OOF atricle
  % call filter response
  [current_response current_eigen_vectors current_eigen_values] = filter_response(im, r);   

  for m = 1:M
    for n = 1:N
      % response is lower, update results
      if response(m,n) > current_response(m,n)
	response(m,n) = current_response(m,n);              
	r_matrix(m,n) = r;                     
	eigen_vectors_matrix(m,n,:,:) = current_eigen_vectors(m,n,:,:);
	eigen_values_matrix(m,n,:) = current_eigen_values(m,n,:);
      end

    end
  end

end

end