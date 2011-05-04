function [response eigen_vectors_matrix eigen_values_matrix]=filter_response(im,r, metric, filter_type)
% @param: im = image to be filtered
%         r  = radius of the circle
%         filter_type = 0 OOF
%                       1 Hessian
% @return: response = matrix with filtered values
%          eigen_vectors_matrix = matrix of eigen vectors
%          eigen_values_matrix = matrix of eigen values

if nargin < 4
  filter_type = 0; % default OOF
end
if nargin < 3
  metric = 0; % dafault Trace(Q)
end

im = im2double(im);

[M, N] = size(im);

response=zeros(M,N); % allocate response matrix

m = (M+1)/2;
n = (N+1)/2;

conv_type = 'same';

if filter_type == 0
  % gaussien filters convoluted with circle step
  dim=25; % some magic number that i don't understand
  h11=conv2(ball(m,n,r,M,N),g11(dim), conv_type); % gaussien derived twice in x
  h22=conv2(ball(m,n,r,M,N),g22(dim), conv_type); % gaussien derived twice in y
  h12=conv2(ball(m,n,r,M,N),g12(dim), conv_type); % gaussien derived in x and y
elseif filter_type == 1
  dim = 12*r + 25;
  h11 = g11(dim,r);
  h22 = g22(dim,r);
  h12 = g12(dim,r);
end

% filter image
Imf11=conv2(im,h11, conv_type);
Imf22=conv2(im,h22, conv_type);
Imf12=conv2(im,h12, conv_type);

eigenvalue=zeros(2);

matrix = zeros(2,2);
vectors = zeros(2,2);
values = zeros(2,2);

eigen_vectors_matrix = zeros(M,N,2,2);
eigen_values_matrix = zeros(M,N,2);

eigen_values_sum = 0;

% calculate response value for each point
for m = 1:M
    for n = 1:N
	matrix(1,1) = Imf11(m,n);
	matrix(1,2) = Imf12(m,n);
	matrix(2,1) = Imf12(m,n);
	matrix(2,2) = Imf22(m,n);

	eigen_values_sum = trace(matrix); % filter response
	
	[vectors, values] = eig(matrix);

	% assure that the first element corresponds to the highest eigin value
	% this is the struture direction
	if values(2,2) > values(1,1)
	   higher = 2;
	   lower  = 1;
	else
	  higher = 1;
	  lower  = 2;
	end
	
	eigen_vectors_matrix(m,n,:,1) = vectors(:,higher);
	eigen_vectors_matrix(m,n,:,2) = vectors(:,lower);
	eigen_values_matrix(m,n,1)    = values(higher,higher);
	eigen_values_matrix(m,n,2)    = values(lower,lower);

	if values(1) > values(2)
	  lamb1 = values(1);
	  lamb2 = values(2);
	else
	  lamb1 = values(2);
	  lamb2 = values(1);
	end

	if metric == 1
	  eigen_values_sum = -abs(lamb2)*exp(-1000*abs(lamb1));	
	end
	
        response_norm = eigen_values_sum/(2*pi*r); % normalize response
        
        response(m,n) =  response_norm; % assign in response matrix            
    end
end
