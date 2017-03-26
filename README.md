# Getting and Cleaning Data Course
## Tidy Data Set Project

Larry Martin

## Overview

The purpose of the project is to provide an R script (run_analysis.R) that produces a tidy data set from the Human Activity Recognition using Smartphones Dataset. The source data is available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

More information about the dataset is available at: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Project Summary

Provide an R script called run_analysis.R that does the following:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Data Used
The following files were extracted from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and placed in a single folder. Each is read into the R script and combined as needed to produce the final tidy data set. The dimensions have been provided below to indicate how each file fits with the others.
 
1. X_test.txt <- set of test data; dim(2947,561)
2. y_test.txt <- Test data identifiers for activities; dim(2947,1)
3. subject_test.txt <- Test data identifiers for subjects; dim(2947,1)
4. X_train.txt <- set of training data; dim(7352,561)
5. y_train.txt <- Training data identifiers for activities; dim(7352,1)
6. subject_train.txt <- Training data identifiers for subjects; dim(7352,1)
7. features.txt <- List of all features; dim(561,2)
8. activity_labels.txt <- Descriptive labels for activities; dim(6,2)

More information on the data sets is provided in the accompanying Code Book.

## Data Output
The final output of the R script is a tidy data set that is an average of the mean and standard deviation measures rolled up by Subject and Activity. The output file is called "tidy_data.txt". To read the file back into R use: tidydataset <- read.table("tidy_data.txt", header = TRUE).

The final data set has 180 rows (30 subjects with 6 activities each) and 21 columns (1 each for subject, activity ID and activity description and the 18 selected features that use mean and standard deviation).
