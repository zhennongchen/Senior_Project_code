function [output] = Transform_nii_to_dcm_coordinate(nii,number_of_flip)

% transform nii image (directly loaded from nii file) to dcm image
% coordinate system, conventional setting for number_of_flip = 3

output = permute(nii,[2 1 3]);

if number_of_flip >= 1
    output = flip(output,1);
end

if number_of_flip >= 2
    output = flip(output,2);
end

if number_of_flip >=3
    output = flip(output,3);
end