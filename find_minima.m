function [minima] = find_minima(f)
% FIND_MINIMA SEARCH FOR ALL IMAGE MINIMAS
%
% [minima] = find_minima(im) returns a logical
% matrix where all places on which there is a minimim
% are true


se = strel('disk',1);					
marker = imerode(f, se);
%marker = max(f - 10,0);
f_marker = figure;
surf(marker);
rec = imreconstruct(marker, f);

minima = f > rec;
f_diff = figure;
surf(f - rec);