function im = recons(image,mask,mode)

% recons(image,mask,mode) 
%
%   Computes the reconstruction of the image image using the marker mask 
%  by dilation (mode = 'dilation') or by erosion (mode = 'erosion')

se=strel('diamond',1);

switch mode
case 'dilation'

cond = 0;

temp=min(image,mask);
while cond==0
 im=min(image,imdilate(temp,se));
 if im==temp
  cond = 1;
 end
 temp=im;
end

case 'erosion'

cond = 0;

temp=max(image,mask);
while cond==0
     im=max(image,imerode(temp,se));
 if im==temp
  cond = 1;
 end
 temp=im;
end


otherwise
   return
end
