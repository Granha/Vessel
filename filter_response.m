%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @param: im = image to be filtered
%         r  = radius of the circle
% @return: matrix with filtered values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function response=filter_response(im,r)

[m, n] = size(im);

response=zeros(m,n); % allocate response matrix

% gaussien filters convoluted with circle step
dim=25; % some magic number that i don't understand
h11=conv2(b(n,r),g11(dim),'same'); % gaussien derived in x
h22=conv2(b(n,r),g22(dim),'same'); % gaussien derived in y
h12=conv2(b(n,r),g12(dim),'same'); % gaussien derived in x and y

% filter image
Imf11=conv2(im,h11,'same');
Imf22=conv2(im,h22,'same');
Imf12=conv2(im,h12,'same');

eigenvalue=zeros(2);

matrix = zeros(2,2);
vectors = zeros(2,2);
values = zeros(2,2);

% calculate response value for each point
for i = 1:m
    for j = 1:n
        eigenvalue(1) = Imf11(i,j);
        eigenvalue(2) = Imf22(i,j);

	matrix(1,1) = Imf11(i,j);
	matrix(1,2) = Imf12(i,j);
	matrix(2,1) = Imf12(i,j);
	matrix(2,2) = Imf22(i,j);
	
	[vectors, values] = eig(matrix);

        response_norm = sum(eigenvalue(:))/(2*pi*r); % normalize response
        
        response(i,j) =  response_norm; % assign in response matrix            
    end
end
