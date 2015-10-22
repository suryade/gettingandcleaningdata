# Introduction

### Source Data
A full description of the data used in this project can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[The source data for this project can be found here.](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)


### The R Script
There are 3 functions in the R script that will accomplish all the requirements of the assignment. The first function is called mergeAllData and that accomplishes requirements 1, 3 and 4 of the assignment. The mergeAllData function requires the end user to pass in as an argument the directory where the UCI data is stored in an unalatered format. 

The second function in the script called extractMeanStdData handles the 2nd requirement of the assignment. It takes in the output of the mergeAllData as its argument.

The third function in the script called tidyDataFrame satisfies the 5th requirement of the assignment and also writes the data set to a file called averages.txt which is also going to be uploaded to the github repository.

### Files and transformations to achieve assignment goals
The following files were required to be ingested by the mergeAllData function to produce a data frame that had appropriately renamed columns and merged both the train and the test data to satisfy requirements 1, 3 and 4 of the assignment:
- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

Further in depth step by step instructions are present in the run_analysis.R script