% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% find top two neighbors of each observation of features1 in features2
% [distances, indices] = pdist2(features2, features1, 'euclidean', 'Smallest', 2);
% distances = distances';
% indices = indices';

[indices, distances] = knnsearch(features2, features1, 'k', 2, 'NSMethod', 'kdtree');
confidences = (distances(:, 1) ./ distances(:, 2));
confidences = confidences(:,1);
indices = indices(:,1);
% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences);
% num_features = size(features1, 1);
num_features = 100;
% num_features = size(confidences(confidences < 0.7), 1);
confidences = confidences(1:num_features);
matches = zeros(num_features, 2);
matches(:, 1) = ind(1:num_features);
matches(:, 2) = indices(ind(1:num_features));