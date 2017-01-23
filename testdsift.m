function testdsift
accuracy = zeros(8, 6);
for binSize=8:8:64
    for stepSize=4:4:24
        fprintf('Testing binSize %d stepSize %d\n', binSize, stepSize);
        collect(10, 'binSize', binSize, 'stepSize', stepSize);
        train(10);
        result = test(10);
        accuracy(binSize/8, stepSize/4) = result;
    end
end
save('testdsift.mat', 'accuracy');
