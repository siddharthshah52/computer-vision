scale_factor = 0.5;
feature_width = 16;
num_feature_points_from_each_image = 1000;
files = dir('../data/pca_train_data/*.jpg');
num_files = size(files, 1);
feature_matrix = zeros(num_feature_points_from_each_image * size(files,1), 128);
j = 1;
for i = 1:num_files
    disp(i);
    im_path = strcat('../data/pca_train_data/', files(i).name);
    image = imread(im_path);
    image = single(image)/255;
    image = imresize(image, scale_factor, 'bilinear');
    image_bw = rgb2gray(image);
    [x, y] = get_interest_points(image_bw, feature_width);
    [image_features] = get_features(image_bw,x,y,feature_width);
    indices = randi(size(image_features, 1), 1, num_feature_points_from_each_image);
    feature_matrix(j:j+num_feature_points_from_each_image-1, :) = image_features(indices, :);
    j = j + num_feature_points_from_each_image;
end

[coeff,score,~,~,explained,mu] = pca(feature_matrix, 'Centered', true, 'NumComponents', 32); 
