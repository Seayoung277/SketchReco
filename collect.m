function collect(catNum, varargin)

% ---------- Parse Parameters ----------
p = inputParser;
defaultTrainNum = 70;
defaultDescrNum = 25600;
defaultBinSize = 24;
defaultStepSize = 8;
addRequired(p, 'catNum', @(x) (x>=2)&&(x<=250));
addOptional(p, 'trainNum', defaultTrainNum, @(x) (x>0)&&(x<80));
addOptional(p, 'descrNum', defaultDescrNum, @(x) (x>=25600))
addOptional(p, 'binSize', defaultBinSize, @(x) (x>=8)&&(x<=80));
addOptional(p, 'stepSize', defaultStepSize, @(x) (x>0)&&(x<=24));
parse(p, catNum, varargin{:});

% ---------- Init Parameters ----------
load('sketches.mat');
n = p.Results.catNum;
tn = p.Results.trainNum;
descrNum = p.Results.descrNum;
binSize = p.Results.binSize;
stepSize = p.Results.stepSize;
numClusters = 256;
dimention = 40960;
trainData = zeros(dimention, (tn * n)) ;
trainLabel = -1 * ones((tn * n), n) ;
testData = zeros(dimention, ((80 - tn) * n)) ;
testLabel = -1 * ones(((80 - tn) * n), n) ;
labelCount = 1 ;
lastLabel = sketches{1,2} ;
diction = [];

% ---------- DSIFT ----------
for i = 1:(80 * n)
    % ---------- Read Image ----------
    fprintf('Image %d Read\r', i) ;
    image = single(imread(['png/',num2str(i),'.png'])) ;
    
    % ---------- DSIFT ----------
    [~, descrs] = vl_dsift(image, 'size', binSize, 'step', stepSize) ;
    
    diction = [diction descrs];
end

% ---------- PCA ----------
diction = single(diction) ;
pcaMatrix = pca(diction') ;
transMatrix = pcaMatrix(:, 1:80) ;
diction = (diction' * transMatrix)' ;

% ---------- Pick Descrips ----------
if size(diction, 2) > descrNum
    idx = randperm(size(diction, 2));
    idx = idx(1:descrNum);
    gmm = diction(:, idx);
end
    
% ---------- GMM ----------
fprintf('Preparing GMM\r') ;
[means, covariances, priors] = vl_gmm(gmm, numClusters);
save('gmm', 'means', 'covariances', 'priors');

for i = 1:(80 * n)
    dim = size(diction, 2) / (80 * n);
    % ---------- Fisher ----------
    descrs = diction(:, ((i-1)*dim+1):(i*dim)) ;
    encode = vl_fisher(descrs, means, covariances, priors) ;

    % ---------- Save Data ----------
    if mod(i-1, 80) >= tn
        testData(:, (i - ceil(i / 80) * tn)) = encode ;
    else
        trainData(:, (i - floor(i / 80) * (80 - tn))) = encode ;
    end
    
    % ---------- Save Label ----------
    if ~strcmp(sketches{i,2}, lastLabel)
        labelCount = labelCount + 1 ;
    end
    if mod(i-1, 80) >= tn
        testLabel((i - ceil(i / 80) * tn), labelCount) = 1 ;
    else
        trainLabel((i - floor(i / 80) * (80 - tn)), labelCount) = 1 ;
    end
    lastLabel = sketches{i,2} ;
    
    % ---------- All Finished ----------
    fprintf('Image %d Finished\r', i) ;
end

% ---------- Save Files ----------
save('trainSet.mat', 'trainData', 'trainLabel', '-v7.3') ;
save('testSet.mat', 'testData', 'testLabel', '-v7.3') ;
