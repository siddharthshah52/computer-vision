function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter, 'symmetric');

%%%%%%%%%%%%%%%%
% Pad the image using reflection
[m, n] = size(filter);

m = floor(m/2);
n = floor(n/2);

padded_im = padarray(image, [m, n], 'symmetric');

% Reshape in case of grayscale image
sz = size(padded_im);
if size(sz) == 2
    padded_im = reshape(padded_im, sz(1), sz(2), 1);
end

% create output image of size same as input and fill with zeros
dim = size(image);
h = dim(1);
w = dim(2);
if length(dim) == 3
    d = dim(3);
else
    d = 1;
end

output_im = zeros(h, w, d);

% apply filter along each dimension
for i = 1+m:h+m
    for j = 1+n:w+n
        for k = 1: d
            output_im(i-m, j-n, k) = sum(dot(padded_im(i-m:i+m, j-n:j+n, k), filter));
        end
    end
end

% reshape output in case of grayscale image
output_dims = size(output_im);
if size(sz) == 2
    output_im = reshape(output_im, output_dims(1), output_dims(2));
end

% return
output = output_im;
%%%%%%%%%%%%%%%%





