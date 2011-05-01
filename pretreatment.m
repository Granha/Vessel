function imp = pretreatment(im, iter, thresh)
% PRETREATMENT IMAGE PRETREATEMENT TO BINARIZE AND REMOVE NOISE
% imp = pretreatment(im) uses a alternate sequential filtering
% with iter iteration, and after aplyes the binarization 
% threshold thresh

if nargin < 3
  thresh = 0.1*max(max(im));
  if nargin < 2
    iter = 1;
  end
end

imp = im;
%% ASF
for r=1:iter
  se = strel('disk', r);
  open = imopen(imp, se);
  rec1 = recons(imp, open, 'dilation');
    
  ferm = imclose(rec1, se);
  rec2 = recons(rec1, ferm, 'erosion');
  
  figure;
  imshow(rec2);
  title('in pretreatement before thresh');
  drawnow;
  
  imp = rec2;
end

%% Binarization

imp = 255*(imp > thresh);
