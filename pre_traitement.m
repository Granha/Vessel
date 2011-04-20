function [fp] = pre_traitement(f, el)
% PRETRAITEMENT FONCTION SMOOTHING
% [fp] = pre_traitement(f, mask) smooth a fonction "f"
% using a reconstruction opening by the element "el" 

marker = imerode(f, el);
fp = imreconstruct(marker, f);