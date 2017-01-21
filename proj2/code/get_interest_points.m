% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete -- random points

[Ix, Iy] = imgradientxy(image);
Ix2 = Ix.^2;
Iy2 = Iy.^2;
IxIy = Ix.*Iy;

large_1d_blur_filter = fspecial('Gaussian', [feature_width 1], 1);
gauss_Ix2 = imfilter(imfilter(Ix2, large_1d_blur_filter), large_1d_blur_filter');
gauss_Iy2 = imfilter(imfilter(Iy2, large_1d_blur_filter), large_1d_blur_filter');
gauss_IxIy = imfilter(imfilter(IxIy, large_1d_blur_filter), large_1d_blur_filter');

alpha = 0.05;

corner_map = gauss_Ix2.*gauss_Iy2 - gauss_IxIy.^2 - alpha * (gauss_Ix2 + gauss_Iy2).^2;
corner_map2 = corner_map > ordfilt2(corner_map, 8, [1, 1, 1; 1, 0, 1; 1, 1, 1]);

boundary = feature_width*2;
corner_map2(:, 1:boundary) = 0;
corner_map2(:, end-boundary:end) = 0;
corner_map2(1:boundary, :) = 0;
corner_map2(end-boundary:end, :) = 0;
corner_map2(corner_map < 0.01*graythresh(corner_map)) = 0;
% figure
% imshow(corner_map2);
indices = find(corner_map2);
[y, x] = ind2sub(size(corner_map2), indices);
confidence = corner_map2(indices);
[confidence, ind] = sort(confidence, 'descend');
y = y(ind);
x = x(ind);
end

