# SketchReco

This is a sketch recognizing system based on [Sketch classification and classification-driven analysis using Fisher vectors](http://dl.acm.org/citation.cfm?doid=2661229.2661231) with the sketch dataset provided by [Mathias Eitz](http://cybertron.cg.tu-berlin.de/eitz/).

In this project, I tried to implement the method provided in the paper. You can extract features, train classifiers and test the modles with the help of this project. Following the steps, you should be able to run this sketch recognizing system successfully. The whole project is implemented in MATLAB.

1. Install [VLFeat](http://www.vlfeat.org/) on your computer.

2. First you should collect a train set and a test set from the original dataset. The original dataset contains 250 categories, and we recommand you start with a relatively small subset, UNLESS you have a powerful CPU and more than 32GB memory. Use command ```collect(10)``` to encode 10 categories of images. Other variables include:
  - ```trainNum``` Number of images in the train set, default 70 min 1 max 79
  - ```descrNum``` Number of descriptors to evaluate GMM, default 25600, min 25600
  - ```binSize``` Bin size of dense SIFT, default 24 min 8 max 80
  - ```stepSize``` Step size of dense SIFT, default 8 min 1 max 24

3. Next you need to train the SVMs. The categories number should be the same as the value you entered in the last step. Use command ```train(10)``` to train SVMs for 10 categories. Other variables include:
  - ```lambda``` Lambda value for SVM, default 0.01
  - ```epsilon``` Epsilon value for SVM, default 0.0001
  - ```mod``` Use homogeneous kernel map or not, default none, options [none, hom]
  - ```order``` Order of homogeneous kernel map to use, default 0
  - ```diag```  Show SVM Diagnostics or not, default off, options [on, off]
  
4. Next step is optional. You can test the module accuracy with the test set collected in the first step. The categories number and train set size should be the same as the value you entered in the first step. Use command ```test(10)``` to test  10 categories. Other variables include:
  - ```trainNum``` Number of images in the train set, default 70 min 1 max 79
  - ```mod``` Use homogeneous kernel map or not, default none, options [none, hom]
  - ```order``` Order of homogeneous kernel map to use, default 0

5. Finally is the most exciting part! Run the ```gui.m``` file and sketch on the sketch board. Click ```Save``` to submit, the recognizing result will be shown on the right. Click ```Clean``` to clean the sketch board, and click ```Exit``` to exit.

6. We also provides testing tools so that you can find the best parameters.
  - ```testdsift.m``` can help you find the best value for ```binSize``` and ```stepSize```
  - ```testsvm.m``` can help you find the best value for ```lambda``` and ```epsilon```
  - ```testdim.m``` can help you find the best homogeneous kernel map order.
  
7. Testing accuracy results will be saved in ```test*.mat``` files. You can use ```mesh()``` function to intuitively see how the final accuracy changes when the parameters changes.
