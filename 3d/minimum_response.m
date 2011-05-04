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

[M,N,K] = size(im);

response = zeros(M,N,K);
current_response = zeros(M,N,K);
r_matrix = zeros(M,N,K);

eigen_vectors_matrix  = zeros(M,N,K,2,2);
current_eigen_vectors = zeros(M,N,K,2,2);
eigen_values_matrix   = zeros(M,N,K,2);
current_eigen_values  = zeros(M,N,K,2);

for r = min_r:increment:max_r % same as in the OOF atricle
  % call filter response
  [current_response current_eigen_vectors current_eigen_values] = filter_response(im, r);   

  for m = 1:M
    for n = 1:N
      for k = 1:K
        % response is lower, update results
        if response(m,n,k) > current_response(m,n,k)
	  response(m,n,k) = current_response(m,n,k);              
	  r_matrix(m,n,k) = r;                     
	  eigen_vectors_matrix(m,n,k,:,:) = current_eigen_vectors(m,n,k,:,:);
	  eigen_values_matrix(m,n,k,:) = current_eigen_values(m,n,k,:);
	end
      end
    end
  end
end

end