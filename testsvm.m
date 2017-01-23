function testsvm
accuracy = [];
eps = [];
lrange = [10 3 1 0.3 0.1 0.03 0.01 0.003 0.001 0.0003 0.0001 0.00003 0.00001 0.000003 0.000001];
erange = [10 3 1 0.3 0.1 0.03 0.01 0.003 0.001 0.0003 0.0001 0.00003 0.00001 0.000003 0.000001];

collect(10);
for lambda = range
    for epsilon = range
        train(10, 'lambda', lambda, 'epsilon', epsilon);
        result = test(10);
        eps = [eps result];
    end
    accuracy = [accuracy; eps];
    eps = [];
end
save(['testsvm', 'accuracy');
