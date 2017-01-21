function build_vocabulary_gmm( image_paths, vocab_size )
features = [];
bin_size = 16;
for i=1:size(image_paths, 1)
    img = single(imread(image_paths{i}));
    [~, SIFT_features] = vl_dsift(img, 'step', 16, 'size', bin_size, 'fast');
    SIFT_features = datasample(SIFT_features, 100, 2, 'Replace', false);
    features = horzcat(features, SIFT_features);
end
features = single(features);
[MEANS, COVARIANCES, PRIORS, LL, POSTERIORS] = vl_gmm(features, vocab_size);
save('MEANS.mat', 'MEANS')
save('COVARIANCES.mat', 'COVARIANCES')
save('PRIORS.mat', 'PRIORS')
save('LL.mat', 'LL')
save('POSTERIORS.mat', 'POSTERIORS')
end

