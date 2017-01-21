% assumes img is grayscale
function hog = my_hog(img, cell_size)
[m, n] = size(img);
histograms = zeros(floor(m/cell_size), floor(n/cell_size), 9);
[Gmag, Gdir] = imgradient(img, 'central');
for i=1:cell_size:cell_size*(floor(m/cell_size))
    for j=1:cell_size:cell_size*(floor(n/cell_size))
        Gmag_binned = zeros(9, 1);
        Gmag_patch = Gmag(i:i+cell_size-1, j:j+cell_size-1);
        Gmag_patch = Gmag_patch(:);
        Gdir_patch = Gdir(i:i+cell_size-1, j:j+cell_size-1);
        Gdir_patch = abs(Gdir_patch(:));
        for k=1:size(Gdir_patch)
            bin_idx = min(floor(Gdir_patch(k)/20) + 1, 9);
            % no bilinear interpolation
            Gmag_binned(bin_idx) = Gmag_binned(bin_idx) + Gmag_patch(k);
        end
        histograms(floor(i/cell_size)+1, floor(j/cell_size)+1, :) = Gmag_binned;
    end
end

% block normalization
hist_padded = padarray(histograms, [1, 1], 'replicate');
hog = zeros(floor(m/cell_size), floor(n/cell_size), 36);
[m, n, ~] = size(hist_padded);
epsilon = 0.1;
for i=1:m-2
    for j=1:n-2
        patch = hist_padded(i:i+1, j:j+1, :);
        patch = patch(:);
        l2_norm = sqrt(sum(patch.^2) + epsilon^2);
        hog(i,j,:) = patch / l2_norm;
    end
end
end