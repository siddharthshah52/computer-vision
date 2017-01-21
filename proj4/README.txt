To run the basic tiny images, get bags of sifts, nearest neighbors and svm run the code as expected.

The following extra credit have been implemented. Also the corresponding way to execute is given:

1. Gaussian pyramid: Use FEATURE = 'gaussian pyramid' in proj4.m which uses the get_bags_of_sifts_gaussian_pyramid.m
2. Gist descriptors: Use FEATURE = 'complementary features' in proj4.m which uses the get_bags_of_sifts_gaussian_pyramid.m
3. Self-similarity descriptors: Use FEATURE = 'complementary features' in proj4.m which uses the get_bags_of_sifts_gaussian_pyramid.m. Also uncomment the self-similarity descriptor section in proj4.m and get_bags_of_sifts_gaussian_pyramid.m which uses ssdesc.m. You might have to run the mex file before
4. Fisher: Use FEATURE = 'fisher' in proj4.m which uses build_vocabulary_gmm if needed and then uses get_fisher.m to create fisher vectors.
5. Spatial pyramid: Use FEATURE = 'spatial pyramid' in proj4.m  which uses spatial_pyramid.m to generate features.
6. For cross-validation run proj4_cross_validation.m.
7. Vocabulary size has to be changed manually in proj4.m as required