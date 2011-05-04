%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @param: im = image to be filtered
%         r  = radius of the circle
% @return: matrix with filtered values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [response eigen_vectors_matrix eigen_values_matrix]=filter_response(im,r)

[M, N, K] = size(im);

response=zeros(M,N,K); % allocate response matrix

m = (M+1)/2;
n = (N+1)/2;
k = (K+1)/2;

conv_type = 'same';
% gaussien filters convoluted with circle step
dim=25; % some magic number that i don't understand

S = 2*dim + 4*r;
c = (S+1)/2;
h11=convn(sphere(c,c,c,r,S,S,S),g11(dim), conv_type); % gaussien derived twice in x
h22=convn(sphere(c,c,c,r,S,S,S),g22(dim), conv_type); % gaussien derived twice in y
h33=convn(sphere(c,c,c,r,S,S,S),g33(dim), conv_type); % gaussien derived twice in z

% filter image
Imf11=convn(im,h11, conv_type);
Imf22=convn(im,h22, conv_type);
Imf33=convn(im,h33, conv_type);

eigenvalue=zeros(3);

eigen_vectors_matrix = zeros(M,N,K,2,2);
eigen_values_matrix = zeros(M,N,K,2);

eigen_values_sum = 0;

% calculate response value for each point
for m = 1:M
    for n = 1:N
	eigen_values_sum = Imf11(m,n) + Imf22(m,n) + Imf33(m,n);
	
        response_norm = eigen_values_sum/(2*pi*r); % normalize response
        
        response(m,n) =  response_norm; % assign in response matrix            
    end
end
