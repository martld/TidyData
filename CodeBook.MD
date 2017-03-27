
# Code Book

Human Activity Recognition using Smartphones Dataset and subsequent tidy data set.

## Source Data

The source data is available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The source data contains experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. 

More information about the dataset is available at: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Creating the Tidy Data Set 

The following files were used in the R script (run_analysis.R) to produce the tidy data set:

1.	X_test.txt <- set of test data; dim(2947,561) 
     testdata <- read.table("X_test.txt")

2.	y_test.txt <- Test data identifiers for activities; dim(2947,1)
    activitytest <- read.table("y_test.txt")

3.	subject_test.txt <- Test data identifiers for subjects; dim(2947,1)
    subjecttest <- read.table("subject_test.txt")

4.	X_train.txt <- set of training data; dim(7352,561)
    traindata <- read.table("X_train.txt")

5.	y_train.txt <- Training data identifiers for activities; dim(7352,1)
    activitytrain <- read.table("y_train.txt")

6.	subject_train.txt <- Training data identifiers for subjects; dim(7352,1)
    subjecttrain <- read.table("subject_train.txt")

7.	features.txt <- List of all features; dim(561,2)
    features <- read.table("features.txt")

8.	activity_labels.txt <- Descriptive labels for activities; dim(6,2)
    activitylabels <- read.table("activity_labels.txt")


The training and test data sets are merged into one data set called alldata. The data set is a derived using the following steps:

1.	Renaming columns in imported data so that they are easy to identify and use.

2.	Joining activity labels to the activity data sets so that they adequately describe each activity.

3.	Use cbind to append main data sets to activity and subject data sets for both test and training data. 

    testdata2 <- cbind(subjecttest, activitytest, testdata)
    traindata2 <- cbind(subjecttrain, activitytrain, traindata)

4.	Use rbind to bind the test and training files in the alldata file. 

    alldata <- rbind(testdata2, traindata2)


The resulting alldata file is further reshaped by eliminating some unwanted columns. Only the subject and activity columns and the appropriate columns for mean and standard deviation are retained. The feature columns are modifed with user friendly descriptions. Finally, the file is averaged and grouped by subject and activity and written to a text file.

1.	Using grepl to get TRUE for all columns I want to keep.

    getfinalcolumns <- (grepl("activity..",colnames(alldata)) | grepl("subject",colnames(alldata)) | grepl("-mean..",colnames(alldata))     & !grepl("-meanFreq..",colnames(alldata)) & !grepl("mean..-[X-Z]",colnames(alldata)) | grepl("-std..",colnames(alldata)) & !grepl("-     stdFreq..",colnames(alldata)) & !grepl("std..-[X-Z]",colnames(alldata)))

2.	Get just the columns I need for final data set

    alldata = alldata[getfinalcolumns==TRUE]

3.  Apply friendly column names for feature columns. I remove parentheses and replace abbreviations with longer names so that the           content of the columns is better understood.

    colnames(alldata) = gsub("\\()","",colnames(alldata))
    colnames(alldata) = gsub("^t","Time",colnames(alldata))
    colnames(alldata) = gsub("^f","Freq",colnames(alldata))
    colnames(alldata) = gsub("[Mm]ag","Magnitude",colnames(alldata))
    colnames(alldata) = gsub("Acc","Accel",colnames(alldata))
    colnames(alldata) = gsub("BodyBody","Body",colnames(alldata))

4.  Extract a data subset that is an average by subject and activity using ddply from plyr package.

    alldata_summary <- ddply(alldata, .(subject, activityID, activityDesc), function(m)colMeans(m[, 4:21]))

5.  Write final tidy data set to a file. The final data set has 180 rows (30 subjects with 6 activities each). It has 21 columns (1 each     for subject, activityID and activity description and the 18 selected features that use mean and standard deviation.

    write.table(alldata_summary, "tidy_data.txt", row.names=FALSE,sep='\t')

6.  Read the tidy data set back into R, if needed.
 
    tidydataset <- read.table("tidy_data.txt", header = TRUE)
