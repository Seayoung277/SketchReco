# SketchReco

This is a sketch recognizing system based on [Sketch classification and classification-driven analysis using Fisher vectors](http://dl.acm.org/citation.cfm?doid=2661229.2661231) with the sketch dataset provided by [Mathias Eitz](http://cybertron.cg.tu-berlin.de/eitz/).

In this project, I tried to implement the method provided in the paper. You can extract features, train classifiers and test the modles with the help of this project. Following the steps, you should be able to run this sketch recognizing system successfully.

- Install [VLFeat](http://www.vlfeat.org/) on your computer.
- First you should collect a train set and a test set from the original dataset. The original dataset contains 250 categories, and we recommand you start with a relatively small subset, UNLESS you have a powerful CPU and more than 32GB memory. Use command ```collect(10)``` to encode 10 categories of images. Other variables include:
