# SVM 

This repository contains some work with SVM.


## Resources
Some cool resources I have found about the topic
- https://research.wu.ac.at/en/publications/benchmarking-support-vector-machines-9
- https://www.cs.cmu.edu/~aarti/Class/10315_Fall20/lecs/svm.pdf
- https://www.cs.cornell.edu/courses/cs4780/2022sp/notes/LectureNotes13.html
- https://www.seas.upenn.edu/~cis5190/spring2019/lectures/07_SVMs.pdf

## SVM with R

### Iris One Dimensional
Graph of setosa (red) and virgina (blue)

![alt text](./images/iris_one_dim.png)

### Iris Two Dimensional
| Linear                        | Polynomial                        |
| ----------------------------- | --------------------------------- |
| ![](./images/iris_linear.png) | ![](./images/iris_polynomial.png) |

| RDF                           | Sigmoid                        |
| ----------------------------- | ------------------------------ |
| ![](./images/iris_radial.png) | ![](./images/iris_sigmoid.png) |

### Iris Three Dimens

![alt text](./images/iris_three_dim_linear.png)


### XoR
![alt text](./images/xor_radial.png)


### Inner Outer 
| 2D                                      | 3D                              |
| --------------------------------------- | ------------------------------- |
| ![alt text](./images/inner_outer2d.png) | ![](./images/inner_outer3d.png) |


### Heteroscedascity
| Before                                       | SVM Radial                                          |
| -------------------------------------------- | --------------------------------------------------- |
| ![alt text](./images/heteroscedasticity.png) | ![alt text](./images/heteroscedasticity_radial.png) |

## Downstream Tasks
### Face Recognition

When the testing dataset size is (656, 2914) and training dataset is (164, 2914) with 4 different classes (4 different faces), a `make_pipeline` with `RandomizedPCA(n_components=150)` and `SVC(kernel='rbf', class_weight="balanced")`, we have a training time and accuracy of.

Training time: 4.62
Accuracy: 89.02%

| Unique Counts                                        | Confusion Matrix                                           |
| ---------------------------------------------------- | ---------------------------------------------------------- |
| ![alt text](./images/facerecogniton_4categories.png) | ![alt text](./images/facerecognition_4categories_conf.png) |


Compared to a simple `MLPClassifier` with a hiddenlayer of 1024.

Training time:  6.31894588470459
Accuracy: 92.07


Now, what if we increase the dataset size?


### Text Classification
The original analysis can be found in `./Downstream/textclassification.ipynb`. Now, this dataset is much bigger compared to the facial recognition with a training set of (41157, 5000) for training and (3798, 500) and for testing. 

This is in a sense a sentiment analysis problem, where tweets are given a sentiment of one of 5 classes whose distribution is shown below.

![alt text](./images/textclass_sentiment_dist.png)

![alt text](./images/textclass_lin_svm_training_time.png)

Inference time is also extremely slow.

![alt text](./images/textclass_lin_svm_acc.png)

The training time is extremely long. 

Let's compare this to a simple linear regression classifier.

Here is the heatmap side by side.

| SVM Linear                                     | Linear Regression                         |
| ---------------------------------------------- | ----------------------------------------- |
| ![alt text](./images/textclass_lin_svm_cm.png) | ![alt text](./images/textclass_lr_cm.png) |

In terms of accuracy, SVM does perform better. However, it is not worth the training cost.


Now let's compare these results to a simple LSTM recurrent neural network. It should be noted that training was also done on CPU.

### Stock Market analysis
In this example, we see that SVM can be used for regression tasks as well.

Here we select a couple of features.
![alt text](./images/stockmarketanalysis_svm0.png)

This produces a mean squared error of 


Here we add one other feature, `Previous Close`. 
![alt text](./images/stockmarketanalysis_sv1.png)