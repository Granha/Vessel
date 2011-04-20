%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @param: im = image to be filtered
%         dim = dimension of the gaussian filter
%         r  = radius of the circle
% @return: matrix with filtered values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function response=filter_reponse_sqr(im,r,dim)

[m, n] = size(im);

response=zeros(m,n); % allocate response matrix

% gaussien filters convoluted with circle step
square = sq(n,r);
h11=conv2(square,g11(dim),'same'); % gaussien derived in x
h22=conv2(square,g22(dim),'same'); % gaussien derived in y
h12=conv2(square,g12(dim),'same'); % gaussien derived in x and y

% filter image
Imf11=conv2(im,h11,'same');
Imf22=conv2(im,h22,'same');
Imf12=conv2(im,h12,'same');

%eigenvalue=zeros(2);

Q = zeros(2,2);			% flux matrix
%vectors = zeros(2,2);
%values = zeros(2,2);

for i = 1:m				
    for j = 1:n
	Q(1,1) = Imf11(i,j);
	Q(1,2) = Imf12(i,j);
	Q(2,1) = Imf12(i,j);
	Q(2,2) = Imf22(i,j);
	
	[vectors, values] = eig(Q);

    values = diag(values);
	% Filter Reponse
    % there can be no positif eigenvalue
    % if sum(values>0)==0
    %     response(i,j) = sqrt(prod(values));
    % else
    %     response(i,j) = 0;
    % end
    
    response(i,j) = trace(Q)/(2*pi*r);           
    end
end
