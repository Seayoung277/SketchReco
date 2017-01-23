%Input: img - Image matrix of size 480x480
%		ncl - Number of clusters to return
%Output: candi - Array of size ncl with candidates number

function candi = rec(img, ncl)

% ---------- Init Parameters ----------
load('paras.mat');
load('gmm.mat');
binSize = 56 ;
step = 8 ;
img = single(img(:,:,1)) ;

[~, descrs] = vl_dsift(img, 'size', binSize, 'step', step) ;
descrs = single(descrs);
%pcaMatrix = pca(descrs') ;
%transMatrix = pcaMatrix(:, 1:80) ;
%descrs = (descrs' * transMatrix)' ;
encode = vl_fisher(descrs, means, covariances, priors) ;
result = encode' * weight + offset ;
candi = zeros(1, ncl) ;
for i = 1:ncl
	[~, label] = max(result, [], 2) ;
	candi(1, i) = label ;
	result(1, label) = min(result) - 1 ;
end