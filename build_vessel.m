%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% given the filter response, use a threshold to
% to split points as being part of the structure
% with value max or zero otherwise
%
% @param: response = matrix with filter response
%         threshold = values to be in the vessel (positive!)
%         max = vessel value in output image
% @return: an image with the vessel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vessel_image=build_vessel(response, threshold, max)

    [M,N] = size(response);
    vessel_image = zeros(M,N);
 
    for m = 1:M
        for n = 1:N
            vessel_image(m,n) = max*(-response(m,n) > threshold);
        end
    end
end