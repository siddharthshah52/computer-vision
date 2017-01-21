function features_neg = get_hard_negative_features(non_face_scn_path, bboxes, image_ids, feature_params, features_negative)
non_faces = dir( fullfile( non_face_scn_path, '*.jpg' ));
t = feature_params.template_size;
features_hard_neg = zeros(0, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);
j = 1;
for i=1:length(non_faces)
    img = imread( fullfile( non_face_scn_path, non_faces(i).name ));
    img = single(img)/255;
    if(size(img,3) > 1)
        img = rgb2gray(img);
    end
    [m, n] = size(img);
    while j<=size(image_ids, 1) && strcmp(image_ids(j), non_faces(i).name)
        x_min = bboxes(j, 1); y_min = bboxes(j, 2); x_max = bboxes(j, 3); y_max = bboxes(j, 4);
        width = x_max - x_min + 1; height = y_max - y_min + 1;
        w_border = width - t; h_border = height - t;
        if y_min+floor(h_border/2) <=m && y_max-floor(h_border/2) <= m && x_min+floor(w_border/2) <= n && x_max-floor(w_border/2) <= n
            patch = img(y_min+floor(h_border/2):y_max-floor(h_border/2), x_min+floor(w_border/2):x_max-floor(w_border/2));
            patch = patch(1:t, 1:t);
            hog = vl_hog(patch, feature_params.hog_cell_size);
            [x, y, z] = size(hog);
            features_hard_neg = [features_hard_neg; reshape(hog, [1, x*y*z])];
        end
        j = j + 1;
    end
end
features_neg = [features_negative; features_hard_neg];
end