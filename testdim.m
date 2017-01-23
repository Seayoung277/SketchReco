function testdim
accuracy = zeros(4,1);
collect(5);

train(5);
result = test(5);
accuracy(1) = result;

train(5, 'mod', 'hom', 'order', 0);
result = test(5, 'mod', 'hom', 'order', 0);
accuracy(2) = result;

train(5, 'mod', 'hom', 'order', 1);
result = test(5, 'mod', 'hom', 'order', 1);
accuracy(3) = result;

train(5, 'mod', 'hom', 'order', 2);
result = test(5, 'mod', 'hom', 'order', 2);
accuracy(4) = result;

save('testdim.mat', 'accuracy');