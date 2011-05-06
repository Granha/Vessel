%% clean
clc;
clear all;
close all;

base_name = 'pipe';

if strcmp(base_name, 'pipe') 

Im = pipe(12,12,4,24,24,24);

elseif strcmp(base_name, 'tjunc1') 
  load('../../medical images/Tjunc1');
  Im = Tjunc1;
elseif strcmp(base_name, 'yjunc1') 
  load('../../medical images/Yjunc1');
  Im = Yjunc1;
end

[M,N,K] = size(Im);

[response r_matrix eigen_vectors_matrix eigen_values_matrix] = minimum_response(Im, 4, 6);

