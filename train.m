function train(catNum, varargin)

% ---------- Parse Parameters ----------
p = inputParser;
defaultLambda = 0.01;
defaultEpsilon = 0.0001;
defaultMod = 'none';
defaultOrder = 0;
defaultDiag = 'off';
modOp = {'none', 'hom'};
diagOp = {'on', 'off'};
addRequired(p, 'catNum', @(x) (x>=2)&&(x<=250));
addOptional(p, 'lambda', defaultLambda, @(x) (x>0)&&(x<=10));
addOptional(p, 'epsilon', defaultEpsilon, @(x) (x>0)&&(x<=10));
addOptional(p, 'mod', defaultMod, @(x) any(validatestring(x,modOp)));
addOptional(p, 'order', defaultOrder, @(x) x>=0);
addOptional(p, 'diag', defaultDiag, @(x) any(validatestring(x,diagOp)));
parse(p, catNum, varargin{:});

% ---------- Init Parameters ----------
load('trainSet.mat');
n = p.Results.catNum;
lambda = p.Results.lambda;
epsilon = p.Results.epsilon;
mod = p.Results.mod;
order = p.Results.order;
diag = p.Results.diag;
maxIter = 1000000;
dim = 40960;
weight = zeros(dim * (2 * order + 1), n);
offset = zeros(1, n);

% ---------- Main Loop ----------
switch(mod)
    case 'none'
        for i = 1:n
            switch(diag)
                case 'off'
                    [w, b, info] = vl_svmtrain(trainData, trainLabel(:, i), lambda, ...
                        'Solver', 'SDCA', ...
                        'Loss', 'HINGE2', ...
                        'Epsilon', epsilon, ...
                        'MaxNumIterations', maxIter);
                case 'on'
                    figure(i); title(['Cluster ', num2str(i)]);
                    [w, b, info] = vl_svmtrain(trainData, trainLabel(:, i), lambda, ...
                        'Solver', 'SDCA', ...
                        'Loss', 'HINGE2', ...
                        'Epsilon', epsilon, ...
                        'MaxNumIterations', maxIter, ...
                        'DiagnosticFunction',@diagnostics, ...
                        'DiagnosticFrequency',500) ;
                    print(i, '-dpng', ['Cluster', num2str(i)]);
            end
            weight(:, i) = w;
            offset(i) = b;
            fprintf('SVM %d Finished\r', i);
        end
    case 'hom'
        hom.kernel = 'KChi2' ;
        hom.order = order;
        dataset = vl_svmdataset(trainData, 'homkermap', hom) ;
        for i = 1:n
            switch(diag)
                case 'off'
                    [w, b, info] = vl_svmtrain(dataset, trainLabel(:, i), lambda, ...
                        'Solver', 'SDCA', ...
                        'Loss', 'HINGE2', ...
                        'Epsilon', epsilon, ...
                        'MaxNumIterations', maxIter);
                case 'on'
                    figure(i); title(['Cluster ', num2str(i)]);
                    [w, b, info] = vl_svmtrain(dataset, trainLabel(:, i), lambda, ...
                        'Solver', 'SDCA', ...
                        'Loss', 'HINGE2', ...
                        'Epsilon', epsilon, ...
                        'MaxNumIterations', maxIter, ...
                        'DiagnosticFunction',@diagnostics, ...
                        'DiagnosticFrequency',500) ;
                    print(i, '-dpng', ['Cluster', num2str(i)]);
            end
            weight(:, i) = w ;
            offset(i) = b ;
            fprintf('SVM %d Finished\n', i) ;
        end
end

% ---------- Close Figure ----------
if(strcmp(diag, 'on'))
    close all;
end

% ---------- Save Model ----------
save('paras.mat', 'weight', 'offset', '-v7.3');
end

% ---------- Diag Function ----------
function diagnostics(svm)
    persistent energy ;
    energy = [energy [svm.objective ; svm.dualObjective ; svm.dualityGap ] ] ;
    l = uint8(size(energy, 2));
    if((size(energy, 2)>2)&&(energy(3, l)/energy(3, l-1)>100))
        energy = [svm.objective ; svm.dualObjective ; svm.dualityGap];
    end
    hold on
    plot(energy(1,:),'--b') ;
    plot(energy(2,:),'-.g') ;
    plot(energy(3,:),'r') ;
    legend('Primal objective','Dual objective','Duality gap')
    xlabel('Diagnostics iteration')
    ylabel('Energy')
    hold off
    pause(0.001);
end
