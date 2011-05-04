function [response r_matrix eigen_vectors_matrix eigen_values_matrix]=minimum_response(im, min_r, max_r, increment, valid_region, metric, filter_type)
% @param: im = image to be filtered
%         min_r = minimum scale
%         max_r = maximum scale
%         increment = step size from min_r to max_r
%         valid_region = 0 return everything
%                        1 insert zero in the regions affected by zero-padding
%                        2 resize the matrix to remove the regions affected b zero padding
%         filter_type = 0 OOF
%                       1 Hessian
% @return: response = matrix with filtered values
%          eigen_vectors_matrix = matrix of eigen vectors
%          r_matrix = radius matrix
%          eigen_values_matrix = matrix of eigen values 

if nargin < 7
  filter_type = 0;
end
if nargin < 6
  metric = 0;
end
if nargin < 5
  valid_region = 1;
end
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
  [current_response current_eigen_vectors current_eigen_values] = filter_response(im, r, metric, filter_type);   

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

if valid_region == 1 % put zero in the parts affected by zero-padding
  m_min = 2*max_r;
  m_max = M-m_min;
  n_min = 2*max_r;
  n_max = N-n_min;

  response(1:m_min,:) = 0;
  response(m_max:M,:) = 0;
  response(:,1:n_min) = 0;
  response(:,n_max:N) = 0;  

  r_matrix(1:m_min,:) = 0;
  r_matrix(m_max:M,:) = 0;
  r_matrix(:,1:n_min) = 0;
  r_matrix(:,n_max:N) = 0; 

  eigen_vectors_matrix(1:m_min,:,:,:) = 0;
  eigen_vectors_matrix(m_max:M,:,:,:) = 0;
  eigen_vectors_matrix(:,1:n_min,:,:) = 0;
  eigen_vectors_matrix(:,n_max:N,:,:) = 0;   

  eigen_values_matrix(1:m_min,:,:) = 0;
  eigen_values_matrix(m_max:M,:,:) = 0;
  eigen_values_matrix(:,1:n_min,:) = 0;
  eigen_values_matrix(:,n_max:N,:) = 0;   

elseif valid_region == 2 % remove the parts affected by zero-padding
  response = response(m_min:m_max, n_min:n_max);
  r_matrix = r_matrix(m_min:m_max, n_min:n_max);
  eigen_vectors_matrix = eigen_vectors_matrix(m_min:m_max, n_min:n_max,:,:);
  eigen_values_matrix = eigen_values_matrix(m_min:m_max, n_min:n_max,:);
end

end