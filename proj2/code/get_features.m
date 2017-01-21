% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of feature descriptors for a given set of interest points. 

% 'image' can be grayscale or color, your choice.
% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
%   The local features should be centered at x and y.
% 'feature_width', in pixels, is the local feature width. You can assume
%   that feature_width will be a multiple of 4 (i.e. every cell of your
%   local SIFT-like feature will have an integer width and height).
% If you want to detect and describe features at multiple scales or
% particular orientations you can add input arguments.

% 'features' is the array of computed features. It should have the
%   following size: [length(x) x feature dimensionality] (e.g. 128 for
%   standard SIFT)

function [features] = get_features(image, x, y, feature_width)

% To start with, you might want to simply use normalized patches as your
% local feature. This is very simple to code and works OK. However, to get
% full credit you will need to implement the more effective SIFT descriptor
% (See Szeliski 4.1.2 or the original publications at
% http://www.cs.ubc.ca/~lowe/keypoints/)

% Your implementation does not need to exactly match the SIFT reference.
% Here are the key properties your (baseline) descriptor should have:
%  (1) a 4x4 grid of cells, each feature_width/4. 'cell' in this context
%    nothing to do with the Matlab data structue of cell(). It is simply
%    the terminology used in the feature literature to describe the spatial
%    bins where gradient distributions will be described.
%  (2) each cell should have a histogram of the local distribution of
%    gradients in 8 orientations. Appending these histograms together will
%    give you 4x4 x 8 = 128 dimensions.
%  (3) Each feature should be normalized to unit length
%
% You do not need to perform the interpolation in which each gradient
% measurement contributes to multiple orientation bins in multiple cells
% As described in Szeliski, a single gradient measurement creates a
% weighted contribution to the 4 nearest cells and the 2 nearest
% orientation bins within each cell, for 8 total contributions. This type
% of interpolation probably will help, though.

% You do not have to explicitly compute the gradient orientation at each
% pixel (although you are free to do so). You can instead filter with
% oriented filters (e.g. a filter that responds to edges with a specific
% orientation). All of your SIFT-like feature can be constructed entirely
% from filtering fairly quickly in this way.

% You do not need to do the normalize -> threshold -> normalize again
% operation as detailed in Szeliski and the SIFT paper. It can help, though.

% Another simple trick which can help is to raise each element of the final
% feature vector to some power that is less than one.

features = zeros(size(x,1), 128);
padded_image = padarray(image, [feature_width/2 feature_width/2], 'symmetric');
[Gmag, Gdir] = imgradient(padded_image);
x = round(x);
y = round(y);
for i = 1:size(x,1)
    Gmag_patch = Gmag(y(i):y(i)+feature_width-1, x(i):x(i)+feature_width-1);
    Gdir_patch = Gdir(y(i):y(i)+feature_width-1, x(i):x(i)+feature_width-1);
    unnormalized_features = zeros(128, 1);
    feature_col_idx  = 1;
    for j = 1:feature_width/4:feature_width
        for k = 1:feature_width/4:feature_width
            Gmag_binned = zeros(8, 1);
            Gmag_subpatch = Gmag_patch(j:j+feature_width/4 - 1, k:k+feature_width/4 - 1);
            Gmag_subpatch = Gmag_subpatch(:);
            Gdir_subpatch = Gdir_patch(j:j+feature_width/4 - 1, k:k+feature_width/4 - 1);
            Gdir_subpatch = Gdir_subpatch(:);
            for l = 1:size(Gdir_subpatch)
                bin_idx = min(floor((Gdir_subpatch(l) + 180)/45) + 1, 8);
                Gmag_binned(bin_idx) = Gmag_binned(bin_idx) + Gmag_subpatch(l); 
            end
            unnormalized_features(feature_col_idx:feature_col_idx+7) = Gmag_binned;
            feature_col_idx = feature_col_idx + 8;
        end
    end
    
    %normalizing patch
%     patch = patch/norm(patch);
    features(i,:) = unnormalized_features/norm(unnormalized_features);
end
end






