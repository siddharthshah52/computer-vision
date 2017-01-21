function vocab = ssdesc(image_paths, vocab_size)
features = [];
parms.patch_size = 13;
parms.desc_rad = 100;
parms.nrad = 3;
parms.nang = 12;
parms.var_noise = 300000;
parms.saliency_thresh = 0.7;
parms.homogeneity_thresh = 0.7;
parms.snn_thresh = 0.85;
for i=1:size(image_paths,1)
    if i==1 || mod(i, 100)==0
        fprintf('self-similarity descriptors for image# %d', i);
    end
    img = single(imread(image_paths{i}));
    [resp, draw_coords, salient_coords, homogeneous_coords, snn_coords] = mexCalcSsdescs(double(img), parms);
    resp = datasample(resp, 100, 2, 'Replace', false);
    features = [features resp];
end
features = single(features);
[vocab, ~] = vl_kmeans(features, vocab_size);
vocab = vocab';
end