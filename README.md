# SketchReco

This is a sketch recognizing system based on [Sketch classification and classification-driven analysis using Fisher vectors](http://dl.acm.org/citation.cfm?doid=2661229.2661231) with the sketch dataset provided by [Mathias Eitz](http://cybertron.cg.tu-berlin.de/eitz/).

In this project, I tried to implement the method provided in the paper. You can extract features, train classifiers and test the modles with the help of this project. Following the steps, you should be able to run this sketch recognizing system successfully. The whole project is implemented in MATLAB.

1. Install [VLFeat](http://www.vlfeat.org/) on your computer.

2. First you should collect a train set and a test set from the original dataset. The original dataset contains 250 categories, and we recommand you start with a relatively small subset, UNLESS you have a powerful CPU and more than 32GB memory. Use command ```collect(10)``` to encode 10 categories of images. Other variables include:
  - trainNum    Number of images in the train set, default 70 min 1 max 79
  - descrNum    Number of descriptors to evaluate GMM, default 25600, min 25600
  - binSize     Bin size of dense SIFT, default 24 min 8 max 80
  - stepSize    Step size of dense SIFT, default 8 min 1 max 24
