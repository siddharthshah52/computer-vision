function image_feats = get_fisher(image_paths)
% tic
load('MEANS.mat')
load('COVARIANCES.mat')
load('PRIORS.mat')
image_feats = zeros(size(image_paths, 1), 51200);
bin_size = 16;
for i=1:size(image_paths, 1)
    img = single(imread(image_paths{i}));
    [~, SIFT_features] = vl_dsift(img, 'step', 4, 'size', bin_size, 'fast'); 
    SIFT_features = datasample(single(SIFT_features), 1000, 2, 'Replace', false);
    enc = vl_fisher(SIFT_features, MEANS, COVARIANCES, PRIORS);
    image_feats(i, :) = enc;
end
% toc
end