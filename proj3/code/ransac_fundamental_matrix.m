% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

%placeholders, you can delete all of this
% Best_Fmatrix = estimate_fundamental_matrix(matches_a(1:10,:), matches_b(1:10,:));
% inliers_a = matches_a(1:30,:);
% inliers_b = matches_b(1:30,:);

% make homogenous
matches_a_homo = [matches_a ones(size(matches_a, 1), 1)];
matches_b_homo = [matches_b ones(size(matches_b, 1), 1)];

Best_Fmatrix = zeros(3, 3);
best_num_inliers = 0;
num_iters = 2000;
threshold = 0.05;

for i=1:num_iters
    sample_rows = datasample(1:size(matches_a), 8, 'Replace', false);
    sample_a = matches_a(sample_rows, :);
    sample_b = matches_b(sample_rows, :);
    Fmatrix = estimate_fundamental_matrix(sample_a, sample_b);
    num_inliers = sum((abs(diag(matches_b_homo * Fmatrix * matches_a_homo')) <= threshold) == 1);
    if best_num_inliers < num_inliers
        best_num_inliers = num_inliers;
        Best_Fmatrix = Fmatrix;
    end
end
mat = abs(diag(matches_b_homo * Best_Fmatrix * matches_a_homo'));
[~, indices] = sort(mat);
indices = indices(1:30);
all_indices = 1:size(mat);
ismem = ismember(all_indices, indices)';
inliers = mat <= threshold;
disp(sum(inliers==1))
inliers = inliers & ismem;
inliers_a = matches_a(inliers, :);
inliers_b = matches_b(inliers, :);
end


