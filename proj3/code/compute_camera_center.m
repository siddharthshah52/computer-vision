% Camera Center Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu, Grady Williams, James Hays

% Returns the camera center matrix for a given projection matrix

% 'M' is the 3x4 projection matrix
% 'Center' is the 1x3 matrix of camera center location in world coordinates

function [ Center ] = compute_camera_center( M )

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

Center = -inv(M(:, 1:3)) * M(:, 4);
end

