function accuracy=test(catNum, varargin)

% ---------- Parse Parameters ----------
p = inputParser;
defaultTrainNum = 70;
defaultMod = 'none';
defaultOrder = 0;
modOp = {'none', 'hom'};
addRequired(p, 'catNum', @(x) (x>=2)&&(x<=250));
addOptional(p, 'trainNum', defaultTrainNum, @(x) (x>0)&&(x<80));
addOptional(p, 'mod', defaultMod, @(x) any(validatestring(x,modOp)));
addOptional(p, 'order', defaultOrder, @(x) x>=0);
parse(p, catNum, varargin{:});

% ---------- Init Parameters ----------
load('testSet.mat');
load('paras.mat');
n = p.Results.catNum;
tn = p.Results.trainNum;
mod = p.Results.mod;
order = p.Results.order;
result = zeros(n, (80 - tn) * n);
s = zeros(1, (80 - tn) * n) ;
for i = 1 : ((80 - tn) * n)
    s(i) = ceil(i / (80 - tn)) ;
end

% ---------- Main Loop ----------
switch(mod)
    case 'none'
        for i = 1:n
            [~, ~, ~, scores] = vl_svmtrain(testData, testLabel(:, i), 0, 'model', weight(:, i), 'bias', offset(i), 'solver', 'none');
            result(i, :) = scores;
        end
    case 'hom'
        hom.kernel = 'KChi2' ;
        hom.order = order;
        dataset = vl_svmdataset(testData, 'homkermap', hom) ;
        for i = 1:n
            [~, ~, ~, scores] = vl_svmtrain(dataset, testLabel(:, i), 0, 'model', weight(:, i), 'bias', offset(i), 'solver', 'none');
            result(i, :) = scores;
        end
end
[~, cluster] = max(result, [], 1) ;
accuracy = sum(cluster == s) / ((80 - tn) * n) ;
fprintf('Accuracy: %f\n', accuracy) ;