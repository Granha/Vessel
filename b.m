%step function b
function f = b(n,r) % n:la taille de b, r:rayon du cercle local
f = double(zeros(n,n));
xc=(n+1)/2;yc=(n+1)/2;
for x=1:n
    for y=1:n
        if (x-xc)^2+(y-yc)^2 <= r^2 
            f(x,y)=1;
        end
    end
end
