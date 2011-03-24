%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% second derivative of Gaussian along axis x 
% this corresponds to entry i and j (i=1,j=1) in the Q matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = g11(n)
f=double(zeros(n,n));
A=1/sqrt(2*pi);
xc=n/2; yc=n/2;
for x=1:n
    for y=1:n
        f(x,y)=A*exp(-(y-yc)^2/2)*exp(-(x-xc)^2/2)*((x-xc)^2-1);
    end
end