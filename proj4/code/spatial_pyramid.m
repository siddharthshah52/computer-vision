function image_feats = spatial_pyramid(image_paths)
% tic
load('vocab.mat')
vocab_size = size(vocab, 1);
image_feats = zeros(size(image_paths, 1), 21*vocab_size); % 3 levels = 21 histograms (1 + 4 + 16)
bin_size = 16;
for i=1:size(image_paths, 1)
    if mod(i, 100) == 0 || i == 1
        fprintf('Generating features for image# %d \n', i);
    end
    img = single(imread(image_paths{i}));
%     img = vl_imsmooth(img, sqrt(bin_size/magnif)^2 - .25);
    [locations, SIFT_features] = vl_dsift(img, 'step', 4, 'size', bin_size, 'fast'); 
    [SIFT_features, idx] = datasample(SIFT_features, 1000, 2, 'Replace', false);
    locations = locations(:, idx);
    [m, n] = size(img);
    hist_num = 1;
    for level=0:2
        % finest level
        if level==2
            for r=0:3
                for c=0:3
                    filtered_indices = [];
                    for index=1:size(locations, 2)
                        x = locations(1, index);
                        y = locations(2, index);
                        if x > r*(m/4) && x <= (r+1)*(m/4) && y > c*(n/4) && y <= (c+1)*(n/4)
                            filtered_indices = [filtered_indices index];
                        end
                    end
                    pairwise_dist = vl_alldist2(vocab', single(SIFT_features(:, filtered_indices)));
                    [~, I] = min(pairwise_dist);
                    image_feats(i, vocab_size*(hist_num-1)+1:vocab_size*hist_num) = histcounts(I, 1:vocab_size+1)/2;
                    hist_num = hist_num + 1;
                end 
            end
        end
        if level==1
            for r=0:1
                for c=0:1
                    filtered_indices = [];
                    for index=1:size(locations, 2)
                        x = locations(1, index);
                        y = locations(2, index);
                        if x > r*(m/2) && x <= (r+1)*(m/2) && y > c*(n/2) && y <= (c+1)*(n/2)
                            filtered_indices = [filtered_indices index];
                        end
                    end
                    pairwise_dist = vl_alldist2(vocab', single(SIFT_features(:, filtered_indices)));
                    [~, I] = min(pairwise_dist);
                    image_feats(i, vocab_size*(hist_num-1)+1:vocab_size*hist_num) = histcounts(I, 1:vocab_size+1)/4;
                    hist_num = hist_num + 1;
                end
            end
        end
        if level==0
            pairwise_dist = vl_alldist2(vocab', single(SIFT_features));
            [~, I] = min(pairwise_dist);
            image_feats(i, vocab_size*(hist_num-1)+1:vocab_size*hist_num) = histcounts(I, 1:vocab_size+1)/8;
            hist_num = hist_num + 1;
        end
    end
end
image_feats = bsxfun(@rdivide, image_feats, sum(abs(image_feats), 2)); % abs not needed but just for the sake of definition of l1 norm
% toc
end