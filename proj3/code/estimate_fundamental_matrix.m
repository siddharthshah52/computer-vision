% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

% % normalization
Points_a_mean = mean(Points_a);
Points_b_mean = mean(Points_b);
Points_a_zero_mean = bsxfun(@minus, Points_a, Points_a_mean);
Points_b_zero_mean = bsxfun(@minus, Points_b, Points_b_mean);
s1 = std2(Points_a_zero_mean);
s2 = std2(Points_b_zero_mean);
T_a = [s1, 0, -s1*Points_a_mean(1); 0, s1, -s1*Points_a_mean(2); 0, 0, 1];
T_b = [s2, 0, -s2*Points_b_mean(1); 0, s2, -s2*Points_b_mean(2); 0, 0, 1];
Points_a = (T_a * [Points_a ones(size(Points_a, 1), 1)]')';
Points_b = (T_b * [Points_b ones(size(Points_b, 1), 1)]')';

A = zeros(size(Points_a, 1), 9);
for i=1:size(Points_a, 1)
    u1 = Points_a(i, 1);
    v1 = Points_a(i, 2);
    u2 = Points_b(i, 1);
    v2 = Points_b(i, 2);
    A(i, :) = [u1*u2, v1*u2, u2, u1*v2, v1*v2, v2, u1, v1, 1];
end

[~, ~, V] = svd(A);
f = V(:, end);
F_matrix = reshape(f, [3, 3])';
[U, S, V] = svd(F_matrix);
S(end, end) = 0;
F_matrix = U * S * V';
F_matrix = T_b' * F_matrix * T_a;
end

